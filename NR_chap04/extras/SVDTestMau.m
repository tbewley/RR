% Test script for SVD.m                              % Numerical Renaissance Codebase 1.0
clear; % m=30; n=28; A=randn(m,n)+1*sqrt(-1)*randn(m,n); % A=A*A';

m = 50;
N = 10;
nn = 10 : 10 : m;
svd_error = zeros(N*length(nn), 2);
k = 1;
for j = nn
  n = j
  for i = 1 : N
    A = randn(m,n);
    [U,S,V] = svd(A);

    S = zeros(m, n);
    ind = 1 : m + 1 : m*n;
    S(ind) = 1e6*randn(min(n,m),1);
    B = U * S * V';

    [St,Ut,Vt] = SVDTom(B);
    [Um,Sm,Vm] = svd(B);

    svd_error(k, :) = [norm(B-Ut*St*Vt') norm(B-Um*Sm*Vm')];
    k = k + 1;
  end
end

mean(svd_error)
std(svd_error)


% [S,U,V,r]=SVD(A); diag(S), r, svd_error=norm(A-U*S*V')