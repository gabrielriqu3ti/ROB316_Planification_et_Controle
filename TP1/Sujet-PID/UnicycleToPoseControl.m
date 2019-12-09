function [ u ] = UnicycleToPoseControl( xTrue,xGoal )
%Computes a control to reach a pose for unicycle
%   xTrue is the robot current pose : [ x y theta ]'
%   xGoal is the goal point
%   u is the control : [v omega]'
%   Author : Gabriel H. Riqueti
%   Orientator : David Filliat

% Paramètres du commande
Krho = 9;
Kalpha = 4;
Kbeta = 11;
alpha_max = pi/5;

u = [0;0;0];

rho = sqrt((xGoal(1,1)-xTrue(1,1))^2 + (xGoal(2,1)-xTrue(2,1))^2);

if (rho>0.05)
    alpha = AngleWrap(atan2(xGoal(2,1)-xTrue(2,1), xGoal(1,1)-xTrue(1,1)) - xTrue(3,1));
    u(2,1) = Kalpha*alpha;
    if (abs(alpha)>alpha_max)
        u(1,1) = 0;
    else
        u(1,1) = Krho*rho;
    end
else
    beta = AngleWrap(AngleWrap(xGoal(3,1)) - AngleWrap(xTrue(3,1)));
    u(2,1) = Kbeta*beta;
    u(1,1) = Krho*rho;
end



end
