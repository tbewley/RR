function FSbisection                                 % Numerical Renaissance Codebase 1.0
figure(1); clf; axis([0 1 0 6]); hold on; format compact;
m=0, f3l=0; f3u=1; yl=FSmarch(f3l,0,m); yu=FSmarch(f3u,0,m);
while abs(f3u-f3l)>6e-16   % Refine guess for f''(0) using bisection algorithm
  f3=(f3u+f3l)/2, y=FSmarch(f3,0,m);  if yl*y<0; f3u=f3; yu=y; else; f3l=f3; yl=y; end
end
f3=(f3u+f3l)/2, disp(sprintf('Error in terminal condition = %0.5g',FS_March(f3,1,m)))
end % function FSbisection.m

