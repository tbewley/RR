% script <a href="matlab:RC_CALEtest">RC_CALEtest</a>
% Test <a href="matlab:help RC_CALE">RC_CALE</a> with random A and random Q>0.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.5.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_SylvesterTest, RC_CAREtest, RC_DALEtest, RC_DAREtest. 

disp('Now testing RC_CALE with random A and random Q>0.')
clear; n=5; Q=randn(n); Q=Q*Q'; A=randn(n);
X=RC_CALE(A,Q); error_RC_CALE=norm(A*X+X*A'+Q), disp(' ')

% end script RC_CALEtest
