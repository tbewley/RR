function s=RR_Stirling_Number(n,k)
% function s=RR_Stirling_Number(n,k)
% Compute the Stirling number of the second kind, S(n,k), for a given n and k
% See:  https://en.wikipedia.org/wiki/Stirling_numbers_of_the_second_kind
% INPUTS:  n,k integers
% OUTPUT:  s   = (1/k!) * sum_{j=0}^k (-1)^(k-j) * Choose(k,j) * j^n
% TEST:    s=RR_StirlingNumber(6,4)  % (answer, by above wikipedia page, is 65)
% Renaissance Robotics codebase, Appendix A, https://github.com/tbewley/NR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

s=0; for j=0:k, s=s+(-1)^(k-j)*RR_Choose(k,j)*j^n; end, s=s/RR_Factorial(k);
end % function RR_Stirling_Number