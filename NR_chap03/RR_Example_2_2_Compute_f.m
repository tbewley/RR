function [f] = Example_3_2_Compute_f(x,verbose,p)
% function [f] = Example_3_2_Compute_f(x,verbose,p)
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap03
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

f=PolyVal(p,x);  if verbose, plot([x x],[0,f],'b-',x,f,'bx'), pause(0.2), end
end % function Example_3_2_Compute_f

