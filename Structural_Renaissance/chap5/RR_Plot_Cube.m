function RR_Plot_Cube(a,s,c)
% Draws a little 3D rectangular prism below a point a with scale s and colorspec c
% TEST: figure(1), clf; RR_Plot_Cube([1 2 3],0.5,'k')
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 6)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE
a
if nargin<3, c='k'; end, if nargin<2, s=0.1; end, m=s*-1; n=s*1;
fill3([m m m m]+a(1),[m m 0 0]+a(2),[m n n m]+a(3),c), hold on
fill3([n n n n]+a(1),[m m 0 0]+a(2),[m n n m]+a(3),c)
fill3([m m n n]+a(1),[m m m m]+a(2),[m n n m]+a(3),c)
fill3([m m n n]+a(1),[0 0 0 0]+a(2),[m n n m]+a(3),c)
fill3([m m n n]+a(1),[m 0 0 m]+a(2),[m m m m]+a(3),c)
fill3([m m n n]+a(1),[m 0 0 m]+a(2),[n n n n]+a(3),c)