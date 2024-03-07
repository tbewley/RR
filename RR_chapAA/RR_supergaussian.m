function p=RR_supergaussian(mu,P,s,d,x,y,z)
% Computes the d-dimensional supergaussian over a rectangular grid
% INPUTS: mu: mean of distribution (vector of dimension d)
%         P:  covariance of distribution (matrix of dimension d x d)
%         s:  power of supergaussian (s=1 is Gaussian, s>1 is flatter near center)
%         d:  dimension of problem (only d=1, 2, or 3 currently implemented)
%         x:  vector of gridpoints in x direction
%         y:  vector of gridpoints in y direction (for d>1)
%         z:  vector of gridpoints in z direction (for d>2)
% OUTPUT: supergaussian function evaluated on a rectangular d-dimensional grid.
% TEST:   clear; Nx=128, Ny=128, Lx=6, mu=[0;0]; P=[1 0.5;0.5 1];
%         delta=Lx/Nx; Ly=delta*Ny; x=[-Lx/2:delta:Lx/2]; y=[-Ly/2:delta:Ly/2];
%         s=1; for i=1:3,
%            p=RR_supergaussian(mu,P,s,2,x,y);
%            figure(2*i-1); clf, contour(x,y,p',10); axis square, fontsize(gca,16,"pixels")
%            title(sprintf('s=%0.1g, P=[%0.1g %0.1g,%0.1g %0.1g]',s,P)); 
%            figure(2*i); clf, surf(x,y,p'), fontsize(gca,16,"pixels")
%            title(sprintf('s=%0.1g, P=[%0.1g %0.1g,%0.1g %0.1g]',s,P));
%         s=s*2; end
%         mu=[0]; P=[1]; figure(7); clf; s=0.5; fac=sqrt(2);
%         for i=1:7, p=RR_supergaussian(mu,P,s,1,x);
%            if i==3, type='b-'; else, type='k--'; end, plot(x,p, type); s=s*fac; hold on
%         end
%         title('s=\{0.5, 0.707, 1, 1.414, 2, 2.828, 4\}, P=1'); fontsize(gca,16,"pixels")
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/RR_chapAA
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License. 

if d==1,            c=sqrt(2*pi);                     % Calculate c
elseif d==2,        c=2;
elseif mod(d,2)==1, c=RR_Double_Factorial(d-2)*sqrt(2*pi);
else,               c=RR_Double_Factorial(d-2)*2;
end
Pi=inv(P);   b=gamma((d+2)/(2*s))/(d*gamma(d/(2*s))); % Other constants
a=c*s*b^(d/2)/(gamma(d/(2*s))*sqrt((2*pi)^d*det(P)));
switch d
  case 1, Nx=length(x);
    for i=1:Nx
       xs=x(i)-mu(1);
       p(i)=a*exp(-(b*xs*Pi*xs)^s);
    end
  case 2, Nx=length(x); Ny=length(y);
    for i=1:Nx, for j=1:Ny
       xs=[x(i)-mu(1); y(j)-mu(2)];             
       p(i,j)=a*exp(-(b*xs'*Pi*xs)^s);
    end, end
  case 3, Nx=length(x); Ny=length(y); Nz=length(z);
    for i=1:Nx, for j=1:Ny, for k=1:Nz
       xs=[x(i)-mu(1); y(j)-mu(2); z(k)-mu(3)];
       p(i,j,k)=a*exp(-(b*xs'*Pi*xs)^s);
    end, end, end
  otherwise, error('RR_supergaussian implemented for d<=3')
end % switch
end % function RR_supergaussian