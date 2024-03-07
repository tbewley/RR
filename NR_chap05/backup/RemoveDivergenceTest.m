% script <a href="matlab:RemoveDivergenceTest">RemoveDivergenceTest</a>
% Test <a href="matlab:help RemoveDivergence">RemoveDivergence</a> with a randomly-generated 3D velocity field.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.10.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

NX=16; NY=32; NZ=64; LX=1.0; LY=2.0; LZ=3.0;  % First, set up physical
KX=(2*pi/LX)*[[0:NX/2-1]'];                   % domain and the wavenumbers
KY=(2*pi/LY)*[[0:NY/2]';[-NY/2+1:-1]'];       % within it.
KZ=(2*pi/LZ)*[[0:NZ/2]';[-NZ/2+1:-1]'];
v1=rand(NX,NY,NZ); v2=rand(NX,NY,NZ); v3=rand(NX,NY,NZ);  % Initialize v
v1hat(:,:,:)=RFFT3D(v1(:,:,:),NX,NY,NZ);      % Transform u to Fourier space
v2hat(:,:,:)=RFFT3D(v2(:,:,:),NX,NY,NZ);
v3hat(:,:,:)=RFFT3D(v3(:,:,:),NX,NY,NZ);      % Now, remove the divergence.
v_divergence=ComputeDivergence(v1hat,v2hat,v3hat,NX,NY,NZ,KX,KY,KZ)
[u1hat,u2hat,u3hat]=RemoveDivergence(v1hat,v2hat,v3hat,NX,NY,NZ,KX,KY,KZ);
u_divergence=ComputeDivergence(u1hat,u2hat,u3hat,NX,NY,NZ,KX,KY,KZ), disp(' ')
% end script RemoveDivergenceTest
