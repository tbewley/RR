% script StabContoursShort.m                         % Numerical Renaissance Codebase 1.0
Np=101; V=[1 1.0000000001]; figure(1);
name = strvcat('EE','RK4','AB4','AM4','BDF4','ESD4'); B=[ -6.55; 0.55; -3.55; 3.55];
LR=[B(1):(B(2)-B(1))/(Np-1):B(2)]'; LI=[B(3):(B(4)-B(3))/(Np-1):B(4)]';
for j=1:Np; for i=1:Np;  L=LR(j,1)+sqrt(-1)*LI(i,1);                                
  sig(i,j,1)=abs(1+L);                                             % EE
  sig(i,j,2)=abs(1+L+L^2/2+L^3/6);                                 % RK4
  sig(i,j,3)=max(abs(roots([1 -1 0 0 0]-[0 55 -59 37 -9]*L/24)));  % AB4
  sig(i,j,4)=max(abs(roots([1 -1 0 0]-[9 19 -5 1]*L/24)));         % AM4
  sig(i,j,5)=max(abs(roots([1 0 0 0 0]-[12*L 48 -36 16 -3]/25)));  % BDF4
  sig(i,j,6)=max(abs(roots([1 -1 0]-[29-6*L 20 -1]*L/48)));        % ESD4
end; end
for k=1:6;
  clf; contourf(LR(:),LI(:),1./sig(:,:,k),V,'k-'); colormap autumn;
  set(gca,'FontSize',15); axis('square'); title(name(k,:),'FontSize',18); hold on; 
  plot([B(1) B(2)],[0,0],'k-'); plot([0,0],[B(3) B(4)],'k-');
  hold off;  pause(1);  eval(['print -depsc ',sprintf('stab%s',name(k,:))])
end