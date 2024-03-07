% script IntTest                                     % Numerical Renaissance Codebase 1.0
L=.1; R=2;  
disp('First, test the standard trapezoidal integration method.')
figure(1); clf; hold off;  format compact; 
[int,evals] = IntTrap(@Func10a,L,R,2^9)

pause; disp('Next, test the Romberg integration method.')
figure(1); clf; hold off;  format compact; 
[int,evals] = IntRomberg(@Func10a,L,R,8)

pause; disp('Finally, test the adaptive integration method.')
% Try changing epsilon to get a more or less accurate result.
figure(1); clf; hold off;  format compact; 
epsilon=1e-4;  b=(L+R)/2;  fa=Func10a(L);  fb=Func10a(b);  fc=Func10a(R);  
[int,evals]=IntAdapt(@Func10a,L,R,epsilon,3,fa,fb,fc)
% end script IntTest.m
