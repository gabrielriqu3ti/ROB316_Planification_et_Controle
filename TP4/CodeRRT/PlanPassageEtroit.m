function PlanPassageEtroit(algorithm, max_iter)
% Fonction Question 1 - Optimalit� du chemin

    if nargin < 1
        algorithm = 'rrt';
        max_iter = 5000;
    end

%     benchmark2D('RSE12.mat',[-18.5 -5.5],[18 -3.65],algorithm,'FNSimple2D',max_iter)
    benchmark2D('RSE12.mat',[-18.5 -5.5],[18 -3.65],algorithm,'FNSimple2D_Obst',max_iter)

end