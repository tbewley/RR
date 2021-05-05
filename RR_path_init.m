% script RR_path_init
% Initialize the path environment for using the Renaissance Robotics codebase.
% Tip: set up a symbolic link in a convenient place to make it easy to call this script
% when firing up Matlab or Octave.  This can be done, e.g., using Matlab in MacOS as follows:
%   ln -s /usr/local/lib/RR/RRpathsetup.m ~/Documents/MATLAB/startup.m
% Be sure to modify "base" appropriately below if the RR library is not in /usr/local/lib
% See the preface of Renaissance Robotics for further discussion.

% Here are some examples of where you might put the RR codebase:
% base='/usr/local/lib/RR/';
base='~/RR/';
base='~/Renaissance_Robotics/RR/';

format compact, clc, close all, cd ~
addpath(strcat(base,'chap01'),strcat(base,'chap02'),strcat(base,'chap03'), ...
        strcat(base,'chap04'),strcat(base,'chap05'),strcat(base,'chap06'), ...
        strcat(base,'chap07'),strcat(base,'chap08'),strcat(base,'chap09'), ...
        strcat(base,'chap10'),strcat(base,'chap11'),strcat(base,'chap12'), ...
        strcat(base,'chap13'),strcat(base,'chap14'),strcat(base,'chap15'), ...
        strcat(base,'chap16'),strcat(base,'chap17'),strcat(base,'chap18'),base)
disp(['  Path set for using Renaissance Robotics codebase; ' ...
         'please use  .' char(10)])
     
     
% end script NRCpathsetup
