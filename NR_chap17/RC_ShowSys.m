function RC_ShowSys(A,B,C,D)
% function RC_ShowSys(A,B,C,[D])
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 20.1
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help RC_ShowSysTest">RC_ShowSysTest</a>.

[n,n1]=size(A); [n2,ni]=size(B); % First, check inputs and create B, C, D as needed.
if nargin==2; if n2==n, no=1; n3=n; C=zeros(no,n); D=zeros(no,ni);
else no=n2; n2=n; n3=n; ni=1; C=B; B=zeros(n,ni); end, else, [no,n3]=size(C); end
if nargin<4, D=zeros(no,ni); no1=no; ni1=ni; else, [no1,ni1]=size(D); end
if (n~=n1 | n1~=n2 | n2~=n3 | ni~=ni1 | no~=no1 ), disp('Invalid input.'), return, end
m=max(8,floor(log10(max(max([A B; C D]))))+5); F=sprintf(' %% %d.%df',m,9);
for i=1:n, t='';
  for j=1:n,  s=sprintf(F,A(i,j)); t=strcat(t,s(1:m)); end, t=strcat(t,' |');
  for j=1:ni, s=sprintf(F,B(i,j)); t=strcat(t,s(1:m)); end, disp(t)
end, t=''; for i=1:m*n+3+m*ni, t=strcat(t,'-'); end, disp(t)
for i=1:no, t='';
  for j=1:n,  s=sprintf(F,C(i,j)); t=strcat(t,s(1:m)); end, t=strcat(t,' |');
  for j=1:ni, s=sprintf(F,D(i,j)); t=strcat(t,s(1:m)); end, disp(t)
end  
end % function RC_ShowSys
