function x=RC_TFnorm(A,B,C,p,MODE)
% function x=RC_TFnorm(A,B,C,[p],[MODE])
% Compute the p norm of a transfer function for p='2' (default) or p='inf',
% and for MODE='CT' (default) or MODE='DT'.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 20.2.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help RC_TFnormTest">RC_TFnormTest</a>.

if nargin<5, MODE='CT'; end, if nargin<4, p='2'; end
if p=='2', P=RC_CtrbGrammian(A,B,MODE); x=sqrt(sum(diag(C*P*C')));
else,   P.n=length(A); P.A=A; P.B=B; P.C=C; P.S=B*B'; P.Q=C'*C; P.MODE=MODE;
  if MODE=='CT', 
    [x1,x2]=FindRootBracket(0,0.1,@CheckHamiltonian,P);
    x=10^Bisection(x1,x2,@CheckHamiltonian,1e-6,0,P);
  else, P.Ai=Inv(P.A'); P.ImAi=Inv(eye(P.n)-P.A);
    [x1,x2]=FindRootBracket(0,0.1,@CheckHamiltonian,P);
    x=10^Bisection(x1,x2,@CheckHamiltonian,1e-6,0,P); end
end
end % function RC_TFnorm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f=CheckHamiltonian(x,verbose,P)
% Taking gamma=10^x, returns f=-1 if the Riccati eqn has a stable solution, and f=1 if not.
gamma=10^x;
if P.MODE=='CT'
  lambda=RC_Eig([P.A P.S/gamma; -P.Q/gamma -P.A'],'r');
  f=-1; for i=1:P.n*2, if abs(real(lambda(i)))<1e-5, f=1; return, end, end
else
  lambda=RC_Eig([P.A-P.S*P.Ai*P.Q/gamma^2 P.S*P.Ai/gamma; -P.Ai*P.Q/gamma P.Ai],'r');
  f=-1; inside=0; for i=1:P.n*2
    if abs(abs(lambda(i))-1)<1e-6, f=1; return
    else, if abs(lambda(i))<1, inside=inside+1; end, end
  end, if (inside~=P.n | norm(P.C*P.ImAi*P.B,Inf)>=gamma), f=1; end
end
end % function CheckHamiltonian  