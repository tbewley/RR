function [p] = RC_Lagrange(x,x_data,y_data)
% Computes the RC_Lagrange polynomial p(x) that passes through the given
% data {x_data,y_data}.
n=size(x_data,1);
p=0;
for k=1:n;                  % For each data point {x_data(k),y_data(k)},
   L=1;                     % compute L_k,                
   for i=1:k-1;  L=L*(x-x_data(i))/(x_data(k)-x_data(i)); end   
   for i=k+1:n;  L=L*(x-x_data(i))/(x_data(k)-x_data(i)); end
   p = p + y_data(k) * L;   % then add L_k's contribution to p(x).
end
% end RC_Lagrange.m
