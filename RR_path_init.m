% script RR_path_init
% Initialize the path environment for using the Renaissance Robotics (RR) codebase.
% You can check your path in Matlab at any time by typing "path".
%
% TIP: call the RR and NR init codes automatically when firing up Matlab on your computer
% by appending calls to RR_path_init and NR_path_init in the startup.m file of your userpath directory.
% Matlab provides guidance on this subject here:  https://www.mathworks.com/help/matlab/ref/startup.html
%
% In short, first type the command 'userpath' in Matlab, which will return the name of a directory.
% WITHIN THAT DIRECTORY (important!), edit the file startup.m (or, create a file of this name
% if one doesn't already exist); this file should contain (at least) the following two lines:
%    cd '/Users/bewley/RR'; RR_path_init
%    cd '/Users/bewley/NR'; NR_path_init
% NOTE: replace the directory names in single quotes above with the full paths to the locations
% that you have installed the RR and NR codebases on your computer.  Note that forward slashes (/),
% as shown above, are used on Macs, whereas backslashes (\) are used in Windows; on a Windows machine,
% the full path to one of these directories might look something like 'C:\Users\bewley\RR'
% Note you can also put other commonly needed Matlab initialization commands in your startup.m file.
%
% Renaissance Robotics codebase, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License.

format compact, close all
% IMPORTANT: modify the definition of RRbase below (inside the single quotes) to indicate the
% full path to the RR codebase on your computer.  Note that forward slashes (/),
% as shown below, are used on Macs, whereas backslashes (\) are used in Windows.
RRbase='/Users/bewley/RR';
addpath(strcat(RRbase,'/chap01'),strcat(RRbase,'/chap02'),strcat(RRbase,'/chap03'), ...
        strcat(RRbase,'/chap04'),strcat(RRbase,'/chap05'),strcat(RRbase,'/chap06'), ...
        strcat(RRbase,'/chap07'),strcat(RRbase,'/chap08'),strcat(RRbase,'/chap09'), ...
        strcat(RRbase,'/chap10'),strcat(RRbase,'/chap11'),strcat(RRbase,'/chap12'), ...
        strcat(RRbase,'/chap13'),strcat(RRbase,'/chap14'),strcat(RRbase,'/chap15'), ...
        strcat(RRbase,'/chap16'),strcat(RRbase,'/chap17'),strcat(RRbase,'/chap18'), ...
        strcat(RRbase,'/chapAA'),strcat(RRbase,'/chapAB'),RRbase) 
disp(newline+"Path set for using the Renaissance Robotics codebase.")
disp("Note: please use GitHub Desktop to keep your local directory at ")
disp("           "+RRbase)
disp("in sync with the base branch of the Renaissance Robotics codebase repository at")
disp("           https://github.com/tbewley/RR")
disp("See section 2.6 of the Renaissance Robotics text for further info."+newline)
