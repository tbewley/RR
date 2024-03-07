function tfn=RC_TFnorm(A,B,C,D,p,MODE)
% function tfn=RC_TFnorm(A,B,C,[D],[p],[MODE])
% Compute the p norm of a transfer function for p='2' (default) or p='inf'
% and for MODE='CT' (default) or MODE='DT'.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 20.2.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help RC_TFnormTest">RC_TFnormTest</a>.

if nargin<6, MODE='CT'; end, if nargin<5, p='2'; end
[n,ni]=size(B); [no,n]=size(C); if nargin<4, D=zeros(no,ni); end
if p=='2', if (MODE=='CT' & norm(D)~=0), tfn=inf;
           else, PP=RC_CtrbGramian(A,B,MODE); tfn=sqrt(sum(diag(C*PP*C'+D'*D))); end
else, P.A=A; P.B=B; P.C=C; P.D=D; P.MODE=MODE; P.n=n; P.ni=ni; P.no=no;
  if MODE=='CT', P.gmin=max(norm(C*Inv(-A)*B+D),norm(D));
            [x1,x2]=FindRootBracket(log10(P.gmin),log10(10*P.gmin),@CheckHamiltonian,P);
            tfn=10^Bisection(x1,x2,@CheckHamiltonian,1e-6,0,P);
  else,          P.gmin=max(norm(C*Inv(eye(P.n)-A)*B+D),norm(C*Inv(-eye(P.n)-A)*B+D));
            [x1,x2]=FindRootBracket(log10(P.gmin),log10(10*P.gmin),@CheckHamiltonian,P);
            tfn=10^Bisection(x1,x2,@CheckHamiltonian,1e-6,0,P); end
end
end % function RC_TFnorm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f=CheckHamiltonian(x,verbose,P)
% Taking gamma=10^x, return f=-1 if the Riccati eqn has a stable solution, and f=1 if not.
gam=10^x; if (gam<=P.gmin*1.0000001), f=1; else, A=P.A; B=P.B; C=P.C; D=P.D; 
  R1=gam*eye(P.ni)-D'*D/gam; R2=gam*eye(P.no)-D*D'/gam; At=A+B*(R1\D')*C/gam; f=-1;
  if P.MODE=='CT', lam=RC_Eig([At B*(R1\B'); -C'*(R2\C) -At'],'r');
                   for i=1:P.n*2, if abs(real(lam(i)))<1e-5, f=1; return, end, end
  else,            I=eye(P.n); Z=zeros(P.n);
                   lam=builtin('eig',[At Z; -C'*(R2\C) I],[I -B*(R1\B'); Z At']);
                   for i=1:P.n*2, if abs(abs(lam(i))-1)<1e-6, f=1; return, end, end
end, end
end % function CheckHamiltonian