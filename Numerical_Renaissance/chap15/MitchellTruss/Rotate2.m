function [X] = Rotate2(X,c,s,i,k,which,p,q)          
% Apply a Givens rotation matrix [G(i,k,c,s)]^H to the matrix X. 
if which=='pre ' | which=='both'
  X([i k],p:q)=[conj(c)*X(i,p:q)-conj(s)*X(k,p:q); s*X(i,p:q)+c*X(k,p:q)];   % Eqn (1.12a)
end; if which=='post' | which=='both'                           
  X(p:q,[i k])=[c*X(p:q,i)-s*X(p:q,k), conj(s)*X(p:q,i)+conj(c)*X(p:q,k)];   % Eqn (1.12b)
end
end % function Rotate2
