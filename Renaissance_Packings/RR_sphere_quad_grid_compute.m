function [x,xR,xB]=RR_sphere_quad_grid_compute(x,N,omega,v)

% calculate stretching function for each side of quadrilateral
if omega>0
  s1=RR_chord_division_for_uniform_arc_length(x(:,  1,  1),x(:,N+1,  1),N,omega);
  s2=RR_chord_division_for_uniform_arc_length(x(:,  1,  1),x(:,  1,N+1),N,omega);
  s3=RR_chord_division_for_uniform_arc_length(x(:,N+1,  1),x(:,N+1,N+1),N,omega);
  s4=RR_chord_division_for_uniform_arc_length(x(:,  1,N+1),x(:,N+1,N+1),N,omega);  
else
  s1=[1:(N-1)]/N; s2=s1; s3=s1; s4=s1;
end
for i=2:N  % calculate points on edges of each quadrilateral
   x(:,i,1)    =s1(i-1)*x(:,N+1,  1)+(1-s1(i-1))*x(:,  1,  1);  % edge from (2,1)   to (N,1)
   x(:,1,i)    =s2(i-1)*x(:,  1,N+1)+(1-s2(i-1))*x(:,  1,  1);  % edge from (1,2)   to (1,N)
   x(:,i,N+1)  =s3(i-1)*x(:,N+1,N+1)+(1-s3(i-1))*x(:,  1,N+1);  % edge from (2,N+1) to (N,N+1)
   x(:,N+1,i)  =s4(i-1)*x(:,N+1,N+1)+(1-s4(i-1))*x(:,N+1,  1);  % edge from (N+1,2) to (N+1,N)
end
for i=2:N, for j=2:N               % calculate points on interior of quadrilateral, between edges
   x(:,i,j)=RR_line_intersection(x(:,i,1),x(:,i,N+1),x(:,1,j),x(:,N+1,j)); 
end, end

global RR_VERBOSE, if RR_VERBOSE>0,
  figure(1), clf, hold on, axis equal, axis tight              % Plot cells BEFORE the projection
  for i=1:N, for j=1:N+1
    if mod(j,2)==1, lw=3; else lw=1; end
    plot3([x(1,i,j) x(1,i+1,j)],[x(2,i,j) x(2,i+1,j)],[x(3,i,j) x(3,i+1,j)],"k-","LineWidth",lw);
  end, end
  for i=1:N+1, for j=1:N
    if mod(i,2)==1, lw=3; else lw=1; end
    plot3([x(1,i,j) x(1,i,j+1)],[x(2,i,j) x(2,i,j+1)],[x(3,i,j) x(3,i,j+1)],"k-","LineWidth",lw);
  end, end
  view(v(1),v(2)); figure(2), clf
end

for i=1:N, for j=1:N                                          % define xR 
  xR(:,i,j)=(x(:,i,j)+x(:,i+1,j)+x(:,i,j+1)+x(:,i+1,j+1))/4;  % (red if i+j=even, black if i+j=odd)
  lat=atan2d(xR(3,i,j),sqrt(xR(1,i,j)^2+xR(2,i,j)^2));        % project xR to sphere
  lon=atan2d(xR(2,i,j),xR(1,i,j));
  xR(1,i,j)=cosd(lat)*cosd(lon);
  xR(2,i,j)=cosd(lat)*sind(lon);
  xR(3,i,j)=sind(lat);
end, end
for i=1:N+1; for j=1:N+1                     
  lat=atan2d(x(3,i,j),sqrt(x(1,i,j)^2+x(2,i,j)^2));       % project x (corners of cells) to sphere
  lon=atan2d(x(2,i,j),x(1,i,j));
  x(1,i,j)=cosd(lat)*cosd(lon);
  x(2,i,j)=cosd(lat)*sind(lon);
  x(3,i,j)=sind(lat);
end, end