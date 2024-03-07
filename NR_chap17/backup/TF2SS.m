xfunction [A,B,C,D]=RC_TF2SS(b,a,FORM)
% function [A,B,C,D]=RC_TF2SS(b,a,[FORM])
% Convert a SISO, SIMO, or MISO transfer function to a canonical state-space form.
% SIMO is handled with controller canonical form, MISO is handled with observer canonical
% form, and SISO is handled with the form specified in the input list.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Sections 20.3.1 and 20.3.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help RC_TF2SSTest">RC_TF2SSTest</a>.

b=b/a(1); a=a/a(1); p=size(a,2); n=p-1; if nargin<3, form='Controller'; end, s=size(b);
if size(s,1)==2                         % Standardize inputs for the various cases.
  if (s(1)>1), FORM='Controller'; end   % SIMO case.
if size(s,2)==3
  if s(2)==1, b=reshape(b,s(1),s(3));   % Restructure b for SISO case if necessary.
  elseif s(1)==1, FORM='Observer'; end  % MISO case.
  else 
  end
end
m=size(b,2); b=[zeros(1,p-m) b];
switch FORM
  case 'Controller'
    A=[-a(2:p); eye(n-1,n)]; B=eye(n,1); C=b(:,2:p)-b(:,1)*a(2:p); D=b(:,1);
  case 'Reachability'
    A=[[zeros(1,n-1); eye(n-1)] -a(p:-1:2)'];
    m=RC_TF2Markov(b,a); B=eye(n,1); C=m(2:p)'; D=m(1);
  case 'DTControllability'
    A=[-a(2:p)' eye(n,n-1)]; B=-a(2:p)'; D=b(1);
    R=Hankel(a(2:p),zeros(1,n)); R=-inv(R); C=( b(2:p)-a(2:p)*b(1) )*R;
  case 'Observer'
    A=[-a(2:p)' eye(n,n-1)]; B=b(2:p)'-a(2:p)'*b(1); C=eye(1,n); D=b(:,1);
  case 'Observability'
    A=[zeros(n-1,1) eye(n-1); -a(p:-1:2)];
    m=RC_TF2Markov(b,a); B=m(2:p); C=eye(1,n); D=m(1);
  case 'DTConstructibility'
    A=[-a(2:p); eye(n-1,n)]; C=-a(2:p); D=b(1);
    R=Hankel(a(2:p),zeros(1,n)); R=-R; B=inv(R)*( b(2:p)'-a(2:p)'*b(1) );
end
end % function RC_TF2SS