% script <a href="matlab:RR_DALEtest">RR_DALEtest</a>
% Test <a href="matlab:help RR_DALE">RR_DALE</a> with random F and random Q>0.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.5.3.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RR_CALEtest, RR_CAREtest, RR_DAREtest. 

disp('Now testing RR_DALE with random F and random Q>0.')
clear; n=40; Q=randn(n); Q=Q*Q'; F=randn(n);
X=RR_DALE(F,Q); error_RR_DALE=norm(F*X*F'-X+Q), disp(' ')

% end script RR_DALEtest
