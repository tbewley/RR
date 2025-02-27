% script path_init
% Initialize the path environment for using the Renaissance Repository.
% You can check your path in Matlab at any time by typing "path".
%
% You should call the RR path init codes automatically when firing up Matlab on your computer,
% by appending calls to path_init in the startup.m file of your userpath directory.
% Matlab provides guidance on this subject here: https://www.mathworks.com/help/matlab/ref/startup.html
%
% In short, fire up Matlab, and type the command 'userpath', which will return the name of a directory.
% WITHIN THAT DIRECTORY (important!), edit the file startup.m (or, create a file of this name
% if one doesn't already exist); this file should contain (at least) the following line:
%    RRbase='/Users/bewley/RR'; cd(RRbase); path_init
% NOTE: replace the directory name in single quotes above with the full path to the location
% that you have installed the RR codebase on your computer.  Note that forward slashes (/),
% as shown above, are used on Macs, whereas backslashes (\) are used in Windows; on a Windows machine,
% the full path to this directory might look something like, e.g., 'C:\Users\bewley\RR'
% You can also put other commonly needed Matlab initialization commands in your startup.m file.
%
% Renaissance Repository, https://github.com/tbewley/RR
% Copyright 2024 by Thomas Bewley, and published under the BSD 3-Clause License

format compact, close all
% IMPORTANT: modify the definition of RRbase in the startup.m code (see above) to indicate the
% full path to the RR codebase on your computer.
addpath(strcat(RRbase,'/Labs'));
addpath(strcat(RRbase,'/Renaissance_Robotics/chap01'),...
        strcat(RRbase,'/Renaissance_Robotics/chap02'),...
        strcat(RRbase,'/Renaissance_Robotics/chap02/PRNGs'),...
        strcat(RRbase,'/Renaissance_Robotics/chap02/PRNGs/other'),...
        strcat(RRbase,'/Renaissance_Robotics/chap02/PRNGs/tests'),...
        strcat(RRbase,'/Renaissance_Robotics/chap02/special_functions'),...
        strcat(RRbase,'/Renaissance_Robotics/chap03'),...
        strcat(RRbase,'/Renaissance_Robotics/chap04'),...
        strcat(RRbase,'/Renaissance_Robotics/chap05'),...
        strcat(RRbase,'/Renaissance_Robotics/chap06'),...
        strcat(RRbase,'/Renaissance_Robotics/chap07'),...
        strcat(RRbase,'/Renaissance_Robotics/chap08'),...
        strcat(RRbase,'/Renaissance_Robotics/chap09'),...
        strcat(RRbase,'/Renaissance_Robotics/chap10'),...
        strcat(RRbase,'/Renaissance_Robotics/chap11'),...
        strcat(RRbase,'/Renaissance_Robotics/chap12'),...
        strcat(RRbase,'/Renaissance_Robotics/chap13'),...
        strcat(RRbase,'/Renaissance_Robotics/chap14'),...
        strcat(RRbase,'/Renaissance_Robotics/chap15'),...
        strcat(RRbase,'/Renaissance_Robotics/chap16'),...
        strcat(RRbase,'/Renaissance_Robotics/chap17'),...
        strcat(RRbase,'/Renaissance_Robotics/chap18'),...
        strcat(RRbase,'/Renaissance_Robotics/chap19'),...
        strcat(RRbase,'/Renaissance_Robotics/chapAA'),...
        strcat(RRbase,'/Renaissance_Robotics/chapAA/classes'),...
        strcat(RRbase,'/Renaissance_Robotics/chapAA/wrap_math'),...
        strcat(RRbase,'/Renaissance_Robotics/chapAB'));
addpath(strcat(RRbase,'/Numerical_Renaissance/chap01'),...
        strcat(RRbase,'/Numerical_Renaissance/chap02'),...
        strcat(RRbase,'/Numerical_Renaissance/chap03'),...
        strcat(RRbase,'/Numerical_Renaissance/chap04'),...
        strcat(RRbase,'/Numerical_Renaissance/chap05'),...
        strcat(RRbase,'/Numerical_Renaissance/chap06'),...
        strcat(RRbase,'/Numerical_Renaissance/chap07'),...
        strcat(RRbase,'/Numerical_Renaissance/chap08'),...
        strcat(RRbase,'/Numerical_Renaissance/chap09'),...
        strcat(RRbase,'/Numerical_Renaissance/chap10'),...
        strcat(RRbase,'/Numerical_Renaissance/chap11'),...
        strcat(RRbase,'/Numerical_Renaissance/chap12'),...
        strcat(RRbase,'/Numerical_Renaissance/chap13'),...
        strcat(RRbase,'/Numerical_Renaissance/chap14'),...
        strcat(RRbase,'/Numerical_Renaissance/chap15'),...
        strcat(RRbase,'/Numerical_Renaissance/chap16'),...
        strcat(RRbase,'/Numerical_Renaissance/chap17'),...
        strcat(RRbase,'/Numerical_Renaissance/chap18'),...
        strcat(RRbase,'/Numerical_Renaissance/chap19'));
addpath(strcat(RRbase,'/Renaissance_Robotics'),strcat(RRbase,'/Numerical_Renaissance'),RRbase);
disp("Path set for using the Renaissance Repository (RR), including codes discussed")
disp("in the forthcoming texts Renaissance Robotics and Numerical Renaissance.")
disp("Note: please use GitHub Desktop to keep "+RRbase+" on your computer")
disp("in sync with the main RR repository at https://github.com/tbewley/RR"+newline)
% end script path_init
