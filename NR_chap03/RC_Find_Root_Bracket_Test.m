% script <a href="matlab:FindRootBracketTest">FindRootBracketTest</a>
% Test <a href="matlab:help FindRootBracket">FindRootBracket</a> on the function in <a href="matlab:help Example_3_2_Compute_f">Example_3_2_Compute_f</a>.
% See also BisectionTest, FalsePositionTest. 
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

clear; p=[1 1 -20 50];

disp('Now testing FindRootBracket on the function in Example 3.2.')
[x1,x2]=FindRootBracket(0,2,@Example_3_2_Compute_f,p), disp(' ')  

% end script FindRootBracketTest
