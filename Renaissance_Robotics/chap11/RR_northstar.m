function [circuit,travelled]=RR_northstar(node,X,n,num_pipes,route)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 11)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

for i=1:n, for j=1:node(i).num_pipes, travelled{i}(j)=false; end, end
circuit=route{1,2};
for i=1:length(circuit)-1
   current=circuit(i); next=circuit(i+1);     % plot the route.
   plot([X(current,1) X(next,1)],[X(current,2) X(next,2)],'k-','LineWidth',4); pause(0.25)
   for j=1:node(current).num_pipes
 		if node(current).connected(j)==next, travelled{current}(j)=true; break, end
	end
   for j=1:node(next).num_pipes
 		if node(next).connected(j)==current, travelled{next}(j)=true; break, end
	end
end
[circuit,travelled,alphanew]=turn_left(circuit,travelled,node,X,0);
for i=1:2000, i, [circuit,travelled,alphanew]=turn_left(circuit,travelled,node,X,alphanew); end
travelled;
end
%%%%%%%
function [circuit,travelled,alphanew]=turn_left(circuit,travelled,node,X,alphaold)
	n=length(circuit);
	current=circuit(n);
	for j=1:node(current).num_pipes
		if travelled{current}(j), epsilon(j)=-Inf; else
			k=node(current).connected(j);
			anew(j)=atan2((X(k,2)-X(current,2)),X(k,1)-X(current,1));
		   epsilon(j)=mod(anew(j)-alphaold+pi+.000001,2*pi);
   end, end
   [min_angle,j] = max(epsilon);  alphanew=anew(j);
   next=node(current).connected(j);
   circuit(n+1)=next;
   plot([X(current,1) X(next,1)],[X(current,2) X(next,2)],'k-','LineWidth',4); pause(0.25)
   travelled{current}(j)=true;
   for j=1:node(next).num_pipes
 		if node(next).connected(j)==current & ~travelled{next}(j), travelled{next}(j)=true; break, end
	end
end

%{

for i=1:length()
   current=route(end);
if length(loop)==1;
	old_angle=0;
else;
	last=loop(end-1);
	old_angle=atan2(X(current,2)-X(last,2),X(current,1)-X(last,1));
end
for j=1:node(current).num_pipes
   k(j)=node(current).connected(j);
   if travelled{current}(j), angle(j)=Inf;
   else angle(j)=atan2(X(k(j),2)-X(current,2),X(k(j),1)-X(current,1))-old_angle; end
   if angle>pi; angle=angle-2*pi; elseif angle<-pi; angle=angle+2*pi; end
end
[min_angle,i] = min(abs(angle)); next=k(i);
if min_angle<Inf;
	done=false; travelled{current}(i)=true;
	for j=1:node(next).num_pipes
 		if node(next).connected(j)==current & ~travelled{next}(j), travelled{next}(j)=true; break, end
	end
	loop=[loop next];
else 
	done=true;
end




end
%}


%{
while 1, [circuit,travelled,done]=extend_loop(circuit,travelled,node,X,n); if done, break, end, end
while length(circuit)-1<s                     % attach additional loops as necessary.
	for i=1:length(circuit)
        if sum(travelled{circuit(i)})<node(circuit(i)).num_pipes
		   loop=circuit(i); 
		   while 1, [loop,travelled,done]=extend_loop(loop,travelled,node,X,n); if done, break, end, end
		   circuit=[circuit(1:i-1) loop circuit(i+1:end)];  % insert new loop here
		end
    end
end
for i=1:length(route)
   current=circuit(i); next=circuit(i+1);     % plot the circuit.
   plot([X(current,1) X(next,1)],[X(current,2) X(next,2)],'k-','LineWidth',4); pause(0.25)
end
end % function RR_hierholzer
%%%%%%%%%%%%
function [loop,travelled,done]=extend_loop(loop,travelled,node,X,n)
current=loop(end);
if length(loop)==1;
	old_angle=0;
else;
	last=loop(end-1);
	old_angle=atan2(X(current,2)-X(last,2),X(current,1)-X(last,1));
end
for j=1:node(current).num_pipes
   k(j)=node(current).connected(j);
   if travelled{current}(j), angle(j)=Inf;
   else angle(j)=atan2(X(k(j),2)-X(current,2),X(k(j),1)-X(current,1))-old_angle; end
   if angle>pi; angle=angle-2*pi; elseif angle<-pi; angle=angle+2*pi; end
end
[min_angle,i] = min(abs(angle)); next=k(i);
if min_angle<Inf;
	done=false; travelled{current}(i)=true;
	for j=1:node(next).num_pipes
 		if node(next).connected(j)==current & ~travelled{next}(j), travelled{next}(j)=true; break, end
	end
	loop=[loop next];
else 
	done=true;
end
end % function extend_loop
%}
