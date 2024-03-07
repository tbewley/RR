% script <a href="matlab:FalsePositionTest">FalsePositionTest</a>
% Test <a href="matlab:help FalsePosition">FalsePosition</a> on the function in <a href="matlab:help Example_3_2_Compute_f">Example_3_2_Compute_f</a>.
% See also BisectionTest.  Depends on FindRootBracketTest.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap03
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

FindRootBracketTest                                                  % Bracket the root.

disp('Now testing FalsePosition on the function in Example 3.2.')
figure(2), clf, title('Convergence of the false position algorithm') % Prepare a nice plot.
xx=[x1:(x2-x1)/1000:x2]; for i=1:1001, yy(i)=Example_3_2_Compute_f(xx(i),0,p); end
plot(xx,yy,'k-',[x1 x2],[0 0],'b-'), hold on, grid
[x_false_position,evals]=FalsePosition(x1,x2,@Example_3_2_Compute_f,1e-6,1,p), hold off
disp(' ')

% end script FalsePositionTest
