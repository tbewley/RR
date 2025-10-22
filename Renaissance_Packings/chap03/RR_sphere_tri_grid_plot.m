function RR_sphere_tri_grid_plot(x,xR,xB,N,m1,m2)

figure(2), hold on, axis equal, axis tight
for i=1:N, for j=1:N+1-i                                     % Plot cells (corners at x)
  if mod(j,2)==1, lw=3; else lw=1; end
  plot3([x(1,i,j) x(1,i+1,j)],[x(2,i,j) x(2,i+1,j)],[x(3,i,j) x(3,i+1,j)],"k-","LineWidth",lw);
  if mod(i,2)==1, lw=3; else lw=1; end
  plot3([x(1,i,j) x(1,i,j+1)],[x(2,i,j) x(2,i,j+1)],[x(3,i,j) x(3,i,j+1)],"k-","LineWidth",lw);
  if mod(i+j,2)==1, lw=3; else lw=1; end
  plot3([x(1,i+1,j) x(1,i,j+1)],[x(2,i+1,j) x(2,i,j+1)],[x(3,i+1,j) x(3,i,j+1)],"k-","LineWidth",lw);
end, end
for i=1:N; for j=1:N+1-i                                    % Plot Red points (centers at sR)
   if mod(i,2)==0 & mod(j,2)==0, lw=2; else, lw=1; end 
   plot3(xR(1,i,j),xR(2,i,j),xR(3,i,j),m1,"MarkerSize",10,'linewidth',lw);
end, end
for i=2:N; for j=1:N+1-i                                    % Plot Black points (centers at sB)
   if mod(i,2)==0 & mod(j,2)==1, lw=2; else, lw=1; end 
   plot3(xB(1,i,j),xB(2,i,j),xB(3,i,j),m2,"MarkerSize",10,'linewidth',lw);
end, end
