function [A,B,C]=RR_SSTransform(A,B,C,R)
% function [A,B,C]=RR_SSTransform(A,B,C,R)
% Transform a state-space form.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 20.1.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help RR_SSTransformTest">RR_SSTransformTest</a>.

Ri=Inv(R); A=Ri*A*R; B=Ri*B; C=C*R;
end % function RR_SSTransform