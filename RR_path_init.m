% script RR_path_init
% Initialize the path environment for using the Renaissance Robotics (RR) codebase.
% You can check your path in Matlab at any time by typing "path".
% PRO TIP: call this init code automatically when firing up Matlab or Octave by appending
% to the startup.m file in your Matlab or Octave installation as follows:
%   /bin/zsh
%     set RRbase "~/RR/"  
%     echo "cd" $RRbase"; RR_path_init" >> ~/Documents/MATLAB/startup.m
%   exit
% IMPORTANT: modify the definition of RRbase in the above zsh commands as needed.
% Renaissance Robotics codebase, https://github.com/tbewley/RR
% Copyright 2021 by Thomas Bewley, distributed under BSD 3-Clause License.

format compact, close all, cd ~
% IMPORTANT: modify the definition of RRbase below as needed:
RRbase='~/RR/';
addpath(strcat(RRbase,'/chap01'),strcat(RRbase,'/chap02'),strcat(RRbase,'/chap03'), ...
        strcat(RRbase,'/chap04'),strcat(RRbase,'/chap05'),strcat(RRbase,'/chap06'), ...
        strcat(RRbase,'/chap07'),strcat(RRbase,'/chap08'),strcat(RRbase,'/chap09'), ...
        strcat(RRbase,'/chap10'),strcat(RRbase,'/chap11'),strcat(RRbase,'/chap12'), ...
        strcat(RRbase,'/chap13'),strcat(RRbase,'/chap14'),strcat(RRbase,'/chap15'), ...
        strcat(RRbase,'/chap16'),strcat(RRbase,'/chap17'),strcat(RRbase,'/chap18'),RRbase)
disp(newline+"Path set for using the Renaissance Robotics codebase.")
disp("Note: please use GitHub Desktop to keep your local directory at ")
disp("           "+RRbase)
disp("in sync with the base branch of the Renaissance Robotics codebase repository at")
disp("           https://github.com/tbewley/RR")
disp("See section 2.6 of the Renaissance Robotics text for further info."+newline)
clear RRbase
