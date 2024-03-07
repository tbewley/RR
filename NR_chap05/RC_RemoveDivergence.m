function [v1hat,v2hat,v3hat]=RC_RemoveDivergence(v1hat,v2hat,v3hat,NX,NY,NZ,KX,KY,KZ)
% function [v1hat,v2hat,v3hat]=RC_RemoveDivergence(v1hat,v2hat,v3hat,NX,NY,NZ,KX,KY,KZ)
% Remove the divergence of a periodic 3D vector field on a uniform grid.
% The input and output are in Fourier space, where the operations performed are simple.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.10.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_ComputeDivergence.  Verify with: RC_RemoveDivergenceTest.

for I=1:NX/2; for J=1:NY; for K=1:NZ
  if I*J*K > 1 
    qhat(I,J,K)=(i*KX(I)*v1hat(I,J,K)+i*KY(J)*v2hat(I,J,K)+...
                 i*KZ(K)*v3hat(I,J,K))/(-KX(I)^2-KY(J)^2-KZ(K)^2);
  else
    qhat(I,J,K)=0;
  end
  v1hat(I,J,K)=v1hat(I,J,K)-i*KX(I)*qhat(I,J,K);
  v2hat(I,J,K)=v2hat(I,J,K)-i*KY(J)*qhat(I,J,K);
  v3hat(I,J,K)=v3hat(I,J,K)-i*KZ(K)*qhat(I,J,K);
end; end; end;
end % function RC_RemoveDivergence
