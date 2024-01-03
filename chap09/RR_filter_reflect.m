function HPF=RR_filter_reflect(LPF)
% function HPF=RR_filter_reflect(LPF)
% Generates a HPF by reflecting a LPF via the transformation
%   HPF(s/omegac)=LPF(omegac/s)
% INPUT:  LPF=a unit-gain LPF, of type RR_tf
% OUTPUT: HPF=the corresponding HPF, of type RR_tf
% TEST:   LPF=RR_LPF_butterworth(4,2), figure(1), RR_bode(LPF)
%         HPF=RR_filter_reflect(LPF),  figure(2), RR_bode(HPF)
% Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

nr=LPF.den.n-LPF.num.n;          den=LPF.den.poly(end:-1:1);
temp=[zeros(1,nr) LPF.num.poly]; num=temp(end:-1:1);   HPF=RR_tf(num,den);
