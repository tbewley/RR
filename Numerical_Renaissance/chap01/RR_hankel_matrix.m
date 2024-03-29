function R=RR_hankel_matrix(top,right)
% function R=RR_hankel_matrix(top,right)
% Construct a Hankel matrix with specified top row and right column.
% This function is inefficient with memory, and is meant for demonstration purposes only.
% INPUTS: top   = specified top row of matrix
%         right = specified right column of matrix
% OUTPUT: R     = the corresponding Hankel matrix.
% TEST:   R=RR_hankel_matrix([1 2 3 4 5],[5 6 7 8 9]), disp(' ')
%% Renaissance_Repository, https://github.com/tbewley/RR/tree/main/NR_chap01
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

n=length(top); for row=1:n; R(row,:)=[top(row:n) right(2:row)]; end
end