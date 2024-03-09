% Test script for Bidiagonalization.m                % Numerical Renaissance Codebase 1.0
clear; m=5; n=7; A=randn(m,n)+1*sqrt(-1)*randn(m,n), [B,U,V]=Bidiagonalization(A,m,n),
Bidiagonalization_error=norm(A-U*B*V')
