function d=RR_factorial(n)
% function d=RR_factorial(n)
% Compute the factorial for integer n
% TEST: for i=1:12; factorial  end
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

d=RR_int8(1); for i=2:n, d=d*i; end