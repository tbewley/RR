function RR_draw_tri3(a,b,c)
% Draw a triangle between points {a,b,c} in 3D
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Packings)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE
fill3([a(1),b(1),c(1)],[a(2),b(2),c(2)],[a(3),b(3),c(3)], ...
	  [.8 .8 .8],'LineWidth',3,'EdgeColor','b');
end % RR_draw_tri3