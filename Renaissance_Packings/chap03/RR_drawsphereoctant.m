function RR_drawsphereoctant(radius,center,quadrant)
figure(1); clf;
R=5; N=52; [X,Y,Z]=sphere(N);
sec1 = ceil((N+1)/2);
sec2 = ceil(3*size(X,1)/4)
X_oct = R*X(sec1:end, sec1:sec2);
Y_oct = R*Y(sec1:end, sec1:sec2);
Z_oct = R*Z(sec1:end, sec1:sec2);
surf(X_oct, Y_oct, Z_oct, 'FaceColor', 'interp', ...
     'EdgeColor', 'none', 'FaceAlpha', 0.8);

xlabel('X'); ylabel('Y'); zlabel('Z'); axis equal; view(45,45); 

x = [0 0 0];
y = [0 1 0];
z = [0 0 1];
% fill3(x,y,z,'g')