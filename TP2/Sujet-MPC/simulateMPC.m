function simulateMPC(xinit,K,mu)
  
  dt=.01;
  x=xinit;
  xstore = NaN*zeros(2,10000);
  k=1;
  u=1;
  
  n=4;
  while (norm(x) > 0.001) && (k<2000)
    xstore(:,k) = x;
    
    
    %TODO linearisation en x et t
    Ar = [(1-mu)*u, 1; 1, -4*u*(1-mu)];
    Br = [mu-x(1)*(1-mu); mu-x(2)*(1-mu)];
    A = eye(2,2) + Ar*dt;
    B = Br*dt;
    
    %vecteur d'entrées
    U=[u,u,u,u]';
    H=eye(n,n)*2;
    
    %TODO Écrire les matrices de la commande prédictive linéaire
    Aqp = zeros(size(A,1)*n,size(A,2));
    for i=1:n
        Aqp((i-1)*size(A,1)+1:i*size(A,1),1:size(A,2)) = A^i;
    end

    Bqp = zeros(size(B,1)*n,size(B,2)*n);
    for i=1:n
        Bqp((i-1)*size(B,1)+1:i*size(B,1),(i-1)*size(B,2)+1:i*size(B,2)) = B;
        for j=i+1:n
            Bqp((i-1)*size(B,1)+1:i*size(B,1),(j-1)*size(B,2)+1:j*size(B,2)) = A^(j-i)*B;
        end
    end
      
    %TODO avec une pseudo inverse, calculer le vecteur d'entrées
    U = -pinv(Bqp)*Aqp*x;
    
    
    if size(K)==0
      u=U(1);
    else
      u=K*x;
    end
    
    if (u > 2)
      u=2;
    elseif (u<-2)
      u=-2;
    end
    
    %simu avec euler
    x1=x(1);
    x2=x(2);
    x(1) = x1 + dt*(x2 + u*(mu + (1-mu)*x1));
    x(2) = x2 + dt*(x1+u*(mu-4*(1-mu)*x2));
    
    k = k+1;
  end
  
  if norm(x) < 0.01
    plot(xstore(1,:),xstore(2,:),'+');
  else
    disp("fail!")
  end
endfunction
