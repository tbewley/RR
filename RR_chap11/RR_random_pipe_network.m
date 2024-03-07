function [X,node,n,tri]=RR_random_pipe_network(n,L)
% TEST: [X,node,num_nodes,tri]=RR_random_pipe_network(50,11); num_nodes
%       [distance,route]=RR_dijkstra(node,X,num_nodes);
%       [node,num_pipes]=RR_eulerize(distance,node,route,X,num_nodes);
%       [circuit]=RR_hierholzer(node,X,num_nodes,num_pipes);
%       [circuit]=RR_northstar(node,X,num_nodes,num_pipes,route);
%% Renaissance Robotics codebase, Chapter 11, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

X=[randi(L,n-1,2); 1 1]-[(L-1)/2+1 (L-1)/2]; X=sortrows(sortrows(X,2));
while 1; [X,n,modified]=remove_duplicates(X,n,L); if ~modified, break, end, end
X=X([2:n],:); n=n-1;
center=1; dist=norm(X(center,:));
for i=2:n, disti=norm(X(i,:)); if disti<dist, center=i; dist=disti; end, end
X=[X(center,:); X([1:center-1],:); X([center+1:n],:)];
X(:,:)=X(:,:)-X(1,:);
for i=2:n, r(i)=norm(X(i,:)); end, [a,i]=max(r);
X=X([1,i,2:i-1,i+1:n],:);
tri=delaunay(X);
thresh=L/10; m=size(tri,1); number_of_triangles_before_pruning=m, j=1; while j<=m
   l(1)=norm(X(tri(j,1),:)-X(tri(j,2),:));
   l(2)=norm(X(tri(j,2),:)-X(tri(j,3),:));
   l(3)=norm(X(tri(j,3),:)-X(tri(j,1),:));
   if max(l)>thresh, tri=tri([1:j-1,j+1:m],:); m=m-1; j=j-1; end
   j=j+1;
end, number_of_triangles_after_pruning=m
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
%{
for i=1:n, if node(i).odd,
     plot(X(i,1),X(i,2),'ro','MarkerFaceColor','r','MarkerSize',10)
  else
    plot(X(i,1),X(i,2),'bo','MarkerFaceColor','b','MarkerSize',10)
end, end, axis off, axis square, axis tight
plot(X(1:2,1),X(1:2,2),'ko','MarkerFaceColor','k','MarkerSize',15)
pause;
%}
phi=atan2(X(2,2),X(2,1));
for i=2:n, R=norm(X(i,:)); theta=atan2(X(i,2),X(i,1));
   X(i,1)=R*sin(phi-theta);
   X(i,2)=R*cos(phi-theta);
end, 
close all, figure(1), triplot(tri,X(:,1),X(:,2)), hold on
for i=1:n, if node(i).odd,
     plot(X(i,1),X(i,2),'ro','MarkerFaceColor','r','MarkerSize',10)
  else
    plot(X(i,1),X(i,2),'bo','MarkerFaceColor','b','MarkerSize',10)
end, end, axis off, axis square, axis tight
plot(X(1:2,1),X(1:2,2),'ko','MarkerFaceColor','k','MarkerSize',15)

end % function RR_random_pipe_network
%%%%%%%%%%%%
function [X,n,mod]=remove_duplicates(X,n,L)
mod=false; for i=1:n-1,
     if (X(i,:)==X(i+1,:) | norm(X(i+1,:))>L*(1/2 + sin(7*atan2(X(i+1,1),X(i+1,2)))/10)),
     X=X([1:i,i+2:n],:); n=n-1; mod=true; return, end
   end
end