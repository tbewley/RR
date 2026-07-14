
function [pinv_times_d,d]=RR_pinv_int(A)
[Q,D,R]=RR_QDRmigs(A); [B_cof,d]=RR_Cramers_Rule_int(Q'*Q*R')
pinv_times_d = R'*B_cof*Q' 
end

function [A_cof,det_A,A_inv]=RR_Cramers_Rule_int(A)
is_int=(A==round(A)); [m,n]=size(A); 
if ~prod(is_int(:)), error('this routine assumes that A is integer!'), end
if m~=n,             error('need A to be square to compute inverse!'), end
g=RR_gcd_vec(A), A=A/g;  % factor out GCD to make calculation easier
det_A=round(det(A));
if det_A==0,    error('need A to be nonsingular to compute inverse!'), end
for i=1:m, for j=1:n
   A_cof(j,i)=(-1)^(i+j)*det(A([1:i-1,i+1:m],[1:j-1,j+1:n]));
end, end, A_cof=round(A_cof);
det_A=det_A*g;           % incorporate GCD that we previously factored out
if nargout==3, A_inv=A_cof/det_A; end  % this calculates inverse, if asked
end