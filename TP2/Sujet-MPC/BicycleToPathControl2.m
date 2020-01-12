function [ u ] = BicycleToPathControl2( xTrue, Path )
%Computes a control to follow a path for bicycle
%   xTrue is the robot current pose : [ x y theta ]'
%   Path is set of points defining the path : [ x1 x2 ...
%                                               y1 y2 ...]
%   u is the control : [v phi]'

persistent goalWaypointId xGoal;

%set first waypoint and goal on the path when starting trajectory
if xTrue == [0;0;0]
    goalWaypointId = 1;
    xGoal = Path(:,1);
end

dt = .01; % integration time (same than simulation)

%% define goals and size of window
window_size = 1000;   %1 : anticipe, 5 : anticipe bien, controle plus souple, 
%20 : coupe un peu, controle très souple, 100 : coupe un peu, 1000 : triche !
vmax = 1.0;
dmax = vmax * dt; %distance max for one step

step = dmax;

%% 	Count size of the discretesized path
nPt = size(Path,2);
n_disc_path = 1;
for pt=1:nPt-1
    n_disc_path = n_disc_path + round(sqrt((Path(1,pt+1)-Path(1,pt))^2 + (Path(2,pt+1)-Path(2,pt))^2)/step);
end

%% 	Create the discretesized path
discrete_path = zeros(3,n_disc_path);
ndisc_path_old = 0;
for pt=1:nPt-1
    ndisc_path_current = round(sqrt((Path(1,pt+1)-Path(1,pt))^2 + (Path(2,pt+1)-Path(2,pt))^2)/step);
    alpha = atan2(Path(2,pt+1)-Path(2,pt), Path(1,pt+1)-Path(1,pt));
    discrete_path(:,ndisc_path_old+1) = Path(:,pt);
    for disc_pt=1:ndisc_path_current
        discrete_path(1,ndisc_path_old+disc_pt) = Path(1,pt) + (disc_pt-1)*step*cos(alpha);
        discrete_path(2,ndisc_path_old+disc_pt) = Path(2,pt) + (disc_pt-1)*step*sin(alpha);
        discrete_path(3,ndisc_path_old+disc_pt) = Path(3,pt);
    end
    ndisc_path_old = ndisc_path_old + ndisc_path_current;
end
discrete_path(:,n_disc_path) = Path(:,nPt);

%% Evaluate next point
rho_closest = sqrt((xTrue(1,1)-discrete_path(1,1))^2 + (xTrue(2,1)-discrete_path(2,1))^2);
pt_next = 1;
for pt=2:n_disc_path
    rho = sqrt((xTrue(1,1)-discrete_path(1,pt))^2 + (xTrue(2,1)-discrete_path(2,pt))^2);
    if rho<rho_closest
        rho_closest = rho;
        pt_next = pt+1;
    end
end

if pt_next > n_disc_path
    pt_next = n_disc_path;
end

list_points = zeros(3,window_size);
xtemp = xTrue; %start from our position
pt = 1;

%%TODO : remplir la liste de points en suivant l'explication dans le sujet
for pt=1:window_size
    xNearGoal = zeros(3,1);
    if goalWaypointId ~= nPt
        if sqrt((discrete_path(1,pt+pt_next-1) - xTrue(1,1))^2 + (discrete_path(2,pt+pt_next-1) - xTrue(2,1))^2) < dmax
            list_points(:,pt) = discrete_path(:,pt+pt_next-1);
        else
            alpha = atan2(discrete_path(2,pt+pt_next-1)-xTrue(2,1), discrete_path(1,pt+pt_next-1)-xTrue(1,1));
            xNearGoal(1,1) = xTrue(1,1) + pt*dmax*cos(alpha);
            xNearGoal(2,1) = xTrue(2,1) + pt*dmax*sin(alpha);
            xNearGoal(3,1) = discrete_path(3,pt+pt_next-1);
            list_points(:,pt) = xNearGoal;
        end
        if pt+pt_next-1 == n_disc_path
            goalWaypointId = nPt;
        end
    else
        list_points(:,pt) = Path(:,nPt);
    end
end
anticipation = window_size;  %which future points is the objective

%% Then perform P control
Krho = 200;
Kalpha = 5;

error = list_points(:,anticipation) - xTrue;
goalDist = norm(error(1:2));
AngleToGoal = AngleWrap(atan2(error(2),error(1)) - xTrue(3,1));

u(1) = Krho * goalDist/(window_size*10); %vitesse bornÃ©e
u(2) = Kalpha * AngleToGoal;

end

