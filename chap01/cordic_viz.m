% script cordic_illustration

R=1.05; width=[2 1 1 1 1 2];

figure(1), clf, th=[-pi/2:pi/100:pi/2]
plot(cos(th),sin(th),'k-','LineWidth',2), axis equal, axis off, hold on
plot([0 1.2],[0 0],'k--'); plot([0 0],[-1.1 1.1],'k--');
angles=[0.78540, 0.46365, 0.24498, 0.12435, 0.06242, 0.03124, 0.01562];
v=[1; 0]; z=1.05;
for i=1:6
    quiver(0,0,v(1),v(2),0,'r-','LineWidth',width(i))
    text(R*v(1),R*v(2),int2str(i))
    sigma=sign(z); 
    v=[cos(sigma*angles(i)), -sin(sigma*angles(i)); ...
       sin(sigma*angles(i)),  cos(sigma*angles(i))]*v;
    z=z-sigma*angles(i)
end
print -depsc CORDIC1.eps

figure(2), clf, th=[-pi/2:pi/100:pi/2]
plot(cos(th),sin(th),'k-','LineWidth',2), axis equal, axis off, hold on
plot([0 1.2],[0 0],'k--'); plot([0 0],[-1.1 1.1],'k--');
v=[cos(1.08); sin(1.08)];
for i=1:6
    quiver(0,0,v(1),v(2),0,'b-','LineWidth',width(i))
    text(R*v(1),R*v(2),int2str(i))
    sigma=-sign(v(2)); 
    v=[cos(sigma*angles(i)), -sin(sigma*angles(i)); ...
       sin(sigma*angles(i)),  cos(sigma*angles(i))]*v;
end
print -depsc CORDIC2.eps

figure(3), clf, c=1.118173; th=[-c:c/30:c];
x=cosh(th); y=sinh(th); plot(x,y,'k-','LineWidth',2), axis equal, axis off, hold on
plot([0 cosh(c)],[0 0],'k--')
plot([cosh(c) 0 cosh(c)],[-sinh(c) 0 sinh(c)],'k--')
angles=[0.54931, 0.25541, 0.12566, 0.06258, 0.06258, 0.03126, 0.01563];
v=[1; 0]; z=1.05;
for i=1:6
    quiver(0,0,v(1),v(2),0,'r-','LineWidth',width(i))
    text(R*v(1),R*v(2),int2str(i))
    sigma=sign(z); 
    v=[cosh(sigma*angles(i)), sinh(sigma*angles(i)); ...
       sinh(sigma*angles(i)), cosh(sigma*angles(i))]*v;
    z=z-sigma*angles(i)
end
print -depsc CORDIC3.eps

figure(4), clf, c=1.118173; th=[-c:c/30:c];
x=cosh(th); y=sinh(th); plot(x,y,'k-','LineWidth',2), axis equal, axis off, hold on
plot([0 cosh(c)],[0 0],'k--')
plot([cosh(c) 0 cosh(c)],[-sinh(c) 0 sinh(c)],'k--')
v=[cosh(1.08); sinh(1.08)];
for i=1:6
    quiver(0,0,v(1),v(2),0,'b-','LineWidth',width(i))
    text(R*v(1),R*v(2),int2str(i))
    sigma=-sign(v(2)); 
    v=[cosh(sigma*angles(i)), sinh(sigma*angles(i)); ...
       sinh(sigma*angles(i)), cosh(sigma*angles(i))]*v;
end
print -depsc CORDIC4.eps

figure(5), clf,
plot([1 1],[-2 2],'k-','LineWidth',2), axis equal, axis off, hold on
plot([0 1.3],[0 0],'k--')
plot([1 0 1],[-2 0 2],'k--')
f=[1 0.5, 0.25, 0.125, 0.0625, 0.03125, 0.015625];
v=[1; 0]; z=1.95;
for i=1:6
    quiver(0,0,v(1),v(2),0,'r-','LineWidth',width(i))
    text(R*v(1),R*v(2),int2str(i))
    sigma=sign(z); 
    v=[1,                0; ...
       sigma*f(i), 1]*v;
    z=z-sigma*f(i);
end
print -depsc CORDIC5.eps

figure(6), clf, 
plot([1 1],[-2 2],'k-','LineWidth',2), axis equal, axis off, hold on
plot([0 1.3],[0 0],'k--')
v=[1; 1.8];
for i=1:6
    quiver(0,0,v(1),v(2),0,'b-','LineWidth',width(i))
    text(R*v(1),R*v(2),int2str(i))
    sigma=-sign(v(2)); 
    v=[1,                0; ...
       sigma*f(i), 1]*v;
end
print -depsc CORDIC6.eps

