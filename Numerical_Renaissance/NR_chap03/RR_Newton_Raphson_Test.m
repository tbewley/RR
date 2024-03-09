function NewtonRaphsonTest
% function <a href="matlab:NewtonRaphsonTest">NewtonRaphsonTest</a>
% Test <a href="matlab:help NewtonRaphson">NewtonRaphson</a> on the function in <a href="matlab:help Example_3_2_Compute_f">Example_3_2_Compute_f</a>.
% Note the use of function handles to pass the names of the problem-specific functions
% Example_3_1_Compute_f & Example_3_1_Compute_A into the general NewtonRaphson code.

disp('Now testing NewtonRaphson on the function in Example 3.2.')
x=NewtonRaphson([0; 1],2,@Example_3_1_Compute_f,@Example_3_1_Compute_A)  % smooth
x=NewtonRaphson([0;-1],2,@Example_3_1_Compute_f,@Example_3_1_Compute_A)  % erratic
disp(' ')
end % function NewtonRaphsonTest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [f] = Example_3_1_Compute_f(x)
f=[ x(1)*x(1)+3*cos(x(2))-1; x(2)+2*sin(x(1))-2 ]; 
end % function Example_3_1_Compute_f
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [A] = Example_3_1_Compute_A(x)
A=[ 2*x(1), -3*sin(x(2));  2*cos(x(1)),  1 ];
end % function Example_3_1_Compute_A
