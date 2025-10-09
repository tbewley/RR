% RR_triangulation_of_sphere
%
% This (stand-alone) code develops a grid over the sphere that has overall
% red/black ordering and octahedral symmetry.  It starts by developing a
% triangular grid in lat/lon coordinates over each octant of the sphere,
% then shifts and reflects it around.  Note that six (triangular) voronoi
% cells meet up at their vertices almost everywhere, except at the six
% vertices of an octahedron, where four (triangular) voronoi cells meet up.
%
% The symbols that are boldfaced are those that are kept when you do a 2x
% coarsening of the grid (for multigrid acceleration when solving elliptic
% eqns on this grid), which of course retains the overall red/black ordering.
%
% Note #1: applying some "numerical Tammes problem" regularization would nudge
% this grid a bit, making it slightly more regular while retaining its
% connectivity, but it’s already pretty uniform, given that there is no
% getting around Euler’s formula V-E+F=2.  This construction should already be
% "pretty close" to a solution of Tammes problem for the number of points it uses.
%
% Note #2: Icosahedral symmetry doesn’t achieve overall red/black ordering, so
% it is not nearly as good for multigrid!
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Packings)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE
% Related preliminary work in collaboration with Joe Cessna (see his thesis).

clear; figure(1); clf; R=1; N=2^4; % Try 2^2, 2^3, or 2^4...

% uncomment one of the following three lines for plot of interest.
% for oct=1:1   % uncomment for first octant only
for oct=1:2:7   % uncomment for western  hemisphere only
% for oct=1:4   % uncomment for northern hemisphere only

switch oct
    case 1, hem=+1; marker1='r*'; marker2='k*'; offset=0;
    case 2, hem=+1; marker1='r*'; marker2='k*';  offset=180;
    case 3, hem=+1; marker1='k*'; marker2='r*';  offset=90;
    case 4, hem=+1; marker1='k*'; marker2='r*';  offset=270;
    case 5, hem=-1; marker1='k*'; marker2='r*';  offset=0;
    case 6, hem=-1; marker1='k*'; marker2='r*';  offset=180;
    case 7, hem=-1; marker1='r*'; marker2='k*';  offset=90;
    case 8, hem=-1; marker1='r*'; marker2='k*';  offset=270;
end        

for i=1:N+1
   lat(i,[1:N+2-i])=hem*90*(i-1)/(N);
   if i>1, for j=1:i
       lon(N+2-i,j)=90*(j-1)/(i-1)+offset;
   end, end
end
lon(N+1,1)=45+offset;
for i=1:N+1; for j=1:N+2-i
   x(i,j)=R*cosd(lat(i,j))*cosd(lon(i,j));
   y(i,j)=R*cosd(lat(i,j))*sind(lon(i,j));
   z(i,j)=R*sind(lat(i,j));
end, end
figure(1), hold on, axis equal, axis tight
for i=1:N
   for j=1:N+1-i
       if mod(j,2)==1, lw=3; else lw=1; end
       plot3([x(i,j) x(i+1,j)],[y(i,j) y(i+1,j)],[z(i,j) z(i+1,j)],"k-","LineWidth",lw);
       if mod(i,2)==1, lw=3; else lw=1; end
       plot3([x(i,j) x(i,j+1)],[y(i,j) y(i,j+1)],[z(i,j) z(i,j+1)],"k-","LineWidth",lw);
       if mod(i+j,2)==1, lw=3; else lw=1; end
       plot3([x(i+1,j) x(i,j+1)],[y(i+1,j) y(i,j+1)],[z(i+1,j) z(i,j+1)],"k-","LineWidth",lw);
   end
end

for i=1:N, for j=1:N+1-i
   latR(i,j)=(lat(i,j) + lat(i+1,j) + lat(i,j+1))/3;
   lonR(i,j)=(lon(i,j) + lon(i+1,j) + lon(i,j+1))/3;
end, end
lonR(N,1)=45+offset;
for i=1:N; for j=1:N+1-i
   xR(i,j)=R*cosd(latR(i,j))*cosd(lonR(i,j));
   yR(i,j)=R*cosd(latR(i,j))*sind(lonR(i,j));
   zR(i,j)=R*sind(latR(i,j));
end, end
for i=1:N; for j=1:N+1-i
   if mod(i,2)==0 & mod(j,2)==0, lw=2; else, lw=1; end 
   plot3(xR(i,j),yR(i,j),zR(i,j),marker1,"MarkerSize",10,'linewidth',lw);
end, end

for i=2:N, for j=1:N+1-i
   latB(i,j)=(lat(i,j) + lat(i-1,j+1) + lat(i,j+1))/3;
   lonB(i,j)=(lon(i,j) + lon(i-1,j+1) + lon(i,j+1))/3;
end, end
for i=2:N; for j=1:N+1-i
   xB(i,j)=R*cosd(latB(i,j))*cosd(lonB(i,j));
   yB(i,j)=R*cosd(latB(i,j))*sind(lonB(i,j));
   zB(i,j)=R*sind(latB(i,j));
end, end
for i=2:N; for j=1:N+1-i
   if mod(i,2)==0 & mod(j,2)==1, lw=2; else, lw=1; end 
   plot3(xB(i,j),yB(i,j),zB(i,j),marker2,"MarkerSize",10,'linewidth',lw);
end, end

end
view(92,25)