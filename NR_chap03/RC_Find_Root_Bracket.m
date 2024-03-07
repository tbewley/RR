function [x1,x2] = FindRootBracket(x1,x2,Compute_f,p)
% function [x1,x2] = FindRootBracket(x1,x2,Compute_f,p)
% Assuming the scalar function defined in Compute_f is smooth, bounded, and has opposite
% signs for sufficiently large and small arguments, find x1 and x2 that bracket a root.
% See also Bisection, FalsePosition.  Verify with FindRootBracketTest.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap03
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

while Compute_f(x1,0,p)*Compute_f(x2,0,p)>=0, int=x2-x1; x1=x1-0.5*int; x2=x2+0.5*int; end
end % function FindRootBracket
