function IntAdaptiveTest
% function <a href="matlab:IntAdaptiveTest">IntAdaptiveTest</a>
% Test <a href="matlab:help IntAdaptive">IntAdaptive</a> on a representative scalar function.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 9.4.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap09">Chapter 9</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also IntRombergTest, IntAdaptiveTest.

disp('Testing the adaptive integration method.')
figure(1); clf; hold off; L=.1; R=2; b=(L+R)/2;
fa=Compute_f_Test(L); fb=Compute_f_Test(b); fc=Compute_f_Test(R);
[int,evals]=IntAdaptive(@Compute_f_Test,L,R,1e-4,3,fa,fb,fc)
disp('Note that we used 1/4 of the function evaluations as used in the Romberg case.')
disp(' ')
end % function IntAdaptiveTest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f=Compute_f_Test(x)
f=sin(1./x); plot(x,f,'x'); hold on
end % function Compute_f_Test
