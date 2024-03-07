function RC_ComputeGradTest
% function <a href="matlab:RC_ComputeGradTest">RC_ComputeGradTest</a>
% Test <a href="matlab:help RC_ComputeGrad">RC_ComputeGrad</a> by calculating (analytically) the gradient
% of a known function, and comparing against the 2nd-order FD and CSD approximations of the same.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap08
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

format long; x=randn(2,1),
g_analytic=Compute_Grad_Test(x)
g_FD  = RC_ComputeGrad(x,2,@Compute_f_Test,'FD', 1e-5) 
g_CSD = RC_ComputeGrad(x,2,@Compute_f_Test,'CSD',eps) 
error_FD  = norm(g_analytic-g_FD)
error_CSD = norm(g_analytic-g_CSD), format short

end % function RC_ComputeGradTest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f=Compute_f_Test(x)
f=x(1)^3*x(2) + sin(x(2));
end % function Compute_f_Test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function g=Compute_Grad_Test(x)
g=[3*x(1)^2*x(2); x(1)^3+cos(x(2))]
end % function Compute_Grad_Test