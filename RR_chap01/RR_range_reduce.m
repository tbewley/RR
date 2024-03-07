function [out,sign]=RR_range_reduce(in)
% function [out,sign]=RR_range_reduce(in)
% Performs range reduction.
% NOTE:   initialize cordic_tables by calling RR_cordic_init script (just once)
% INPUT:  in=any real angle
% OUTPUT: out=in-2*pi*n+pi*(1-sign)/2, with -pi/2<=out<=pi/2
%             (thus, sign=-1 corresponds to input angle in quadrant 2 or 3)
%% Renaissance Robotics codebase, Chapter 1, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

twopi=2*pi;                % Range reduction to 0<=t<2*pi
c=floor(in/twopi); out=in-twopi*c;
q=1+floor(out/(pi/2));     % Further range reduction to -pi/2<=t<pi/2
switch q
  case 1, sign= 1;          
  case 2, sign=-1; out=out-pi;    
  case 3, sign=-1; out=out+pi;
  case 4, sign= 1; out=out-twopi;
end
end