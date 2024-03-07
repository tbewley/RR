% script <a href="matlab:RC_DALEtest">RC_DALEtest</a>
% Test <a href="matlab:help RC_DALE">RC_DALE</a> with random F and random Q>0.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.5.3.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_CALEtest, RC_CAREtest, RC_DAREtest. 

disp('Now testing RC_DALE with random F and random Q>0.')
clear; n=40; Q=randn(n); Q=Q*Q'; F=randn(n);
X=RC_DALE(F,Q); error_RC_DALE=norm(F*X*F'-X+Q), disp(' ')

% end script RC_DALEtest
