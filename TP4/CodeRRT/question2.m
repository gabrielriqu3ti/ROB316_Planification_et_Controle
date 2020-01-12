% Script pour tester l'algorithme RRT
% Question 2

% Variable contenant le point de départ et le point d’arrivée
carte = struct('name','RSE12.mat','start_point',[-18.5 -5.5],'goal_point',[18 -3.65]);

% Obtenir des Statistiques
benchmark2D('RSE12.mat',[-18.5 -5.5],[18 -3.65],'rrt','FNSimple2D_Obst',5000)