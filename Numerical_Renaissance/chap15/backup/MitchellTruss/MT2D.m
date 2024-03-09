function [nodes]=MT2D(N,refinements)                 % Numerical Renaissance Codebase 1.0
% This function creates and optimizes a 2D Mitchell truss.
if nargin<1 | N<2 | N>9, N=5; end, Np=N+1; if nargin<2, refinements=0; end
x=Init_MT2D(N); params.N=N;
for refinement=0:refinements
  params.regularization=0;
  [J,lengths,forces]=ComputeJ_MT2D(x,params); nodes=reshape(x,Np,Np,2);
  Draw_MT2D(nodes,N,lengths,forces);
  title(sprintf('q=%d  Initial Configuration. Total Mass=%5.4f',N,J)), pause
  X=ones(Np,Np,2); X(Np,Np,:)=0; X(:,1,:)=0; X(1,:,:)=0; mask=reshape(X,Np*Np*2,1);
  params.regularization=0.0001;    % Helps to get out of local minima in early iterations.
  for iter=1:100
    if iter==30, params.regularization=0; end
    r=-mask.*ComputeGradCSD(@ComputeJ_MT2D,x,params); res=r'*r; 
    if iter<2, alpha=.0001; p=r; else    % Gives nodes a finite "kick" at first iteration.
      if mod(iter,5)==1, p=r; else, p=r+ ((r-rold)'*r/resold) *p; end
      ab=min(lengths)/max(abs(p))/30;
      [aa,ab,ac,Ja,Jb,Jc]=Bracket(@ComputeJ_MT2D,0,ab,J,x,p,params);
      [alpha,J]=Brent(@ComputeJ_MT2D,aa,ab,ac,Ja,Jb,Jc,.01,x,p,params);
    end
    x=x+alpha*p;
    x_ij=reshape(x,Np,Np,2); for i=1:Np, x_ijk(i,i,2)=0; for j=i+1:Np,  % symmetrize the structure...
       t=(x_ij(i,j,1)+x_ij(j,i,1))/2; x_ijk(i,j,1)=t; x_ij(j,i,1)= t;
       t=(x_ij(i,j,2)-x_ij(j,i,2))/2; x_ijk(i,j,2)=t; x_ij(j,i,2)=-t;
    end, end, x=reshape(x_ij,Np*Np*2,1);    
    [J,lengths,forces]=ComputeJ_MT2D(x,params); nodes=reshape(x,Np,Np,2);
    Draw_MT2D(nodes,N,lengths,forces), title(sprintf('q=%d, iter=%d, Total Mass=%5.4f',N,iter,J))
    resold=res; rold=r;
  end
  if refinement<refinements, NN=2*N;
    nodesN(2:2:NN,  2:2:NN,  :)= nodes(2:Np,2:Np,:);
    nodesN(3:2:NN-1,2:2:NN,  :)=(nodes(2:N, 2:Np,:)+nodes(3:Np,2:Np,:))/2;
    nodesN(2:2:NN,  3:2:NN-1,:)=(nodes(2:Np,2:N, :)+nodes(2:Np,3:Np,:))/2;
    nodesN(3:2:NN-1,3:2:NN-1,:)=(nodes(2:N, 2:N, :)+nodes(2:N, 3:Np,:) + ...
							     nodes(3:Np,2:N, :)+nodes(3:Np,3:Np,:))/4;
    nodesN(1,:,1)=nodes(1,Np,1); nodesN(1,:,2)=nodes(1,Np,2);
    nodesN(:,1,1)=nodes(Np,1,1); nodesN(:,1,2)=nodes(Np,1,2);
    N=NN-1; Np=N+1; nodes=nodesN; x=reshape(nodes,Np*Np*2,1); pause(1);
    params.N=N;
  end
end
end % function MT2D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x=Init_MT2D(N)
Nm=N-1; Np=N+1; f=0.4;
for i=1:Np, for j=1:Np, nodes(i,j,1)=f*(i-2)/Nm-.5; nodes(i,j,2)=f*(j-2)/Nm-.5; end, end
X=reshape(nodes,Np*Np,2)';
X=Rotate2(X,cos(-pi/4),sin(-pi/4),1,2,'pre ',1,Np*Np); % Rotate by 45 deg in x-y plane
nodes=reshape(X',Np,Np,2);
nodes(:,:,1)=nodes(:,:,1)+0.5-nodes(Np,Np,1);                   % Scoot right tip to x=.5
nodes(:,1,1)=-0.5; nodes(1,:,1)=-0.5; nodes(:,1,2)=-.08; nodes(1,:,2)=.08; % attach to wall
x=reshape(nodes,Np*Np*2,1); 
end % function Init_MT2D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Draw_MT2D(nodes,N,lengths,forces)
figure(1), clf, hold on, axis equal, for i=1:N, for j=1:N, I=i+(j-1)*N; II=I+N^2; widthparam=10;
  if forces(I)>0.0
    plot([nodes(i,j+1,1) nodes(i+1,j+1,1)],[nodes(i,j+1,2) nodes(i+1,j+1,2)],'k-','LineWidth',widthparam*abs(forces(I))*lengths(I)+.1);
  else
    plot([nodes(i,j+1,1) nodes(i+1,j+1,1)],[nodes(i,j+1,2) nodes(i+1,j+1,2)],'k--','LineWidth',widthparam*abs(forces(I))*lengths(I)+.1);
  end
  if forces(II)>0.0
    plot([nodes(i+1,j,1) nodes(i+1,j+1,1)],[nodes(i+1,j,2) nodes(i+1,j+1,2)],'k-','LineWidth',widthparam*abs(forces(II))*lengths(II)+.1);
  else
    plot([nodes(i+1,j,1) nodes(i+1,j+1,1)],[nodes(i+1,j,2) nodes(i+1,j+1,2)],'k--','LineWidth',widthparam*abs(forces(II))*lengths(II)+.1);
  end
  % plot([nodes(i,j+1,1) nodes(i+1,j+1,1)],[nodes(i,j+1,2) nodes(i+1,j+1,2)],'k--','LineWidth',1);
  % plot([nodes(i+1,j,1) nodes(i+1,j+1,1)],[nodes(i+1,j,2) nodes(i+1,j+1,2)],'k-','LineWidth',1);
end, end, axis tight, hold off
end % function Draw_MT2D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [J,lengths,forces] = ComputeJ_MT2D(x,params)
N=params.N; Np=N+1; nodes=reshape(x,Np,Np,2); A=zeros(2*N^2,2*N^2); forces=zeros(2*N^2,1);
applied_forces=zeros(2*N^2,1); applied_forces(N^2,1)=1;
for j=2:Np, for i=1:N, I=i+(j-2)*N;                  % Forces applied by i-members
  lengths(I,1)=sqrt((nodes(i+1,j,1)-nodes(i,j,1))^2+(nodes(i+1,j,2)-nodes(i,j,2))^2);
  p=ATAN2(nodes(i+1,j,1)-nodes(i,j,1),nodes(i+1,j,2)-nodes(i,j,2));
  A(I,I)=cos(p); A(I+N^2,I)=sin(p); if i>1, A(I-1,I)=-cos(p); A(I-1+N^2,I)=-sin(p); end
end, end
for j=1:N, for i=2:Np, I=i-1+(j-1)*N+N^2;            % Forces applied by j-members
  lengths(I,1)=sqrt((nodes(i,j+1,1)-nodes(i,j,1))^2+(nodes(i,j+1,2)-nodes(i,j,2))^2);
  p=ATAN2(nodes(i,j+1,1)-nodes(i,j,1),nodes(i,j+1,2)-nodes(i,j,2));
  A(I-N^2,I)=cos(p); A(I,I)=sin(p); if j>1, A(I-N-N^2,I)=-cos(p); A(I-N,I)=-sin(p); end
end, end
forces=A\applied_forces;  J=sum((lengths.^2 .* sqrt(forces.^2+params.regularization)));
end % function ComputeJ_MT2D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

