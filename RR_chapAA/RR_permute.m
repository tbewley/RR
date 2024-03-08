function [a,b,c,d,e,f,g,h,i,j]=RR_permute(a,b,c,d,e,f,g,h,i,j)
% function [a,b,c,d,e,f,g,h,i,j]=RR_permute(a,b,c,d,e,f,g,h,i,j)
% A curiously simple function that simply permutes the inputs and outputs.
% INPUTS:  a,b,c,... = matlab objects containing pretty much anything
% OUTPUTS: first  output argument = whatever a had on input, SEE EXAMPLE USEAGE BELOW!!
%          second output argument = whatever b had on input,
%          third  output argument = whatever c had on input, ...
% TEST:    clc, a=randn, b=randn(1,2), c=randn(1,3), disp(' ')
%          [b,c,a]=RR_permute(a,b,c), disp(' ')  % Permute a->b, b->c, c->a  
%          [c,a,b]=RR_permute(a,b,c)             % Permute a->c, b->a, c->b
%          pause; d=randn(1,4), e='dude this is so cool', disp(' ')
%          [b,c,d,e,a]=RR_permute(a,b,c,d,e) % Permute a->b, b->c, c->d, d->e, e->a
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/RR_chapAA
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

if nargin~=nargout, error('RR_permute should have the same # of inputs & outpus')

end % function RR_permute