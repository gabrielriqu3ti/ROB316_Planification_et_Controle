% Script pour tester l'algorithme RRT
% Question 1

% Variable contenant le point de départ et le point d’arrivée
carte = struct('name','bench_june1.mat','start_point',[-15.5 -5.5],'goal_point',[7 -3.65]);

% Exemple d'utilisation 
%res = rrt_star(carte, 8000,0,cputime*1000,'FNSimple2D');

% Obtenir des Statistiques
benchmark2D('bench_june1.mat',[-15.5 -5.5],[7 -3.65],'rrt','FNSimple2D',15000)

