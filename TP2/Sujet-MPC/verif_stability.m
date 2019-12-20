function ok = verif_stability(x_verif)
##  try
  pkg load control
##  end
  %parametres
  mu = 0.5;
  u0 = 0;
  x10 = 0;
  x20 = 0;
  
  %matrice de poids
  Q = [0.5,0;0,0.5];
  R = [1];
  
  %écrire les matrics A et B de la linéarisation Jacobienne
  %linéarisation jacobienne
  A = [(1-mu)*u0, 1; 1, -4*u0*(1-mu)];
  B = [mu-x10*(1-mu); mu-x20*(1-mu)];

  %avec riccati, trouver une commande stabilisante
  %essai riccati : A'P+PA-PB inv(R) B'P + Q = 0
  [~, l, g] = care(A,B,Q,R);
%   [x, g, l] = icare(A,B,Q,R,[],[],[]); only for MATLAB
%   x = x_verif;
%   l = 0;
%   g = [1, 1];
  K = -g;
  
  %TODO calculer l'équation du système avec rebouclage
  %systeme rebouclage
  Ak = A + B*K;

  %eigs(Ak);
    
  %TODO calculer la borne lambda et la borne alpha à  95 % de lambda
  %calcul de la borne, on retrouve bien celle de l'article
  lambda = l(1,1);
  % borne a 95 % 
  alpha = - 0.95*lambda;
  
  %TODO écrire les matrices de l'équation de Lyapunov et la résoudre pour obtenir la matrice P
  %matrice pour equation lyap
  Al = (Ak + alpha*eye(size(A,2)))';
  Bl = Q + K'*R*K;
  
  P = lyap(Al,Bl);
  
  %verif lyap
  if Al*P + P*Al' + Bl < ones (size(A,1),1)*0.00001
      %ici on calcul la borne du problème quadratique beta
      [x1, obj] = qp([x10;x20],-2*P,[],[],[],[-0.8;-0.8],[0.8;0.8],-2,K,2);
      beta = -obj;
      
      %TODO écrire le test qui valide ou non si le point est dans la zone de stabilition du controleur  
      if x_verif'*P*x_verif <= beta
          % l'entrée de x_verif ne sature pas
          ok = 0;
      else
          ok = -1;
          print ('Error -1: unreachable state')
      end
  else
      ok = -2;
      print ('Error -2: wrong Lyapunov solution')
  end
  
endfunction
