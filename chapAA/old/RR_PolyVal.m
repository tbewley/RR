function v=RR_PolyVal(p,s)
% function v=RR_PolyVal(p,s)
% For n=length(p), compute p(1)*s(i)^(n-1) + ... + p(n-1)*s(i) + p(n) for each s(i) in s.
% INPUTS: p = vector of polynimal coefficients
%         s = vector of values of s at which to evaluate polynomial
% OUTPUT: v = vector of values of evaluated polynomial
% TEST1:  s=10, p=[2 4 5], v=RR_PolyVal(p,s)    % Evaluates p(s)=2*s^2+4*s+5 for s=10
% TEST2:  % Evaluate p(s)=(s-1)(s-2)(s-3)=s^3+6*s^2+11*s+6 for s=1, s=2, and s=3
%         r=[1 2 3], p=RR_Poly(r), check=RR_PolyVal(p,r)
% Renaissance Robotics codebase, Appendix A, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

n=length(p); for j=1:length(s); v(j)=0; for i=0:n-1, v(j)=v(j)+p(n-i)*s(j)^i; end, end
end % function RR_PolyVal
