function SimPlot_ShallowWater(f,fnew,t,tnew,h,hnew,v,p,TimeStep)
% Numerical Renaissance Codebase 1.0
figure(1); clf; surf([0 p.Ly],p.x,[-p.b(:),-p.b(:)]); hold on;
surf(p.y,p.x,f(:,:)-p.bb);
axis equal; axis([0 5 0 15 -2 1]); pause(0.01);
if v==2, fn=['waves/f' num2str(1000000+TimeStep) '.tiff']; print('-dtiff','-r100',fn);
end % function SimPlot_ShallowWater.m
