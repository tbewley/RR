% script <a href="matlab:RC_RemoveDivergenceTest">RC_RemoveDivergenceTest</a>
% Test <a href="matlab:help RC_RemoveDivergence">RC_RemoveDivergence</a> with a randomly-generated 3D velocity field.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.10.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

disp('Now testing RemoveDivergence on a random 3D vector field')
NX=16; NY=32; NZ=64; LX=1.0; LY=2.0; LZ=3.0;  % First, set up physical
KX=(2*pi/LX)*[[0:NX/2-1]'];                   % domain and the wavenumbers
KY=(2*pi/LY)*[[0:NY/2]';[-NY/2+1:-1]'];       % within it.
KZ=(2*pi/LZ)*[[0:NZ/2]';[-NZ/2+1:-1]'];
v1=rand(NX,NY,NZ); v2=rand(NX,NY,NZ); v3=rand(NX,NY,NZ); N=NX*NY*NZ; % Initialize v
for i=1:2
  v1hat=RC_RFFT3D(v1(:,:,:),NX,NY,NZ);      % Transform v to Fourier space
  v2hat=RC_RFFT3D(v2(:,:,:),NX,NY,NZ);
  v3hat=RC_RFFT3D(v3(:,:,:),NX,NY,NZ);      % Now, remove the divergence.
  [u1hat,u2hat,u3hat]=RC_RemoveDivergence(v1hat,v2hat,v3hat,NX,NY,NZ,KX,KY,KZ);
  u1=RC_RFFT3Dinv(u1hat(:,:,:),NX,NY,NZ);   % Transform uhat back to Physical space
  u2=RC_RFFT3Dinv(u2hat(:,:,:),NX,NY,NZ);
  u3=RC_RFFT3Dinv(u3hat(:,:,:),NX,NY,NZ);   % u should now be divergence free.
  if i==1, disp('Divergence before and after pass 1:')
    v_divergence=RC_ComputeDivergence(v1hat,v2hat,v3hat,NX,NY,NZ,KX,KY,KZ)
    u_divergence=RC_ComputeDivergence(u1hat,u2hat,u3hat,NX,NY,NZ,KX,KY,KZ)
    v1=u1; v2=u2; v3=u3; clear u1 u2 u3;
  else, disp('Amount u changes when removing divergence again in pass 2:')
    norm(reshape(u1-v1,N,1))+norm(reshape(u2-v2,N,1))+norm(reshape(u3-v3,N,1)), disp(' ')
  end
end
% end script RC_RemoveDivergenceTest
