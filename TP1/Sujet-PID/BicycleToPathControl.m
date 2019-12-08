function [ u ] = BicycleToPathControl( xTrue, Path )
%Computes a control to follow a path for bicycle
%   xTrue is the robot current pose : [ x y theta ]'
%   Path is set of points defining the path : [   x1     x2   ... ;
%                                                 y1     y2   ... ;
%                                               theta1 theta2 ... ]
%   u is the control : [v phi]'

% Control parameters
Krho = 5;
Kalpha = 7.8;
step = 0.49;

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

rho_next = sqrt((xTrue(1,1)-discrete_path(1,pt_next))^2 + (xTrue(2,1)-discrete_path(2,pt_next))^2);
alpha_next = AngleWrap(atan2(discrete_path(2,pt_next)-xTrue(2,1), discrete_path(1,pt_next)-xTrue(1,1)) - xTrue(3,1));

%% Control action
u(1,1) = Krho*rho_next;
u(2,1) = Kalpha*alpha_next;

end