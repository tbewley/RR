function X=RC_DAREevolving(F,S,Q)
% function X=RC_DAREevolving(F,S,Q)
% Finds the X that satisfies X = F' X (I+ S X)^{-1} F + Q, with Q>=0, S>=0, and |F|<>0. 
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

n=length(Q); C=-inv(F')*Q; D=inv(F'); A=F+S*inv(F')*Q; B=-S*inv(F'); X=eye(n);
for iter=1:200; X=RC_GaussPP(D-X*B,X*A-C,n); end
end % function RC_DAREevolving.m
