clear; cm=colormap;                                  % Numerical Renaissance Codebase 1.0
[x,y,z] = SPHERE(20);  figure(1), surf(x,y,z),  axis equal, view(-18.5,12); colormap(cm);
 
Nth=20; Nr=20; theta=[0:2*pi/Nth:2*pi]; r=[0:1.4143/Nr:1.4143]; x=r'*sin(theta); y=r'*cos(theta);
z=x.^2+y.^2-0.5; figure(2), surf(x,y,z), axis equal, view(-18.5,12); colormap(cm);

Nz=20; z=[-0.5:1/Nz:0.5]; r=(z.*z+.02).^0.5; x=r'*sin(theta); y=r'*cos(theta); za=ones(Nth+1,1)*z;
figure(3), surf(x,y,za'), axis equal, view(-18.5,12); colormap(cm);

figure(1); print -depsc pde_ellipse.eps
figure(2); print -depsc pde_parabola.eps
figure(3); print -depsc pde_hyperbola.eps
