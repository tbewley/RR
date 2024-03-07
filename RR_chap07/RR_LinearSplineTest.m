% script <a href="matlab:RR_LinearSplineTest">RR_LinearSplineTest</a>
% Test <a href="matlab:help RR_LinearSpline">RR_LinearSpline</a> on data from a smooth function.
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/RR_chap07
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

close all, clear, L=4*pi; xmin=0; xmax=L; ep=.0001; nd=10; n=100;
xd=[xmin:L/(nd-1):xmax]; fd=sin(xd+ep)./(xd+ep); x=[xmin:L/(n-1):xmax]; f=sin(x+ep)./(x+ep);
LS=RR_LinearSpline(x,xd,fd); plot(xd,fd,'k+',x,f,'k--',x,LS,'k-'); axis([0 L -.25 1.05])

% end script RR_LinearSplineTest
