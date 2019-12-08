function [ u ] = BicycleToPointControl( xTrue,xGoal )
%Computes a control to reach a pose for bicycle
%   xTrue is the robot current pose : [ x y theta ]'
%   xGoal is the goal point
%   u is the control : [v phi]'


% Paramètres de commande
Kp = 1.0;
Kalpha = 1.0;

rho = sqrt((xTrue(1,1)-xGoal(1,1))^2 + ()^2)

end

