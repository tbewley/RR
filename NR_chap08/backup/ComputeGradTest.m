function ComputeGradTest
% function <a href="matlab:ComputeGradTest">ComputeGradTest</a>
% Test <a href="matlab:help ComputeGrad">ComputeGrad</a> by calculating (analytically) the gradient of a
% known function and comparing against the 2nd-order FD and CSD approximations of the same.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 8.3.5.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap08">Chapter 8</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

format long; x=randn(2,1), g_analytic=ComputeGrad_Test(x)
g_FD  = ComputeGrad(x,2,@Compute_f_Test,'FD', 1e-5) 
g_CSD = ComputeGrad(x,2,@Compute_f_Test,'CSD',1e-15) 
error_FD  = norm(g_analytic-g_FD)
error_CSD = norm(g_analytic-g_CSD), format short

end % function ComputeGradTest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f=Compute_f_Test(x)
f=x(1)^3*x(2) + sin(x(2));
end % function Compute_f_Test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function g=ComputeGrad_Test(x)
g=[3*x(1)^2*x(2); x(1)^3+cos(x(2))]
end % function ComputeGrad_Test