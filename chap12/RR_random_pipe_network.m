function [X,node,n,tri]=RR_random_pipe_network(n,L)
% TEST: [X,node,num_nodes,tri]=RR_random_pipe_network(100,21); num_nodes
%       [distance,route]=RR_dijkstra(node,X,num_nodes);
%       [node,num_pipes]=RR_eulerize(distance,node,route,X,num_nodes);
%       [circuit]=RR_hierholzer(node,X,num_nodes,num_pipes)
% Renaissance Robotics codebase, Chapter 12, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 


X=[randi(L,n-1,2); 1 1]-[1 1]; X=sortrows(sortrows(X,2));
while 1; [X,n,modified]=remove_duplicates(X,n); if ~modified, break, end, end
tri=delaunay(X);
close all, figure(1), triplot(tri,X(:,1),X(:,2)), hold on
for i=1:n
  node(i).connected=[]; node(i).length=[];
  for j=1:length(tri)
  	col=find(tri(j,:)==i); if ~isempty(col)
  	   k=tri(j,mod(col-2,3)+1);
  	   if isempty(find(node(i).connected==k)), node(i).connected=[node(i).connected k]; end
  	   k=tri(j,mod(col-3,3)+1);
  	   if isempty(find(node(i).connected==k)), node(i).connected=[node(i).connected k]; end
  	end
  end
  node(i).connected=sort(node(i).connected);
  node(i).num_pipes=length(node(i).connected);
  if mod(node(i).num_pipes,2) == 1, node(i).odd=true; else, node(i).odd=false; end
  for j=1:node(i).num_pipes
     jj=node(i).connected(j);
     node(i).length(j)=sqrt((X(i,1)-X(jj,1))^2+(X(i,2)-X(jj,2))^2);
  end
end
m=0; for i=1:n, if node(i).odd,
     plot(X(i,1),X(i,2),'ro','MarkerFaceColor','r','MarkerSize',10), m=m+1;
  else
    plot(X(i,1),X(i,2),'bo','MarkerFaceColor','b','MarkerSize',10),
end, end, axis off

end % function RR_random_pipe_network
%%%%%%%%%%%%
function [X,n,mod]=remove_duplicates(X,n)
mod=false; for i=1:n-1, if X(i,:)==X(i+1,:), X=X([1:i,i+2:n],:); n=n-1; mod=true; return, end, end
end
