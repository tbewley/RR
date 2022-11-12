function [node,num_pipes]=RR_eulerize(distance,node,route,X,n)
% Renaissance Robotics codebase, Chapter 12, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

odd=[]; for i=1:n, if node(i).odd, odd=[odd i]; end, end, num_odd_modes=size(odd,2)
D=distance(odd,odd);
if num_odd_modes<15, [seq,length]=RR_min_pair_length(D,num_odd_modes);
else                 [seq,length]=RR_min_pair_length_approx(D,num_odd_modes); end
odd=odd(seq); odd=reshape(sortrows(sort(reshape(odd,2,num_odd_modes/2))',1)',1,num_odd_modes);
for i=1:2:num_odd_modes-1
	r=route{odd(i),odd(i+1)}; plot(X(r,1),X(r,2),'r-','LineWidth',3),
	for j=1:size(r,2)-1;
	  node(r(j  )).connected=[node(r(j  )).connected r(j+1)];
	  node(r(j+1)).connected=[node(r(j+1)).connected r(j  )];
	end
end
for i=1:n, node(i).num_pipes=size(node(i).connected,2); end
s=0; for i=1:n, s=s+node(i).num_pipes; end, num_pipes=s/2
end % function RR_eulerize