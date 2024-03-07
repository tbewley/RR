% script <a href="matlab:RR_CALEtest">RR_CALEtest</a>
% Test <a href="matlab:help RR_CALE">RR_CALE</a> with random A and random Q>0.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.5.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RR_SylvesterTest, RR_CAREtest, RR_DALEtest, RR_DAREtest. 

disp('Now testing RR_CALE with random A and random Q>0.')
clear; n=5; Q=randn(n); Q=Q*Q'; A=randn(n);
X=RR_CALE(A,Q); error_RR_CALE=norm(A*X+X*A'+Q), disp(' ')

% end script RR_CALEtest
