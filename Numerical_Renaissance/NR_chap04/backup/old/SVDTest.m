% Test script for SVD.m                              % Numerical Renaissance Codebase 1.0
clear; m=30; n=28; A=randn(m,n)+sqrt(-1)*randn(m,n); [S,U,V,r]=SVD(A), eSVD=norm(A-U*S*V')
