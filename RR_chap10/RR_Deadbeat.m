function [d,c]=Deadbeat(b,a)
% function [d,c]=Deadbeat(b,a)
% Find a ripple-free deadbeat controller D(z)=d(z)/c(z) for a stable plant G(z)=b(z)/a(z).
% Algorithm due to Sirisena (1985).
%% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.
% Verify with DeadbeatTest.

n=length(a)-1; m=length(b)-1; d=a; c=[PolyVal(b,1) zeros(1,n)]-[zeros(1,n-m) b];
end % function Deadbeat
