function [dh,dl,r]=RR_div128s(xh,xl,y)
% function [dh,dl,r]=RR_div128s(xh,xl,y)
% Note: this is a SIMPLIFIED version RR_div128, assuming y is zero in its upper 64 bits.
% INPUTS:  x={xh,xl}, y where {xh,xl,y} are each uint64 (or single,double)
% OUTPUTS: d={dh,dl} and r where {dh,dl,r} are uint64 and x=y*d+r
% TEST:    ?
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

% TODO: debug!!

[pl,cl]=RR_prod64(xl,y); 
[ph,ch]=RR_prod64(xh,y);
[ph,cs]=RR_sum64(ph,cl);
c=RR_sum64(ch,cs);


 (A / Y)x3 + (((A % Y)x + B) / Y)x2 +
 (((((A % Y)x + B) % Y)x + C) / Y)x +
 ((((((A % Y)x + B) % Y)x + C) / Y)x + D) / Y. 

