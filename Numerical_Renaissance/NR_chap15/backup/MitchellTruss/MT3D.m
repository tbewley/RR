function [nodes]=MT3D(N,refinements,iterations,forceprofile,variablewidth,movewallpoints) % Numerical Renaissance Codebase 1.0
% This function creates and optimizes a 3D Mitchell truss.
if nargin<1 | N<2 | N>6, N=5;  end, Np=N+1; params.N=N;
if nargin<2, refinements=0;    end
if nargin<3, iterations=60;    end, x=Init_MT3D(N); 
if nargin<4, forceprofile=3;   end, params.forceprofile=forceprofile;
if nargin<5, variablewidth=1;  end, params.variablewidth=variablewidth;
if nargin<6, movewallpoints=0; end
for refinement=0:refinements
  params.regularization=0;  [J,lengths,forces]=ComputeJ_MT3D(x,params); nodes=reshape(x,Np,Np,Np,3);
  Draw_MT3D(nodes,N,lengths,forces,params)
  for fig=1:3; figure(fig); title(sprintf('q=%d  Initial Configuration. Total Mass=%5.4f',N,J)), end, pause(1)
  X=ones(Np,Np,Np,3); X(Np,Np,Np,:)=0;
  if movewallpoints==0,
    X(:,:,1,:)=0; X(:,1,:,:)=0; X(1,:,:,:)=0;
  else
    X(:,:,1,1)=0; X(:,1,:,1)=0; X(1,:,:,1)=0;
  end
  mask=reshape(X,Np*Np*Np*3,1);  params.regularization=0.01;    
  for iter=1:iterations
    if iter==iterations/2, params.regularization=0; end
    r=-mask.*ComputeGradCSD(@ComputeJ_MT3D,x,params);
    if movewallpoints==1,
      r=reshape(r,Np,Np,Np,3);
      t=sum(sum(r(2:Np,2:Np,1,2))); r(2:Np,2:Np,1,2)=t/N^2;
      t=sum(sum(r(2:Np,2:Np,1,3))); r(2:Np,2:Np,1,3)=t/N^2;
      t=sum(sum(r(2:Np,1,2:Np,2))); r(2:Np,1,2:Np,2)=t/N^2;
      t=sum(sum(r(2:Np,1,2:Np,3))); r(2:Np,1,2:Np,3)=t/N^2;
      t=sum(sum(r(1,2:Np,2:Np,2))); r(1,2:Np,2:Np,2)=t/N^2;
      t=sum(sum(r(1,2:Np,2:Np,3))); r(1,2:Np,2:Np,3)=t/N^2;
      r=reshape(r,Np*Np*Np*3,1);
    end
    res=r'*r; 
    if iter<2, alpha=.00001; p=r; else    % Gives nodes a finite "kick" at first iteration.
      if (mod(iter,5)==1 | iter<5), p=r; else, p=r+ ((r-rold)'*r/resold) *p; end
      ab=min(lengths)/max(abs(p))/30;
      [aa,ab,ac,Ja,Jb,Jc]=Bracket(@ComputeJ_MT3D,0,ab,J,x,p,params);
      [alpha,J]=Brent(@ComputeJ_MT3D,aa,ab,ac,Ja,Jb,Jc,.01,x,p,params);
    end
    x=x+alpha*p;
    x_ijk=reshape(x,Np,Np,Np,3); for i=1:Np, x_ijk(i,i,:,2)=0; for j=i+1:Np,  % symmetrize the structure...
       t=(x_ijk(i,j,:,1)+x_ijk(j,i,:,1))/2; x_ijk(i,j,:,1)=t; x_ijk(j,i,:,1)= t;
       t=(x_ijk(i,j,:,2)-x_ijk(j,i,:,2))/2; x_ijk(i,j,:,2)=t; x_ijk(j,i,:,2)=-t;
       t=(x_ijk(i,j,:,3)+x_ijk(j,i,:,3))/2; x_ijk(i,j,:,3)=t; x_ijk(j,i,:,3)= t;
    end, end, x=reshape(x_ijk,Np*Np*Np*3,1);
    [J,lengths,forces]=ComputeJ_MT3D(x,params); nodes=reshape(x,Np,Np,Np,3);
    Draw_MT3D(nodes,N,lengths,forces,params)
%    for fig=1:3; figure(fig); title(sprintf('q=%d, iter=%d, Total Mass=%5.4f',N,iter,J)); end
    disp(sprintf('q=%d, iter=%d, Total Mass=%5.4f',N,iter,J));
    resold=res; rold=r;
  end
  if refinement<refinements, NN=2*N;
    nodesN(2:2:NN,  2:2:NN,  2:2:NN,  :)= nodes(2:Np,2:Np,2:Np,:);
    nodesN(3:2:NN-1,2:2:NN,  2:2:NN,  :)=(nodes(2:N, 2:Np,2:Np,:)+nodes(3:Np,2:Np,2:Np,:))/2;
    nodesN(2:2:NN,  3:2:NN-1,2:2:NN,  :)=(nodes(2:Np,2:N, 2:Np,:)+nodes(2:Np,3:Np,2:Np,:))/2;
    nodesN(2:2:NN,  2:2:NN,  3:2:NN-1,:)=(nodes(2:Np,2:Np,2:N, :)+nodes(2:Np,2:Np,3:Np,:))/2;
    nodesN(3:2:NN-1,3:2:NN-1,2:2:NN,  :)=(nodes(2:N, 2:N, 2:Np,:)+nodes(2:N, 3:Np,2:Np,:) + ...
                                          nodes(3:Np,2:N, 2:Np,:)+nodes(3:Np,3:Np,2:Np,:))/4;
    nodesN(3:2:NN-1,2:2:NN,  3:2:NN-1,:)=(nodes(2:N, 2:Np,2:N, :)+nodes(2:N, 2:Np,3:Np,:) + ...
                                          nodes(3:Np,2:Np,2:N, :)+nodes(3:Np,2:Np,3:Np,:))/4;
    nodesN(2:2:NN,  3:2:NN-1,3:2:NN-1,:)=(nodes(2:Np,2:N, 2:N, :)+nodes(2:Np,2:N, 3:Np,:) + ...
                                          nodes(2:Np,3:Np,2:N, :)+nodes(2:Np,3:Np,3:Np,:))/4;
    nodesN(3:2:NN-1,3:2:NN-1,3:2:NN-1,:)=(nodes(2:N, 2:N, 2:N, :)+nodes(2:N, 2:N, 3:Np,:) + ...
                                          nodes(2:N, 3:Np,2:N, :)+nodes(2:N, 3:Np,3:Np,:) + ...
                                          nodes(3:Np,2:N, 2:N, :)+nodes(3:Np,2:N, 3:Np,:) + ...
                                          nodes(3:Np,3:Np,2:N, :)+nodes(3:Np,3:Np,3:Np,:))/8;
    nodesN(1,:,:,1)=nodes(1,Np,Np,1); nodesN(1,:,:,2)=nodes(1,Np,Np,2); nodesN(1,:,:,3)=nodes(1,Np,Np,3);
    nodesN(:,1,:,1)=nodes(Np,1,Np,1); nodesN(:,1,:,2)=nodes(Np,1,Np,2); nodesN(:,1,:,3)=nodes(Np,1,Np,3);
    nodesN(:,:,1,1)=nodes(Np,Np,1,1); nodesN(:,:,1,2)=nodes(Np,Np,1,2); nodesN(:,:,1,3)=nodes(Np,Np,1,3);
    N=NN-1; Np=N+1; params.N=N; nodes=nodesN; x=reshape(nodes,Np*Np*Np*3,1); pause(1);
  end
end
end % function MT3D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x=Init_MT3D(N)
Nm=N-1; Np=N+1; f=0.5; R=0.22; theta2=atan(1/sqrt(2)); off=pi/6;
for i=1:Np, for j=1:Np, for k=1:Np
  nodes(i,j,k,1)=f*(i-2)/Nm-.5; nodes(i,j,k,2)=f*(j-2)/Nm-.5; nodes(i,j,k,3)=f*(k-2)/Nm-.5;
end, end, end; X=reshape(nodes,Np*Np*Np,3)';
X=Rotate2(X,cos(-pi/4),sin(-pi/4),1,2,'pre ',1,Np*Np*Np);     % Rotate by 45 deg in x-y plane
X=Rotate2(X,cos(-theta2),sin(-theta2),1,3,'pre ',1,Np*Np*Np); % Rotate by theta2 deg in new x-z plane
nodes=reshape(X',Np,Np,Np,3);
nodes(:,:,:,1)=nodes(:,:,:,1)+0.5-nodes(Np,Np,Np,1); % Scoot tip to x=.5, attach to wall
nodes(:,:,1,1)=-0.5; nodes(:,:,1,2)=R*cos(4*pi/3+off); nodes(:,:,1,3)=R*sin(4*pi/3+off);
nodes(:,1,:,1)=-0.5; nodes(:,1,:,2)=R*cos(2*pi/3+off); nodes(:,1,:,3)=R*sin(2*pi/3+off);
nodes(1,:,:,1)=-0.5; nodes(1,:,:,2)=R*cos(0+off);      nodes(1,:,:,3)=R*sin(0+off);
x=reshape(nodes,Np*Np*Np*3,1); 
end % function Init_MT3D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Draw_MT3D(nodes,N,lengths,forces,params)
for fig=1:3
  figure(fig), clf, hold on, axis equal, for i=1:N, for j=1:N, for k=1:N, I=i+(j-1)*N+(k-1)*N^2; II=I+N^3; III=I+2*N^3;
    if params.variablewidth==1
      wp=2/max(abs(forces(:,fig)));
      if forces(I,fig)>0.0
        plot3([nodes(i,j+1,k+1,1) nodes(i+1,j+1,k+1,1)],[nodes(i,j+1,k+1,2) nodes(i+1,j+1,k+1,2)],[nodes(i,j+1,k+1,3) nodes(i+1,j+1,k+1,3)],'k-','LineWidth',wp*abs(forces(I,fig))+.1)
      else  
        plot3([nodes(i,j+1,k+1,1) nodes(i+1,j+1,k+1,1)],[nodes(i,j+1,k+1,2) nodes(i+1,j+1,k+1,2)],[nodes(i,j+1,k+1,3) nodes(i+1,j+1,k+1,3)],'k--','LineWidth',wp*abs(forces(I,fig))+.1)
      end
      if forces(II,fig)>0.0
        plot3([nodes(i+1,j,k+1,1) nodes(i+1,j+1,k+1,1)],[nodes(i+1,j,k+1,2) nodes(i+1,j+1,k+1,2)],[nodes(i+1,j,k+1,3) nodes(i+1,j+1,k+1,3)],'k-','LineWidth',wp*abs(forces(II,fig))+.1)
      else
        plot3([nodes(i+1,j,k+1,1) nodes(i+1,j+1,k+1,1)],[nodes(i+1,j,k+1,2) nodes(i+1,j+1,k+1,2)],[nodes(i+1,j,k+1,3) nodes(i+1,j+1,k+1,3)],'k--','LineWidth',wp*abs(forces(II,fig))+.1)
      end
      if forces(III,fig)>0.0
        plot3([nodes(i+1,j+1,k,1) nodes(i+1,j+1,k+1,1)],[nodes(i+1,j+1,k,2) nodes(i+1,j+1,k+1,2)],[nodes(i+1,j+1,k,3) nodes(i+1,j+1,k+1,3)],'k-','LineWidth',wp*abs(forces(III,fig))+.1)
      else
        plot3([nodes(i+1,j+1,k,1) nodes(i+1,j+1,k+1,1)],[nodes(i+1,j+1,k,2) nodes(i+1,j+1,k+1,2)],[nodes(i+1,j+1,k,3) nodes(i+1,j+1,k+1,3)],'k--','LineWidth',wp*abs(forces(III,fig))+.1)
      end
    elseif params.variablewidth==2
      wp=2/max(abs(forces(:,fig).*lengths(:)));
      if forces(I,fig)>0.0
        plot3([nodes(i,j+1,k+1,1) nodes(i+1,j+1,k+1,1)],[nodes(i,j+1,k+1,2) nodes(i+1,j+1,k+1,2)],[nodes(i,j+1,k+1,3) nodes(i+1,j+1,k+1,3)],'k-', 'LineWidth',wp*abs(forces(I,fig).*lengths(I))+.1)
      else  
        plot3([nodes(i,j+1,k+1,1) nodes(i+1,j+1,k+1,1)],[nodes(i,j+1,k+1,2) nodes(i+1,j+1,k+1,2)],[nodes(i,j+1,k+1,3) nodes(i+1,j+1,k+1,3)],'k--','LineWidth',wp*abs(forces(I,fig).*lengths(I))+.1)
      end
      if forces(II,fig)>0.0
        plot3([nodes(i+1,j,k+1,1) nodes(i+1,j+1,k+1,1)],[nodes(i+1,j,k+1,2) nodes(i+1,j+1,k+1,2)],[nodes(i+1,j,k+1,3) nodes(i+1,j+1,k+1,3)],'k-', 'LineWidth',wp*abs(forces(II,fig).*lengths(II))+.1)
      else
        plot3([nodes(i+1,j,k+1,1) nodes(i+1,j+1,k+1,1)],[nodes(i+1,j,k+1,2) nodes(i+1,j+1,k+1,2)],[nodes(i+1,j,k+1,3) nodes(i+1,j+1,k+1,3)],'k--','LineWidth',wp*abs(forces(II,fig).*lengths(II))+.1)
      end
      if forces(III,fig)>0.0
        plot3([nodes(i+1,j+1,k,1) nodes(i+1,j+1,k+1,1)],[nodes(i+1,j+1,k,2) nodes(i+1,j+1,k+1,2)],[nodes(i+1,j+1,k,3) nodes(i+1,j+1,k+1,3)],'k-', 'LineWidth',wp*abs(forces(III,fig).*lengths(III))+.1)
      else
        plot3([nodes(i+1,j+1,k,1) nodes(i+1,j+1,k+1,1)],[nodes(i+1,j+1,k,2) nodes(i+1,j+1,k+1,2)],[nodes(i+1,j+1,k,3) nodes(i+1,j+1,k+1,3)],'k--','LineWidth',wp*abs(forces(III,fig).*lengths(III))+.1)
      end
    else
      plot3([nodes(i,j+1,k+1,1) nodes(i+1,j+1,k+1,1)],[nodes(i,j+1,k+1,2) nodes(i+1,j+1,k+1,2)],[nodes(i,j+1,k+1,3) nodes(i+1,j+1,k+1,3)],'k--')
      plot3([nodes(i+1,j,k+1,1) nodes(i+1,j+1,k+1,1)],[nodes(i+1,j,k+1,2) nodes(i+1,j+1,k+1,2)],[nodes(i+1,j,k+1,3) nodes(i+1,j+1,k+1,3)],'k-.')
      plot3([nodes(i+1,j+1,k,1) nodes(i+1,j+1,k+1,1)],[nodes(i+1,j+1,k,2) nodes(i+1,j+1,k+1,2)],[nodes(i+1,j+1,k,3) nodes(i+1,j+1,k+1,3)],'k-')
    end
  end, end, end, patch([-.5 -.5 -.5 -.5],[-.300001 .300001 .300001 -.300001],[-.300001 -.300001 .300001 .300001],[.7 .7 .7]), hold off %  xlabel('x'), ylabel('y'), zlabel('z')
  axis tight, view(9,10) %, view(90,54)
end
end % function Draw_MT3D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [J,lengths,forces] = ComputeJ_MT3D(x,params)
N=params.N; Np=N+1; nodes=reshape(x,Np,Np,Np,3); A=zeros(3*N^3,3*N^3);
for k=2:Np, for j=2:Np, for i=1:N, I=i+(j-2)*N+(k-2)*N^2;         J=I;        % Forces applied by i-members 
  lengths(I,1)=sqrt((nodes(i+1,j,k,1)-nodes(i,j,k,1))^2+(nodes(i+1,j,k,2)-nodes(i,j,k,2))^2+(nodes(i+1,j,k,3)-nodes(i,j,k,3))^2);
  A(J,      I)=(nodes(i+1,j,k,1)-nodes(i,j,k,1))/lengths(I,1);                % components of force in x/y/z directions
  A(J+N^3,  I)=(nodes(i+1,j,k,2)-nodes(i,j,k,2))/lengths(I,1);
  A(J+2*N^3,I)=(nodes(i+1,j,k,3)-nodes(i,j,k,3))/lengths(I,1);
  if i>1, A(J-1,I)=-A(J,I); A(J-1+N^3,I)=-A(J+N^3,I); A(J-1+2*N^3,I)=-A(J+2*N^3,I); end
end, end, end
for k=2:Np, for j=1:N, for i=2:Np, I=i-1+(j-1)*N+(k-2)*N^2+N^3;   J=I-N^3;    % Forces applied by j-members
  lengths(I,1)=sqrt((nodes(i,j+1,k,1)-nodes(i,j,k,1))^2+(nodes(i,j+1,k,2)-nodes(i,j,k,2))^2+(nodes(i,j+1,k,3)-nodes(i,j,k,3))^2);
  A(J,    I)  =(nodes(i,j+1,k,1)-nodes(i,j,k,1))/lengths(I,1);                % components of force in x/y/z directions
  A(J+N^3,I)  =(nodes(i,j+1,k,2)-nodes(i,j,k,2))/lengths(I,1);
  A(J+2*N^3,I)=(nodes(i,j+1,k,3)-nodes(i,j,k,3))/lengths(I,1);
  if j>1, A(J-N,I)=-A(J,I); A(J-N+N^3,I)=-A(J+N^3,I); A(J-N+2*N^3,I)=-A(J+2*N^3,I); end
end, end, end
for k=1:N, for j=2:Np, for i=2:Np, I=i-1+(j-2)*N+(k-1)*N^2+2*N^3; J=I-2*N^3;  % Forces applied by k-members
  lengths(I,1)=sqrt((nodes(i,j,k+1,1)-nodes(i,j,k,1))^2+(nodes(i,j,k+1,2)-nodes(i,j,k,2))^2+(nodes(i,j,k+1,3)-nodes(i,j,k,3))^2);
  A(J,      I)=(nodes(i,j,k+1,1)-nodes(i,j,k,1))/lengths(I,1);                % components of force in x/y/z directions
  A(J+N^3,  I)=(nodes(i,j,k+1,2)-nodes(i,j,k,2))/lengths(I,1);
  A(J+2*N^3,I)=(nodes(i,j,k+1,3)-nodes(i,j,k,3))/lengths(I,1);
  if k>1, A(J-N^2,I)=-A(J,I); A(J-N^2+N^3,I)=-A(J+N^3,I); A(J-N^2+2*N^3,I)=-A(J+2*N^3,I); end
end, end, end
applied_forces=zeros(3*N^3,3);
switch params.forceprofile
  case 1, applied_forces(N^3,1)=20;  applied_forces(2*N^3,2)=1;   applied_forces(3*N^3,3)=1;
  case 2, applied_forces(N^3,1)=1;   applied_forces(2*N^3,2)=20;  applied_forces(3*N^3,3)=20;
  case 3, applied_forces(N^3,1)=1;   applied_forces(2*N^3,2)=1;   applied_forces(3*N^3,3)=20;
end
forces=A\applied_forces;  % A is sparse!  There is a more efficient way to do this...
for I=1:3*N^3; maxforces=max(abs(forces(I,:))); end
J=sum((lengths.^2 .* sqrt(maxforces.^2+params.regularization)));
end % function ComputeJ_MT3D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

