function [seq,length]=RR_min_pair_length(D,n)
% function [seq,length]=RR_min_pair_length(D,n)
% Given an n x n matrix D (note: n must be even) quantifying the distance between
% any two nodes in a graph, perform (recursively) an exhaustive search to minimize
% the sum, over i=1:2:n-1, of the distances between node seq(i) and seq(i+1).
% Note: this exhaustive search scales terribly with n.  Tested up to n=16.
% TEST:  n=16; D=randn(n,n); D=D.*D; for i=1:n; D(i,i)=0; end, D
%        tic, [seq,length]=RR_min_pair_length(D,n), toc
%        check=0; for i=1:2:n-1, check=check+D(seq(i),seq(i+1)); end, check
% Renaissance Robotics codebase, Chapter 12, https://github.com/tbewley/RR
% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License. 

length=Inf;  new_seq(1)=1;
for i=2:n,   new_seq(2)=i;
    if n>2 
      remaining=[2:i-1,i+1:n];
      [order,new_length]=RR_min_pair_length(D(remaining,remaining),n-2);
      new_seq(3:n)=remaining(order); new_length=new_length+D(1,i);
      if new_length<length, seq=new_seq; length=new_length; end
    else
      seq=new_seq; length=D(1,2);
    end
end
fprintf('Optimal extra distance implemented for Eulerization'), disp(length)
end % function RR_min_pair_length