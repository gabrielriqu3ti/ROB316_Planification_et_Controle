function ok=verif_stability(x_verif)
  try
    pkg load control
  end
  %parametres
  mu=0.5;
  u0=0;
  x10=0;
  x20=0;
  
  %matrice de poids
  Q=[0.5,0;0,0.5];
  R=[1];
  
  %�crire les matrics A et B de la lin�arisation Jacobienne
  %lin�arisation jacobienne
  A = [(1-mu)*u0,1;1,-4*u0(1-mu)];
  B = [mu-x10*(1-mu);mu-x20*(1-mu)];

  %avec riccati, trouver une commande stabilisante
  %essai riccati : A'P+PA-PB inv(R) B'P + Q =0
  #[x, l, g] =
  x = x_verif;
  l = 0;
  g = [1, 1];
  K=-g;
  
  %TODO calculer l'�quation du syst�me avec rebouclage
  %systeme rebouclage
  Ak = A + B*K;

  %eigs(Ak);
  
  M=[-1,0;0,-1] - (Ak);
  disp(det(M));
  
  disp(eig(Ak));
  
  %TODO calculer la borne lambda et la borne alpha � 95 % de lambda
  %calcul de la borne, on retrouve bien celle de l'article
  %lambda=
  % borne a 95 % 
  %alpha=
  
  %TODO �crire les matrices de l'�quation de Lyapunov et la r�soudre pour obtenir la matrice P
  %matrice pour equation lyap
  %Al=
  %Bl=
  
  P=lyap(Al,Bl);   
  
  %verif lyap
  %Al*P + P*Al' + Bl;
  %eigs(P);
  
  %ici on calcul la borne du probl�me quadratique beta
  [x1,obj]=qp([0;0],-2*P,[],[],[],[-0.8;-0.8],[0.8;0.8],-2,K,2)
  beta=-obj
  
  %TODO �crire le test qui valide ou non si le point est dans la zone de stabilition du controleur  
  %ok = 
  
  
endfunction
