function [b,a]=RC_SS2TF(A,B,C,D)
% function [b,a]=RC_SS2TF(A,B,C,[D])
% Derive the transfer function form corresponding to a MIMO state-space form using the
% resolvent algorithm, for a system with ni inputs, no outputs, and n states. a is 1 x n.
% For SISO and SIMO systems, b is no x (n+1), consistent with Matlab's ss2tf.
% For MISO and MIMO systems, b is no x ni x (n+1).  The a and b coefficients
% are enumerated in the opposite order here than in the textbook derivation.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 20.1.5.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help RC_SS2TFTest">RC_SS2TFTest</a>.

n=size(A,1); ni=size(B,2); no=size(C,1); if nargin<4, D=zeros(no,ni); end
S(:,:,1)=zeros(n); a(1,1)=1; b(:,:,1)=D;
for i=2:n+1;
  S(:,:,i)=S(:,:,i-1)*A+a(i-1)*eye(n); a(1,i)=-trace(S(:,:,i)*A)/(i-1);   % (20.35a)
  b(:,:,i)=(C*S(:,:,i)*B+a(1,i)*D);                                       % (20.34)
end, if ni==1, b=reshape(b,no,n+1); end
end % function RC_SS2TF