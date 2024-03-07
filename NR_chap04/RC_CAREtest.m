% script <a href="matlab:RC_CAREtest">RC_CAREtest</a>
% Test <a href="matlab:help RC_CARE">RC_CARE</a> with random A and random Q>0, S>0.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.5.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_CALEtest, RC_DALEtest, RC_DAREtest. 

disp('Now testing RC_CARE with random A and random Q>0, S>0.')
clear; n=40; Q=randn(n); Q=Q*Q'; S=randn(n); S=S*S'; A=randn(n);
X=RC_CARE(A,S,Q); error_RC_CARE=norm(A'*X+X*A-X*S*X+Q), disp(' ')

% end script RC_CAREtest
