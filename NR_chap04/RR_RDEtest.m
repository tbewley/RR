% script <a href="matlab:RC_RDEtest">RC_RDEtest</a>
% Test <a href="matlab:help RC_RDE">RC_RDE</a> with random F and random Q>0, S>0, simply by marching the RC_RDE to steady
% state and making sure that the result satisfies the corresponding RC_DARE.
% See <a href="matlab:web('http://numerical-renaissance.com')">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.5.4.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

disp('Now marching RC_RDE to steady state with random F and random Q>0, S>0.')
clear; format compact; n=6; Q=randn(n); Q=Q*Q'; S=randn(n); S=S*S'; F=randn(n);
X=RC_RDE(eye(n),F,S,Q,n,1024), error_RC_RDEsteadystate=norm(F'*X*inv(eye(n)+S*X)*F-X+Q),disp(' ')

% end script RC_RDEtest
