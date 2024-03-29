% script <a href="matlab:RR_FFTnonreorderedTest">RR_FFTnonreorderedTest</a>
% Test <a href="matlab:help FFTnonreordered">RR_FFTnonreordered</a> with random u.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.4.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also FFTrecursiveTest, FFTdirectTest.

N=8; u=randn(N,1);
disp('Now testing RR_FFTdirect on a random real vector')
uhat=RR_FFTdirect(u,N,-1); u1=RR_FFTdirect(uhat,N,1); 
transformed_reordered=uhat.', transform_error=norm(u-u1), disp(' ');

disp('Now testing RR_FFTnonreordered on a random real vector')
uhat=RR_FFTnonreordered(u,N,-1); u1=RR_FFTnonreordered(uhat,N,1);
transformed_nonreordered=uhat.', transform_error=norm(u-u1), 
disp('Note: the transformed coefficients are precisely the same as those returned by');
disp('FFTdirect, but in a different (that is, bit-reversed) order.'); disp(' ');
                                               
% end script RR_FFTnonreorderedTest
