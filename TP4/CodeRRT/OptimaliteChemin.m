function OptimaliteChemin(algorithm, max_iter)
% Fonction Question 1 - Optimalité du chemin

    if nargin < 1
        algorithm = 'rrt';
        max_iter = 5000;
    end

    benchmark2D('bench_june1.mat',[-15.5 -5.5],[7 -3.65],algorithm,'FNSimple2D',max_iter)

end