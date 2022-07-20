function [d,b]=RR_PolyDiv(b,a)
% function [d,b]=RR_PolyDiv(b,a)
% Perform polynomial division of a into b, resulting in quotient d with remainder in the modified b.
% INPUTS:  b,a= vectors of polynimal coefficients
% OUTPUTS: d= vectors of polynimal coefficients of quotient 
%          b= vectors of polynimal coefficients of remainder
% TEST1:   num=[1 2 3 4 5 6], den=[1 2 3], [div,rem]=RR_PolyDiv(num,den)
%          check=RR_PolyAdd(RR_PolyConv(div,den),rem)
% TEST2:   syms K, num=[1 K 2*K 3*K], den=[1 K], [div,rem]=RR_PolyDiv(num,den)
%          check=RR_PolyAdd(RR_PolyConv(div,den),rem)
% Renaissance Robotics codebase, Appendix A, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

m=length(b); n=length(a); if m<n d=0; else
  if strcmp(class(b),'sym')|strcmp(class(a),'sym'), syms d, end
  for j=1:m-n+1, d(j)=b(1)/a(1); b(1:n)=RR_PolyAdd(b(1:n),-d(j)*a); b=b(2:end); end, end
end % function RR_PolyDiv
