function [ph,pl]=RR_prod128ss(x,y)
% function [ph,pl]=RR_prod128ss(x,y)
% Note: this is a SIMPLIFIED version RR_prod128s, assuming {x,y} are zero in their upper 64 bits.
% INPUTS:  x, y where are each uint64 (or single,double)
% OUTPUTS: p=x*y where p={ph,pl} and {ph,pl} are uint64 (there is no possibility of carry)
% TEST: x=intmax('uint64'), y=3, [ph,pl]=RR_prod128ss(x,y)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

[pl,ph]=RR_prod64(x,y); 
