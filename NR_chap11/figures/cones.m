% StabStiff.m                                        % Numerical Renaissance Codebase 1.0
clear; Np=501; V=[1 1.0000000001]; figure(1);
name = strvcat('Stiff'); B=[ -1.05; 1.05; -1.05; 1.05];
LR=[B(1):(B(2)-B(1))/(Np-1):B(2)]'; LI=[B(3):(B(4)-B(3))/(Np-1):B(4)]';
for j=1:Np; for i=1:Np;
  if     (LI(i,1)<0 & abs(LR(j,1))<abs(LI(i,1))), sig(i,j)=-1;
  elseif (LI(i,1)>0 & abs(LR(j,1))<abs(LI(i,1))), sig(i,j)=1;
  else   sig(i,j)=0; end
end; end
clf; contourf(LR(:),LI(:),sig(:,:)); 
cm=[1 0.3 0.3; 1 1 1; 0.3 0.3 1];
colormap(cm);
set(gca,'FontSize',15); axis('square'); axis off; hold on; 
%  plot([B(1) B(2)],[0,0],'k-'); plot([0,0],[B(3) B(4)],'k-');
  hold off;  pause(1);  
% eval(['print -depsc ',sprintf('cones')])
% end script StabStiff.m