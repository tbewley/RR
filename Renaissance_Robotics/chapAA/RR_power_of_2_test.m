function out=RR_power_of_2_test(n)
% function out=RR_power_of_2_test(n)
% out is true of the input integer n is a power of 2, false otherwise
% TEST: for i=-5:10, fprintf('i=%d, power_of_2=%d\n',i,RR_power_of_2_test(int64(i))), end
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

out=(n~=0 & (bitand(n,n-1)==0));
