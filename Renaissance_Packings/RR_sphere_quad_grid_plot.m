function RR_sphere_tri_grid_plot(x,xR,N,m1,m2)

figure(2), hold on, axis equal, axis tight
for i=1:N, for j=1:N+1                                        % Plot cells (corners at x)
  if mod(j,2)==1, lw=3; else lw=1; end
  plot3([x(1,i,j) x(1,i+1,j)],[x(2,i,j) x(2,i+1,j)],[x(3,i,j) x(3,i+1,j)],"k-","LineWidth",lw);
end, end
for i=1:N+1, for j=1:N                                       
  if mod(i,2)==1, lw=3; else lw=1; end
  plot3([x(1,i,j) x(1,i,j+1)],[x(2,i,j) x(2,i,j+1)],[x(3,i,j) x(3,i,j+1)],"k-","LineWidth",lw);
end, end

for i=1:N; for j=1:N                                         % Plot Red points (centers at sR)
   if mod(i,2)==0 & mod(j,2)==0, lw=2; else, lw=1; end
   if mod(i+j,2)==0, m=m1; else, m=m2; end
   plot3(xR(1,i,j),xR(2,i,j),xR(3,i,j),m,"MarkerSize",10,'linewidth',lw);
end, end
