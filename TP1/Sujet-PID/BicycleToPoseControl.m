function [ u ] = BicycleToPoseControl( xTrue,xGoal )
%Computes a control to reach a pose for bicycle
%   xTrue is the robot current pose : [ x y theta ]'
%   xGoal is the goal point
%   u is the control : [v phi]'
%   Author : Victor K. Kobayashi Nascimento
%   Orientator : David Filliat

% Paramètres du commande
Krho      = 5;
Kalpha    = 20;
Kbeta     = -9;

u = [0;0;0];

% RHO
rho    = sqrt((xGoal(1,1) - xTrue(1,1))^2 + (xGoal(2,1)- xTrue(2,1))^2);

% ALPHA
alpha  = AngleWrap(atan2(xGoal(2,1)- xTrue(2,1), xGoal(1,1)- xTrue(1,1)) - xTrue(3,1));

% V
u(1,1) = Krho*rho;

% BETA
%beta = AngleWrap(AngleWrap(xGoal(3,1)) - AngleWrap(xTrue(3,1)));
%beta = AngleWrap(xGoal(3,1)) - AngleWrap(xTrue(3,1));
beta = AngleWrap(xGoal(3,1) - xTrue(3,1));

% PHI
if (Kbeta < 0)
    u(2,1) = Kalpha*alpha + Kbeta*beta;
else
    u(2,1) = Kalpha*alpha;
end

end
