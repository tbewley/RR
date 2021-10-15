M=1; nframes=4
for body=1:3;
  switch body
    case {1}, I1=4; I2=3; I3=2;           type='Asymmetric Top', eps=.01, ax =[-2 2 -1.5 1.5 -1 1];
    case {2}, m=13.37; h=2.05; r=0.165/2; type='Explorer 1',     eps=.56
              I1=m*(3*r^2+h^2)/12, I2=I1, I3=m*r^2/2;            ax =[-50 50 -50 50 -1 1];
    case {3}, I1=4; I2=2; I3=2;           type='Frisbee',        eps=.01
  end
  T_initial=(1-eps)*M^2/(2*I3), T_final=(1+eps)*M^2/(2*I1)
  T=logspace(log10(T_initial),log10(T_final),nframes)
  for k=1:nframes
  clf; T1=2*I1*T(k); T2=2*I2*T(k); T3=2*I3*T(k);
  [x,y,z]=ellipsoid(0,0,0,T1,T2,T3,300); surf(x,y,z,0*x+1); hold on;
  [x,y,z]=sphere(300); surf(x,y,z,0*x+3); alpha(1); shading FLAT; axis equal;
  if body==1, axis(ax), end
  % title(sprintf('%s,  T=%5.3f',type,T(k)));
  print('-depsc',sprintf('Conservation%d%d.eps',body,k))
  pause(1)
  end
  pause
end
