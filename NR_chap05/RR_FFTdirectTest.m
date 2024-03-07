% script <a href="matlab:RC_FFTdirectTest">RC_FFTdirectTest</a>
% Test <a href="matlab:help FFTdirect">RC_FFTdirect</a> with random real and complex u.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.4.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also FFTrecursiveTest, FFTnonreorderedTest.

clear; N=8; v=randn(N,2); v(:,2)=v(:,2)+i*randn(N,1);
for i=1:2
  if i==1, disp('Now testing RC_FFTdirect on a random real vector')
  else, disp('Now testing RC_FFTdirect on a random complex vector'), end
  u=v(:,i); uhat=RC_FFTdirect(u,N,-1); u1=RC_FFTdirect(uhat,N,1);
  original=u.', transformed=uhat.', transformed_back=u1.'
  mean_of_u              =sum(u)/N
  zero_wavenumber_of_uhat=uhat(1)
  mean_square_of_u       =norm(u)^2/N
  sum_of_squares_of_uhat =norm(uhat)^2
  transform_error = norm(u-u1)
  mean_value_error= (mean_of_u-zero_wavenumber_of_uhat)^2
  parseval_error  = (mean_square_of_u-sum_of_squares_of_uhat)^2, disp(' ')                                                   
end
                                            
% end script RC_FFTdirectTest