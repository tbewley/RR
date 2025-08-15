function RR_Plot_Pyramid(a,s,c)
% Draws a little 3D pyramid below a point with apex a and scale s with colorspec c
% TEST: figure(1), clf; RR_Plot_Pyramid([0 1 1],1,'k')
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 6)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE
if nargin<3, c='k'; end, if nargin<2, s=0.1; end, 
h=s*.707; w=s*.5; P=[-w -w -h; -w w -h; w w -h; w -w -h; 0 0 0];
ind=[1 2 5];   patch(P(ind,1)+a(1), P(ind,2)+a(2), P(ind,3)+a(3), c), hold on
ind=[2 3 5];   patch(P(ind,1)+a(1), P(ind,2)+a(2), P(ind,3)+a(3), c)
ind=[3 4 5];   patch(P(ind,1)+a(1), P(ind,2)+a(2), P(ind,3)+a(3), c)
ind=[4 1 5];   patch(P(ind,1)+a(1), P(ind,2)+a(2), P(ind,3)+a(3), c)
ind=[1 2 3 4]; patch(P(ind,1)+a(1), P(ind,2)+a(2), P(ind,3)+a(3), c)