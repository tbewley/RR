function [distance,route]=RR_dijkstra(node,X,n)
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/RR_chap11
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

for i=1:n, for j=1:n, route{i,j}=[]; if i==j, distance(i,j)=0; else, distance(i,j)=Inf; end, end, end
for i_start=1:n
   current_route=i_start; i_current=i_start; current_distance=0; 
   [distance,route]=explore_tree(i_start,i_current,current_route,current_distance,node,X,n,distance,route);
end
end % function RR_dijkstra
%%%%%%%%%%%%%%%%%%%%%
function [distance,route]=explore_tree(i_start,i_current,current_route,current_distance,node,X,n,distance,route)
% Note: recursive.  :)
if i_start==1; L=60; else; L=32; end
for i=1:node(i_current).num_pipes
   j=node(i_current).connected(i);
   new_distance=current_distance+node(i_current).length(i);
   if new_distance < distance(i_start,j) & new_distance < L
     distance(i_start,j)=new_distance;
     route{i_start,j}=[current_route j];
     distance(j,i_start)=new_distance;
     route{j,i_start}=[j current_route(end:-1:1)];     
     [distance,route]=explore_tree(i_start,j,route{i_start,j},new_distance,node,X,n,distance,route);
   end
end
end % function explore_tree


