function [ u ] = BicycleToPathControl2( xTrue, Path )
%Computes a control to follow a path for bicycle
%   xTrue is the robot current pose : [ x y theta ]'
%   Path is set of points defining the path : [ x1 x2 ...
%                                               y1 y2 ...]
%   u is the control : [v phi]'

persistent goalWaypointId xGoal;

%set first waypoint and goal on the path when starting trajectory
if xTrue==[0;0;0]
    goalWaypointId=1;
    xGoal=Path(:,1);
end

rho=0.3;
dt=.01; % integration time (same than simulation)

%% 	Count size of the discretesized path
nPt = size(Path,2);
n_disc_path = 1;
for pt=1:nPt-1
    n_disc_path = n_disc_path + round(sqrt((Path(1,pt+1)-Path(1,pt))^2 + (Path(2,pt+1)-Path(2,pt))^2)/step);
end

%% 	Create the discretesized path
discrete_path = zeros(2,n_disc_path);
ndisc_path_old = 0;
for pt=1:nPt-1
    ndisc_path_current = round(sqrt((Path(1,pt+1)-Path(1,pt))^2 + (Path(2,pt+1)-Path(2,pt))^2)/step);
    alpha = atan2(Path(2,pt+1)-Path(2,pt), Path(1,pt+1)-Path(1,pt));
    discrete_path(1,ndisc_path_old+1) = Path(1,pt);
    discrete_path(2,ndisc_path_old+1) = Path(2,pt);
    for disc_pt=1:ndisc_path_current
        discrete_path(1,ndisc_path_old+disc_pt) = Path(1,pt) + (disc_pt-1)*step*cos(alpha);
        discrete_path(2,ndisc_path_old+disc_pt) = Path(2,pt) + (disc_pt-1)*step*sin(alpha);
    end
    ndisc_path_old = ndisc_path_old + ndisc_path_current;
end
discrete_path(1,n_disc_path) = Path(1,nPt);
discrete_path(2,n_disc_path) = Path(2,nPt);

%% Evaluate next point
rho_closest = sqrt((xTrue(1,1)-discrete_path(1,1))^2 + (xTrue(2,1)-discrete_path(2,1))^2);
pt_next = 2;
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


%% define goals and size of window
window_size=5;   %1 : anticipe, 5 : anticipe bien, controle plus souple, 
%20 : coupe un peu, controle très souple, 100 : coupe un peu, 1000 : triche !
vmax=2.0;
dmax = vmax * dt; %distance max for one step

list_points=[];
xtemp=xTrue; %start from our position


%%TODO : remplir la liste de points en suivant l'explication dans le sujet
while size(list_points,2) < window_size
    if norm(xGoal-xTrue) < dmax
        list_points.append(xGoal);
    else
        alpha = atan2(xGoal(2,1)-xTrue(2,1), xGoal(1,1)-xTrue(1,1));
        xGoal(1,1) = xTrue(1,1) + window_size*sin(theta);
        xGoal(2,1) = xTrue(2,1) + window_size*cos(theta);
        xGoal(3,1) = theta;
        list_points.append(xGoal);
    end
    list_points.append();
    anticipation = window_size;  %which future points is the objective
%% Then perform P control
    Krho=7;
    Kalpha=5;
 
    error=list_points(:,anticipation)-xTrue;
    goalDist=norm(error(1:2));
    AngleToGoal = AngleWrap(atan2(error(2),error(1))-xTrue(3));

    u(1) = Krho * goalDist/(window_size*10); %vitesse bornÃ©e
    u(2) = Kalpha*AngleToGoal;

    goalWaypointId = goalWaypointId + 1;
    xGoal=discrete_path(:,goalWaypointId);
end

