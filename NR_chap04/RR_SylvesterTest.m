% script <a href="matlab:RC_SylvesterTest">RC_SylvesterTest</a>
% Test <a href="matlab:help RC_Sylvester">RC_Sylvester</a> with random A and B and C.
% See <a href="matlab:web('http://numerical-renaissance.com')">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.5.1.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

disp('Now testing RC_Sylvester with random A and B and C.')
m=4, n=5, A=rand(m,m); B=rand(n,n); C=rand(m,n);
g=1; X=RC_Sylvester(A,B,C,g,m,n), norm(A*X-X*B-g*C), disp(' ')

% end script RC_SylvesterTest
