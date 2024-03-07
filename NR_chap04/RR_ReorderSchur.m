function [U,T]=RC_ReorderSchur(U,T,type,e)
% function [U,T]=RC_ReorderSchur(U,T,type,e)
% This function reorders a RC_Schur decomposition such that the stable eigenvalues appear
% in the first n columns and the unstable eigenvalues appear in the last n columns.  
% See <a href="matlab:RCweb">>Numerical Renaissance: simulation, optimization, & control</a>, Section 4.5.5.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

n=length(U); g=1; p1=n; p2=n; p3=n; % initialize n, g, and 3 placeholders
switch type(1)
  case 'l'    % type='lhp' for continuous-time systems (first LHP modes, then RHP)
    while p1>0 % (start from bottom right and work towards upper left)
      while p3>=1 & real(T(p3,p3))>0;  p3=p3-1; end;  p2=p3; if p3==1, break, end
      while p2>=1 & real(T(p2,p2))<0;  p2=p2-1; end;  p1=p2; if p2==0, break, end
      while p1>=1 & real(T(p1,p1))>0;  p1=p1-1; end;  [U,T]=BlockSwap(U,T,p1,p2,p3,g);
    end
  case 'u'    % type='unitdisk' for discrete-time systems (inside, then outside unit disk)
    while p1>0
      while p3>=1 & abs(T(p3,p3))>1;   p3=p3-1; end;  p2=p3; if p3==1, break, end
      while p2>=1 & abs(T(p2,p2))<1;   p2=p2-1; end;  p1=p2; if p2==0, break, end
      while p1>=1 & abs(T(p1,p1))>1;   p1=p1-1; end;  [U,T]=BlockSwap(U,T,p1,p2,p3,g);
    end
  case 'a'    % type = 'absolute', to order by the absolute value of the real part
    for i=n-1:-1:1, a=i+1; b=n;      % (see RC_InsertionSort.m for details)
      while a<b-1; c=a+floor((b-a)/2);
        if abs(real(T(c,c))+e)<abs(real(T(i,i))+e), a=c+1; else, b=c-1; end, end
      while a<=b;                     
        if abs(real(T(i,i))+e)<abs(real(T(b,b))+e), b=b-1; else, a=a+2; end, end
      if b>i, [U,T]=BlockSwap(U,T,i-1,i,b,g); end % Insert record i at the correct point.
    end
end
end % function RC_ReorderSchur
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [U,T]=BlockSwap(U,T,p1,p2,p3,g)
T11=T(p1+1:p2,p1+1:p2); T12=T(p1+1:p2,p2+1:p3); T22=T(p2+1:p3,p2+1:p3); m=p2-p1; p=p3-p2;
X=RC_Sylvester(T11,T22,T12,g,m,p);  [R,Q]=QRHouseholder([-X;g*eye(size(X,2),size(X,2))]);
if m>1                                                     % make new T22 upper triangular
  Q11=Q(1:m,1:p); Q12=Q(1:m,p+1:p+m); Q22=Q(m+1:m+p,p+1:p+m); R11=R(1:p,1:p);
  [V,temp]=RC_Schur(Q12'*T11*(Q12-Q11*R11*Q22/g));  Q(:,p+1:p+m)=Q(:,p+1:p+m)*V;                             
end                                                        % Q=Q*[eye_(pxp) 0; 0 V_(mxm)]
T(:,p1+1:p3)=T(:,p1+1:p3)*Q; T(p1+1:p3,:)=Q'*T(p1+1:p3,:); % P=diag[eye(p1),Q,eye(n-p3)]
U(:,p1+1:p3)=U(:,p1+1:p3)*Q;                               % T=P'*T*P and U=U*P
end % function BlockSwap
