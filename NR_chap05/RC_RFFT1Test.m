% script <a href="matlab:RC_RFFT1Test">RC_RFFT1Test</a>
% Test <a href="matlab:help RC_RFFT1">RC_RFFT1</a> and <a href="matlab:help RC_RFFT1inv">RC_RFFT1inv</a> with random u.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.5.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_RFFT2Test, RC_RFFTtest.

disp('Now testing RC_RFFT1 and and RC_RFFT1inv on a random real vector')
N=16; u=randn(N,1); uhat=RC_RFFT1(u,N); u1=RC_RFFT1inv(uhat,N);
original_u=u.', transformed=uhat.', transformed_back=u1.'
mean_of_u              =sum(u)/N
zero_wavenumber_of_uhat=real(uhat(1))
mean_square_of_u       =norm(u)^2/N
sum_of_squares_of_uhat =norm(real(uhat(1)))^2+norm(imag(uhat(1)))^2+2*norm(uhat(2:end))^2
transform_error = norm(u-u1)
mean_value_error= (mean_of_u-zero_wavenumber_of_uhat)^2
parseval_error  = (mean_square_of_u-sum_of_squares_of_uhat)^2                                                      

% end script RC_RFFT1Test
