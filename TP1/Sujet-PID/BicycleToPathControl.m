function [ u ] = BicycleToPathControl( xTrue, Path )
%Computes a control to follow a path for bicycle
%   xTrue is the robot current pose : [ x y theta ]'
%   Path is set of points defining the path : [   x1     x2   ... ;
%                                                 y1     y2   ... ;
%                                               theta1 theta2 ... ]
%   u is the control : [v phi]'

% Paramètres de commande
Kp = 1;
Kalpha = 1;
rho_min = 1;
%alpha_min = pi/4;

nPt = size(Path,2);
step = 0.5;
n_disc_path = 1;
for pt=1:nPt-1
    n_disc_path = n_disc_path + round(sqrt((xTrue(1,1)-Path(1,pt))^2 + (xTrue(2,1)-Path(2,pt))^2)/step);
end

discrete_path = zeros(2,n_disc_path);
ndisc_path_old = 0;
for pt=1:nPt-1
    ndisc_path_current = round(sqrt((xTrue(1,1)-Path(1,pt))^2 + (xTrue(2,1)-Path(2,pt))^2)/step);
    alpha = AngleWrap(atan2(Path(2,pt+1)-Path(2,pt), Path(1,pt+1)-Path(1,pt)));
    discrete_path(1,ndisc_path_old+1) = Path(1,pt);
    discrete_path(2,ndisc_path_old+1) = Path(1,pt);
    for disc_pt=2:ndisc_path_current
        discrete_path(1,pt+disc_pt) = step*sin(alpha);
        discrete_path(2,pt+disc_pt) = step*cos(alpha);
    end
    ndisc_path_old = ndisc_path_old + ndisc_path_current;
end

rho_closest = sqrt((xTrue(1,1)-Path(1,1))^2 + (xTrue(2,1)-Path(2,1))^2);
pt_next = 2;
for pt=2:nPt
    rho = sqrt((xTrue(1,1)-Path(1,pt))^2 + (xTrue(2,1)-Path(2,pt))^2);
    if rho<rho_closest
        rho_closest = rho;
        pt_next = pt+1;
    end
end

if pt_next > nPt
    pt_next = nPt;
end

rho_next = sqrt((xTrue(1,1)-Path(1,pt_next))^2 + (xTrue(2,1)-Path(2,pt_next))^2);
alpha_next = AngleWrap(atan2(Path(2,pt_next)-xTrue(2,1), Path(1,pt_next)-xTrue(1,1)) - xTrue(3,1));

u(1,1) = Kp*rho_next;
u(2,1) = Kalpha*alpha_next;

end