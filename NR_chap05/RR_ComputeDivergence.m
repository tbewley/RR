function [div]=ComputeDivergence(u1hat,u2hat,u3hat,NX,NY,NZ,KX,KY,KZ)
% function [div]=ComputeDivergence(u1hat,u2hat,u3hat,NX,NY,NZ,KX,KY,KZ)
% Compute the divergence of a periodic 3D vector field on a uniform grid.
% Input and output are in Fourier space, where the operations performed are quite simple.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.10.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RemoveDivergence.  Verify with: RemoveDivergenceTest.

div=0;
for I=1:NX/2, for J=1:NY, for K=1:NZ
  div=div+i*KX(I)*u1hat(I,J,K)+i*KY(J)*u2hat(I,J,K)+i*KZ(K)*u3hat(I,J,K);
end, end, end
end % function ComputeDivergence.m
