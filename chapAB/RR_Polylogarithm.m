function [Li]=RR_polylogarithm(p,r)
% function [Li_num,Li_den]=RR_polylogarithm(p,z)
% Compute Li_{-p}(r/z) for integer p>0 as a rational function of z.
% By Table 9.1 of RR, Li_{-p}(r/z) is the Z transform of k^p r^k for integer p>0.
% INPUT:  p=order of power in above formula (p>0)
%         r=constant in above formula
% OUTPUT: Li = Li_{-p}(r/z), written as a rational function of z
% TEST1:  syms r; Li=RR_polylogarithm(1,r)
% TEST2:  syms r; Li=RR_polylogarithm(2,r)  % Compare these entries to those in Table 9.1
% TEST3:  syms r; Li=RR_polylogarithm(3,r)
% Renaissance Robotics codebase, Appendix B, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

Li_den=RR_poly([1/r -1])^(p+1); Li_num=RR_poly(0);
for k=p:-1:0, Li_num=Li_num+factorial(k)*RR_stirling_number(p+1,k+1)*RR_poly([1/r -1])^(p-k); end
Li=RR_tf(Li_num,Li_den);