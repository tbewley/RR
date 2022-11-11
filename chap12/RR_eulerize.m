function [node,odd]=RR_eulerize(distance,node,route,X,n)
odd=[]; for i=1:n, if node(i).odd, odd=[odd i]; end, end, m=size(odd,2)
D=distance(odd,odd);
if n<15, [seq,length]=RR_min_pair_length(D,m);
else     [seq,length]=RR_min_pair_length_approx(D,m); end, odd=odd(seq)
for i=1:2:m-1
	r=route{odd(i),odd(i+1)}; plot(X(r,1),X(r,2),'r-','LineWidth',2)
end
end % function RR_eulerize