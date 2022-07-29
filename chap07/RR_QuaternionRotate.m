function [p_prime] = QuaternionRotate(p,q)
% function [p_prime] = QuaternionRotate(p,q)
% Directly compute the rotation p'=q*p*inv(q).  Note: handles symbolic elements.
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 17.2.2.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap04">Chapter 17</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.
% Depends on <a href="matlab:help RotateCompute">RotateCompute</a>, <a href="matlab:help Rotate">Rotate</a>.

p_prime=...
[q(1)^2+q(2)^2-q(3)^2-q(4)^2, 2*q(2)*q(3) - 2*q(1)*q(4)  , 2*q(2)*q(4) + 2*q(1)*q(3);
 2*q(2)*q(3) + 2*q(1)*q(4)  , q(1)^2-q(2)^2+q(3)^2-q(4)^2, 2*q(3)*q(4) - 2*q(1)*q(2);
 2*q(2)*q(4) - 2*q(1)*q(3)  , 2*q(3)*q(4) + 2*q(1)*q(2)  , q(1)^2-q(2)^2-q(3)^2+q(4)^2]*...
 [p(end-2);p(end-1);p(end)];

end % function QuaternionMultiply
