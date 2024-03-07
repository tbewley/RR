disp('Now testing the Lorenz system with RK4.')      % Numerical Renaissance Codebase 1.0
RK4(1,@RHS_Lorenz,@SimInit_Lorenz,@SimPlot_Lorenz_Rossler)
% Comment out the above (which takes a long time to finish) to do the test below.
disp('Now testing the Rossler system with RK4.')
RK4(1,@RHS_Rossler,@SimInit_Rossler,@SimPlot_Lorenz_Rossler)
