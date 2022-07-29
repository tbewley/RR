function [r] = QuaternionMultiply(p,q)
% function [r] = QuaternionMultiply(p,q)
% Compute the product of two quaternions.  Note: handles symbolic elements.
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 17.2.2.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap04">Chapter 17</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.
% Depends on <a href="matlab:help RotateCompute">RotateCompute</a>, <a href="matlab:help Rotate">Rotate</a>.

P=[p(1) -p(2) -p(3) -p(4); p(2) p(1)  -p(4) p(3);
   p(3)  p(4)  p(1) -p(2); p(4) -p(3)  p(2) p(1)]; r=P*[q(1);q(2);q(3);q(4)];

end % function QuaternionMultiply
