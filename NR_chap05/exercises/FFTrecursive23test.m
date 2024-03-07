% script FFTrecursive23test
% Test FFTrecursive.m with random u.
% Numerical Renaissance Codebase 1.0, NRchap5; see text for copyleft info.

N=36; u=rand(N,1); [uhat]=FFTrecursive23(u,N,-1); [u1]=FFTrecursive23(uhat,N,1)/N;
original=u', transformed=uhat', transformed_back=real(u1'), error=norm(u-u1)

% end script FFTrecursive23test