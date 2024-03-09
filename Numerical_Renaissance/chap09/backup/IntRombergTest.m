function IntRombergTest
% function <a href="matlab:IntTrapezoidalTest">IntTrapezoidalTest</a>
% Test <a href="matlab:help IntTrapezoidal">IntTrapezoidal</a> on a representative scalar function.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 9.3.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap09">Chapter 9</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also IntRombergTest, IntAdaptiveTest.

disp('Testing the Romberg integration method.')
figure(1); clf; hold off; L=.1; R=2; int=IntRomberg(@Compute_f_Test,L,R,8)
end % function IntRombergTest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f=Compute_f_Test(x)
f=sin(1./x); plot(x,f,'x'); hold on
end % function Compute_f_Test
