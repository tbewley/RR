function [seq,length]=RR_min_pair_length_approx(D,n)
% function [seq,length]=RR_min_pair_length_approx(D,n)
% Given an n x n matrix D (note: n must be even) quantifying the distance between
% any two nodes in a graph, estimate the minimizer of the sum,
% over i=1:2:n-1, of the distances between node seq(i) and seq(i+1).
% Note: this approximate search scales pretty well with n.  Tested up to n=100.
% TEST:  clear; n=8; D=rand(n,n); D=D+D'; for i=1:n; D(i,i)=0; end, D
%        seq=[1:n], stupid=0; for i=1:2:n-1, stupid=stupid+D(i,i+1); end, stupid
%        tic, [seq,fast]=RR_min_pair_length_approx(D,n), toc
%        fast_check=0; for i=1:2:n-1, fast_check=fast_check+D(seq(i),seq(i+1)); end, fast_check
%        tic, [seq,best]=RR_min_pair_length(D,n), toc
%        best_check=0; for i=1:2:n-1, best_check=best_check+D(seq(i),seq(i+1)); end, best_check
% Renaissance Robotics codebase, Chapter 12, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

remaining=[1:n]; length=0;
for i=1:2:n-3
    [new_pair,new_length]=max_min_pair_length(D(remaining,remaining),n+1-i);
    seq(i:i+1)=remaining(new_pair);
    new_pair
    remaining=remaining([1:new_pair(1)-1,new_pair(1)+1:new_pair(2)-1,new_pair(2)+1:n+1-i])
    length=length+D(seq(i),seq(i+1));
end
n
seq(n-1:n)=remaining; length=length+D(seq(n-1),seq(n));
end % function
%%%%%%%%%%%%%%%%%%%
function [new_pair,length]=max_min_pair_length(D,n)
for i=1:n
  [row_min(i),row_which(i)]=min(D(i,[1:i-1,i+1:n]));
end
[length,i]=max(row_min), j=row_which(i), new_pair=sort([i j]);
end