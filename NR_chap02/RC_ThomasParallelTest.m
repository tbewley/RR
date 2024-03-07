% script <a href="matlab:RC_ThomasParallelTest">RC_ThomasParallelTest</a>
% Test <a href="matlab:help RC_ThomasParallel">RC_ThomasParallel</a> on a random tridiagonal matrix.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_ThomasTest, RC_ThomasTTTest, RC_CirculantTest.

disp('Now testing RC_ThomasParallel on a random tridiagonal matrix.')
disp('First, start up matlab pool...'), tic, matlabpool open, toc, p=matlabpool('size');

n=9;         % SET UP AND CHECK A SMALL PROBLEM
a=randn(n,1); b=randn(n,1); c=randn(n,1); g=randn(n,1); a(1)=0; c(n)=0; 
A=diag(a(2:n),-1)+diag(b(1:n),0)+diag(c(1:n-1),1);
disp(sprintf('\nNow checking RC_ThomasParallel using %d threads, aka "labs", taking n= %d',p,n))
tic; [x]=RC_ThomasParallel(a,b,c,g,n,p); toc; A*x, g, error=norm(A*x-g)
disp(sprintf('\nNow checking the equivalent Thomas algorithm')) 
tic; [x]=Thomas(a,b,c,g,n); toc; error=norm(A*x-g)

n=1000000;  % SET UP AND TIME A BIG PROBLEM
a=randn(n,1); b=randn(n,1); c=randn(n,1); g=randn(n,1); a(1)=0; c(n)=0; 
disp(sprintf('\nNow timing RC_ThomasParallel using %d threads taking n= %4.2e',p,n))
tic; [x]=RC_ThomasParallel(a,b,c,g,n,p); toc;
disp(sprintf('\nNow timing the equivalent Thomas algorithm')) 
tic; [x]=Thomas(a,b,c,g,n); toc;

disp(sprintf('\nNow disabling the %d threads',p))
tic; matlabpool close; toc, disp(' ')

% end script RC_ThomasParallelTest
