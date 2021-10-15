function [pstar] = QuaternionConjugate(p)
% function [pstar] = QuaternionConjugate(p)
% Compute the conjugate of a quaternions.  Note: handles symbolic elements.
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 17.2.2.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap17">Chapter 17</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.

pstar=[p(1);-p(2);-p(3);-p(4)];

end % function QuaternionConjugate
