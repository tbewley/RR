function [pinv_times_d,d]=RR_pinv_int(A)
% This code determines integer pinv_times_d and d such that pinv(A)=pinv_times_d/d
[Q,D,R,r,L,Pi]=RR_QDRmigs_pivoted(A);         % algorithm from Part 1 of this work
[B_adj,d]=RR_Cramers_Rule_int(Q'*A*Pi*R');
pinv_times_d = round(Pi*R'*B_adj*Q');                 % the rounding stuff is needed
g=round(RR_gcd_vec(pinv_times_d)), g=round(gcd(g,d)); % only because Matlab does
pinv_times_d=round(pinv_times_d/g); d=round(d/g);     % intermediate calcs as real
end

function [B_adj,d]=RR_Cramers_Rule_int(B)
% This code determines integer B_adj and det_B such that B_inv=B_adj/d
is_int=(B==round(B)); [m,n]=size(B);
if ~prod(is_int(:)), error('this routine assumes that B is integer!'), end
if m~=n, error('need B to be square to compute inverse!'), end
g=RR_gcd_vec(B), B=B/g; % factor out  GCD of B to make calcs easier
d=round(det(B))*g;      % incorporate GCD of B into d
if d==0, error('need B to be nonsingular to compute inverse!'), end
for i=1:m, for j=1:n
  B_adj(j,i)=round((-1)^(i+j)*det(B([1:i-1,i+1:m],[1:j-1,j+1:n])));
end, end
end

% Test the above code with something like:
% A=[-3 3 1; 4 1 -3; 4 -2 1; -2 -2 2; -2 2 -3]
% A=[1 2 2;-2 2 2; 1 -2 -2; -2 2 -2; 2 1 -2]
% A=[1 2 2;-2 2 2; 1 -2 -1; -2 2 -2; 2 1 -2]
% A=[-1 -1 0; -1 -1 1; -1 -1 -1; -1 1 -1; -1 0 0; 0 1 0; -1 0 -1]
% A=[0 0 2 -2; -2 -2 -1 -2; -1 0 1 2; -2 0 1 -2]
% A=[-6 4 2 -3 -3 4 -3 3 -6 5;  1 1 -6 4 -4 1 -5 3 -5 -4; ...
%     -1 3 -6 -5 1 -3 -2 -1 2 3; -5 -3 6 -2 -1 6 1 -5 5 -5;
%     -6 -6 -6 -6 -4 -3 0 6 5 -1];

% [pinv_times_d,d]=RR_pinv_int(A), pinv_times_d/d, pinv(A)

