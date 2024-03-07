% script <a href="matlab:RC_RFFT2Test">RFFT2Test</a>
% Test <a href="matlab:help RC_RFFT2">RFFT2</a> and <a href="matlab:help RC_RFFT2inv">RC_RFFT2inv</a> with random u and v.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.5.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_RFFT1Test, RC_RFFTTest.

disp('Now testing RC_RFFT2 and RC_RFFT2inv on two random real vectors')
N=16; u=randn(N,1); v=randn(N,1); [uhat,vhat]=RC_RFFT2(u,v,N); [u1,v1]=RC_RFFT2inv(uhat,vhat,N);

original_u=u.', transformed=uhat.', transformed_back=u1.'
mean_of_u              =sum(u)/N
zero_wavenumber_of_uhat=real(uhat(1))
mean_square_of_u       =norm(u)^2/N
sum_of_squares_of_uhat =norm(real(uhat(1)))^2+norm(imag(uhat(1)))^2+2*norm(uhat(2:end))^2
transform_error = norm(u-u1)
mean_value_error= (mean_of_u-zero_wavenumber_of_uhat)^2
parseval_error  = (mean_square_of_u-sum_of_squares_of_uhat)^2                                                      

original_v=v.', transformed=vhat.', transformed_back=v1.'
mean_of_v              =sum(v)/N
zero_wavenumber_of_vhat=real(vhat(1))
mean_square_of_v       =norm(v)^2/N
sum_of_squares_of_vhat =norm(real(vhat(1)))^2+norm(imag(vhat(1)))^2+2*norm(vhat(2:end))^2
transform_error = norm(v-v1)
mean_value_error= (mean_of_v-zero_wavenumber_of_vhat)^2
parseval_error  = (mean_square_of_v-sum_of_squares_of_vhat)^2                                                      

% end script RC_RFFT2Test
