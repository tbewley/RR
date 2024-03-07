% script <a href="matlab:RC_HessenbergTest">RC_HessenbergTest</a>
% Test <a href="matlab:help RC_Hessenberg">RC_Hessenberg</a> on a random matrix.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.4.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

disp('Now testing RC_Hessenberg on a random matrix.')
A=rand(8), [T,V]=RC_Hessenberg(A), error=norm(A-V*T*V'), disp(' ')

% end script RC_HessenbergTest
