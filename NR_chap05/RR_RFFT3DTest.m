% script <a href="matlab:RC_RFFT3DTest">RC_RFFT3DTest</a>
% Test <a href="matlab:help RC_RFFT3D">RC_RFFT3D</a> and <a href="matlab:help RC_RFFT3Dinv">RC_RFFT3Dinv</a> on a real 2D field that looks like an egg carton.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.10.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_RFFTtest.

disp('Now testing RC_RFFT3D and RC_RFFT3Dinv on a real 2D field that looks like an egg carton')

% Experiment with various NX, NY, NZ (powers of 2)  
clear; NX=32, NY=32, NZ=1  % Take NZ=1 for 2D problems, NZ>1 for 3D problems.

% Let's try putting in an oscillation at a particular wavenumber triplet w.
% The goal is that you will experiment with different 2D & 3D functions in this test code.
% Note: if w(1)=NX/2, w(2)=NY/2, or w(3)=NZ/2, the oscillation will be annihilated 
% by the dealiasing built into the RFFT3D algorithm (try it!)
w=[2,3,0];

N=NX*NY*NZ; kx1=2*pi/NX; ky1=2*pi/NY; kz1=2*pi/NZ;
for i=1:NX, for j=1:NY, for k=1:NZ
  u(i,j,k)=cos(w(1)*i*kx1)*cos(w(2)*j*ky1)*cos(w(3)*k*kz1)+1;  % Build egg carton.
end, end, end

uhat=RC_RFFT3D(u,NX,NY,NZ); u1=RC_RFFT3Dinv(uhat,NX,NY,NZ); % Transform, and transform back.

mean_of_u=sum(reshape(u,N,1))/N
zero_wavenumber_of_uhat=uhat(1,1,1)

mean_square_of_u=norm(reshape(u,N,1))^2/N
sum_of_squares_of_uhat=  norm(reshape(uhat(1,:,:),NY*NZ,1))^2+...
                       2*norm(reshape(uhat(2:NX/2,:,:),NY*NZ*(NX/2-1),1))^2, disp(' ')

transform_error=norm(reshape(u-u1,N,1))^2/N
mean_value_error=(mean_of_u-zero_wavenumber_of_uhat)^2
parseval_error=(mean_square_of_u-sum_of_squares_of_uhat)^2

if NZ==1,
  figure(1), surf(u), title('u before transforming')
  figure(2), subplot(2,1,1), mesh(real(uhat)), axis tight
             title('(top) real and (bottom) imaginary parts of uhat')
             subplot(2,1,2), mesh(imag(uhat)), axis tight
  figure(3), surf(u1), title('u1 (after transforming back)')
end, disp(' ')

% end script RC_RFFT3DTest
