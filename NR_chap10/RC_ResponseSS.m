function RC_ResponseSS(A,B,C,D,w,g,Input)
% function RC_ResponseSS(A,B,C,D,w,g,Input)
% Using CN, plot the P components of the response y_1,...,y_P (in each of the P rows of
% subplots) of a MIMO LTI system.  If w=-1, the input u is specified in Input; otherwise,
% the input u is zero in all but the m'th component (in each of the M columns of subplots),
% and u_m is an impulse for w=0, step for w=1, or polynomial t^(w-1) for w>1.
% The derived type g groups together convenient plotting parameters: g.T is the interval
% over which the response is plotted, and {g.styleu,g.styley} are the linestyles used.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 10.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap10">Chapter 10</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% Depends on <a href="matlab:help RC_Gauss">RC_Gauss</a>, <a href="matlab:help RC_GaussLU">RC_GaussLU</a>.  Verify with: <a href="matlab:help RC_ResponseSSTest">RC_ResponseSSTest</a>.

N=length(A); M=size(B,2); P=size(C,1); x=zeros(N,1); K=1000; h=g.T/K; t=[0:K]*h;
if w==0; u(1,:)=[2/h, zeros(1,K)]; elseif w>0, u(1,:)=t.^(w-1);
else,    M=1; for k=1:K+1; u(:,k)=Input(t(k)); end, end
for m=1:M
  Ap=eye(N)+A*h/2; if M>1; Bs=B(:,m)*h/2; Ds=D(:,m); else; Bs=B*h/2; Ds=D; end
  Am=eye(N)-A*h/2; [x(:,2),Amod]=RC_Gauss(Am,Ap*x(:,1)+Bs*(u(:,2)+u(:,1)),N);
  for k=3:K+1, [x(:,k)]=RC_GaussLU(Amod,Ap*x(:,k-1)+Bs*(u(:,k)+u(:,k-1)),N); end
  for p=1:P, subplot(P,M,m+(p-1)*M), hold on
     plot(t,C(p,:)*x(:,[1:K+1])+Ds(p,:)*u(:,[1:K+1]),g.styley,t,0*t,'k:'), axis tight, end
  if M*P==1, plot(t(2:end),u(1,2:end),g.styleu), end
end
end % function RC_ResponseSS
