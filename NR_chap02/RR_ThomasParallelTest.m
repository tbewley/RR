% script <a href="matlab:RR_ThomasParallelTest">RR_ThomasParallelTest</a>
% Test <a href="matlab:help RR_ThomasParallel">RR_ThomasParallel</a> on a random tridiagonal matrix.
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RR_ThomasTest, RR_ThomasTTTest, RR_CirculantTest.

disp('Now testing RR_ThomasParallel on a random tridiagonal matrix.')
disp('First, start up matlab pool...'), tic, matlabpool open, toc, p=matlabpool('size');

n=9;         % SET UP AND CHECK A SMALL PROBLEM
a=randn(n,1); b=randn(n,1); c=randn(n,1); g=randn(n,1); a(1)=0; c(n)=0; 
A=diag(a(2:n),-1)+diag(b(1:n),0)+diag(c(1:n-1),1);
disp(sprintf('\nNow checking RR_ThomasParallel using %d threads, aka "labs", taking n= %d',p,n))
tic; [x]=RR_ThomasParallel(a,b,c,g,n,p); toc; A*x, g, error=norm(A*x-g)
disp(sprintf('\nNow checking the equivalent Thomas algorithm')) 
tic; [x]=Thomas(a,b,c,g,n); toc; error=norm(A*x-g)

n=1000000;  % SET UP AND TIME A BIG PROBLEM
a=randn(n,1); b=randn(n,1); c=randn(n,1); g=randn(n,1); a(1)=0; c(n)=0; 
disp(sprintf('\nNow timing RR_ThomasParallel using %d threads taking n= %4.2e',p,n))
tic; [x]=RR_ThomasParallel(a,b,c,g,n,p); toc;
disp(sprintf('\nNow timing the equivalent Thomas algorithm')) 
tic; [x]=Thomas(a,b,c,g,n); toc;

disp(sprintf('\nNow disabling the %d threads',p))
tic; matlabpool close; toc, disp(' ')

% end script RR_ThomasParallelTest
