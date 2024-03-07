% script <a href="matlab:RFFTtest">RFFTtest</a>
% Test <a href="matlab:help RFFT">RFFT</a> and <a href="matlab:help RFFTinv">RFFTinv</a> with random u.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.5.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RFFT2Test, RFFT1test.

disp('Now testing RFFT and RFFTinv on a random real vector')
N=16; u=randn(N,1); [uhat]=RFFT(u,N); [u1]=RFFTinv(uhat,N);
original_u=u.', transformed=uhat.', transformed_back=u1', transform_error=norm(u-u1)
mean_square_of_u=norm(u)^2/N
sum_of_squares_of_uhat=norm(real(uhat(1)))^2+norm(imag(uhat(1)))^2+2*norm(uhat(2:end))^2
parseval_error=(mean_square_of_u-sum_of_squares_of_uhat)^2, disp(' ')                                          
                                                                                                        
% end script RFFTtest
