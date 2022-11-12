function [distance,route]=RR_dijkstra(node,X,n)
% Renaissance Robotics codebase, Chapter 12, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

for i=1:n, for j=1:n, route{i,j}=[]; if i==j, distance(i,j)=0; else, distance(i,j)=Inf; end, end, end
for i_start=1:n
   current_route=i_start; i_current=i_start; current_distance=0; 
   [distance,route]=explore_tree(i_start,i_current,current_route,current_distance,node,X,n,distance,route);
end
end % function RR_dijkstra
%%%%%%%%%%%%%%%%%%%%%
function [distance,route]=explore_tree(i_start,i_current,current_route,current_distance,node,X,n,distance,route)
% Note: recursive.  :)
for i=1:node(i_current).num_pipes
   j=node(i_current).connected(i);
   new_distance=current_distance+node(i_current).length(i);
   if new_distance < distance(i_start,j) & new_distance < 20
     distance(i_start,j)=new_distance;
     route{i_start,j}=[current_route j];
     [distance,route]=explore_tree(i_start,j,route{i_start,j},new_distance,node,X,n,distance,route);
   end
end
end % function explore_tree


