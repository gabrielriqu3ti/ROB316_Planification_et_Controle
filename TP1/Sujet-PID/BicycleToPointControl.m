function [ u ] = BicycleToPointControl( xTrue,xGoal )
%Computes a control to reach a pose for bicycle
%   xTrue is the robot current pose : [ x y theta ]'
%   xGoal is the goal point
%   u is the control : [v phi]'
%   Author : Gabriel H. Riqueti
%   Orientator : David Filliat

% Paramètres de commande
Kp = 18;
Kalpha = 10;

rho = sqrt((xTrue(1,1)-xGoal(1,1))^2 + (xTrue(2,1)-xGoal(2,1))^2);
alpha = AngleWrap(atan2(xGoal(2,1)-xTrue(2,1), xGoal(1,1)-xTrue(1,1)) - xTrue(3,1));
u(1,1) = Kp*rho;
u(2,1) = Kalpha*alpha;

end

