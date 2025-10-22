function [x,xR,xB]=RR_sphere_tri_grid_compute(x,N,omega,v)

% calculate stretching function for each side of triangle
if omega>0
  s1=RR_chord_division_for_uniform_arc_length(x(:,1,  1),x(:,N+1,1),N,omega);
  s2=RR_chord_division_for_uniform_arc_length(x(:,1,  1),x(:,1,N+1),N,omega);
  s3=RR_chord_division_for_uniform_arc_length(x(:,1,N+1),x(:,N+1,1),N,omega);
else
  s1=[1:(N-1)]/N; s2=s1; s3=s1;
end
for i=2:N  % calculate points on edges of each triangle
   x(:,i,1)    =s1(i-1)*x(:,N+1,1)+(1-s1(i-1))*x(:,1,  1);     % edge from (2,1) to (N,1)
   x(:,1,i)    =s2(i-1)*x(:,1,N+1)+(1-s2(i-1))*x(:,1,  1);     % edge from (1,2) to (1,N)
   x(:,i,N+2-i)=s3(i-1)*x(:,N+1,1)+(1-s3(i-1))*x(:,1,N+1);     % edge from (2,N) to (N,2)
end
for i=2:N, for j=2:N+2-i  % calculate points on interior of triangle, between edges
   x(:,i,j)=RR_line_intersection(x(:,i,1),x(:,i,N+2-i),x(:,1,j),x(:,N+2-j,j),x(:,i+j-1,1),x(:,1,i+j-1)); 
end, end

global RR_VERBOSE, if RR_VERBOSE>0,
  figure(1), clf, hold on, axis equal, axis tight    % Plot cells BEFORE the projection
  for i=1:N, for j=1:N+1-i                           
    if mod(j,2)==1, lw=3; else lw=1; end
    plot3([x(1,i,j) x(1,i+1,j)],[x(2,i,j) x(2,i+1,j)],[x(3,i,j) x(3,i+1,j)],"k-","LineWidth",lw);
    if mod(i,2)==1, lw=3; else lw=1; end
    plot3([x(1,i,j) x(1,i,j+1)],[x(2,i,j) x(2,i,j+1)],[x(3,i,j) x(3,i,j+1)],"k-","LineWidth",lw);
    if mod(i+j,2)==1, lw=3; else lw=1; end
    plot3([x(1,i+1,j) x(1,i,j+1)],[x(2,i+1,j) x(2,i,j+1)],[x(3,i+1,j) x(3,i,j+1)],"k-","LineWidth",lw);
  end, end
  view(v(1),v(2)); figure(2), clf
end

for i=1:N, for j=1:N+1-i   % define xR yR zR
  xR(:,i,j)=(x(:,i,j) + x(:,i+1,j) + x(:,i,j+1))/3;    % define xR (on Red points)
  lat=atan2d(xR(3,i,j),sqrt(xR(1,i,j)^2+xR(2,i,j)^2)); % project xR to sphere
  lon=atan2d(xR(2,i,j),xR(1,i,j));
  xR(1,i,j)=cosd(lat)*cosd(lon);
  xR(2,i,j)=cosd(lat)*sind(lon);
  xR(3,i,j)=sind(lat);
end, end
for i=2:N, for j=1:N+1-i   
  xB(:,i,j)=(x(:,i,j) + x(:,i-1,j+1) + x(:,i,j+1))/3;  % define xB (on Black points)
  lat=atan2d(xB(3,i,j),sqrt(xB(1,i,j)^2+xB(2,i,j)^2)); % project xB to sphere
  lon=atan2d(xB(2,i,j),xB(1,i,j));
  xB(1,i,j)=cosd(lat)*cosd(lon);
  xB(2,i,j)=cosd(lat)*sind(lon);
  xB(3,i,j)=sind(lat);
end, end
for i=1:N+1; for j=1:N+2-i                            
  lat=atan2d(x(3,i,j),sqrt(x(1,i,j)^2+x(2,i,j)^2));   % project x (corners of cells) to sphere
  lon=atan2d(x(2,i,j),x(1,i,j));
  x(1,i,j)=cosd(lat)*cosd(lon);
  x(2,i,j)=cosd(lat)*sind(lon);
  x(3,i,j)=sind(lat);
end, end