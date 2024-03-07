function [U,T]=RC_SchurSort(U,T)                        % Numerical Renaissance Codebase 1.0
% This function reorders a RC_Schur decomposition such that the LHP eigenvalues appear in the
% first N columns and the RHP eigenvalues appear in the last N columns.  By Gabe Graham.

N=length(A); g=1; p1=N; p2=N; p3=N;  % initialize N, g, and 3 placeholders

while p1>0  % start from bottom right and work towards upper left
    while real(T(p3,p3))>0;          p3=p3-1; end;  p2=p3; 
    while p2>=1 & real(T(p2,p2))<0;  p2=p2-1; end;  p1=p2;
    if p2==0, break, end
    while p1>=0 & real(T(p1,p1))>0;  p1=p1-1; end;
    if p1==0, break, end

    T11=T(p1+1:p2,p1+1:p2);       % find T11, T12, T22, X, Q, & R
    T12=T(p1+1:p2,p2+1:p3);
    T22=T(p2+1:p3,p2+1:p3);
    X=RC_Sylvester(T11,T12,T22,g);   % T12 T22 now Swapped!!!???
    [Q,R]=QRHouseholder([-X;g*eye(size(X,2),size(X,2))]);
    
    % if length(T11)>1, use one more RC_Schur decomposition to make new T22 upper triangular
    if length(T11)>1
        [m,n]=size(X);
        Q11=Q(1:m,1:n); Q12=Q(1:m,n+1:n+m); Q22=Q(m+1:n+m,n+1:n+m);  R11=R(1:n,1:n);
        [u,t]=schur(Q12'*T11*(Q12-Q11*R11*Q22/g),'complex');
        Q=Q*[eye(n) zeros(n,m); zeros(m,n) u];  % (clean this up - this is inefficient)
    end
    % matrix P to act on T and U  (clean this up - this is inefficient)
    P=[eye(p1)           zeros(p1,p3-p1-1)     zeros(p1,N-p3+1);...
       zeros(p3-p1-1,p1) Q                     zeros(p3-p1-1,N-p3+1);...
       zeros(N-p3+1,p1)  zeros(N-p3+1,p3-p1-1) eye(N-p3+1)];
    T=P'*T*P; % permute T
    U=U*P;    % permute U
end
end % function RC_SchurSort