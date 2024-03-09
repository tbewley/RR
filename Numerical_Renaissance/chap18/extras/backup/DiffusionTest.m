function SparseRotate    % by Thomas Bewley                     
%%%%%%%%%%%%%%%%% begin user input %%%%%%%%%%%%%%%% 
T=3.145; G.h=0.012; G.dx=.024; G.d=2; G.thresh=0.001; G.max=3000;
%%%%%%%%%%%%%%%% end of user input %%%%%%%%%%%%%%%% 
t=0; G.Y=eye(G.d,'int16'); [D]=Initialize_D(G); h1=round(G.dx/G.h);
[D]=Modify_pointset(D,G); [D]=Modify_pointset(D,G); Rotate_Plot(D,G), title(sprintf('Time = %0.5g',t)); pause;
for timestep=1:T/G.h, t=t+G.h; if mod(timestep,h1)==0, [D]=Modify_pointset(D,G); end
  % ------------------------------------ RK4 Time March -------------------------------
  % K=RHS_P(D,D.P(1:D.n)               ,G); Pt (2:D.n,1)=D.P(2:D.n)+G.h*K(2:D.n)/6;
  % K=RHS_P(D,D.P(1:D.n)+G.h*K(1:D.n)/2,G); Pt (2:D.n,1)=Pt (2:D.n)+G.h*K(2:D.n)/3;
  % K=RHS_P(D,D.P(1:D.n)+G.h*K(1:D.n)/2,G); Pt (2:D.n,1)=Pt (2:D.n)+G.h*K(2:D.n)/3;
  % K=RHS_P(D,D.P(1:D.n)+G.h*K(1:D.n)  ,G); D.P(2:D.n,1)=Pt (2:D.n)+G.h*K(2:D.n)/6;
  % ------------------------------------ EE Time March --------------------------------
  K=RHS_P(D,D.P(1:D.n),G); D.P(2:D.n,1)=D.P(2:D.n)+G.h*K(2:D.n);                
  % ------------------------- (keep one of the above 2 sections) ----------------------
  if mod(timestep,h1)==0, Rotate_Plot(D,G), title(sprintf('Time = %0.5g',t)), end
end, Rotate_Plot(D,G), title(sprintf('Time = %0.5g',t))
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [D]=Initialize_D(G)
D.P=zeros(G.max,1);   D.j=zeros(G.max,G.d,'int16'); D.k=ones(G.max,G.d,'int16');
D.v=zeros(G.max,G.d); D.i=D.k; D.w=D.v; D.u=D.v; D.f=D.v; l=1;
% --------------------------------------- 2D Cone -------------------------------------
for i=round(-.4/G.dx):round(.4/G.dx), for j=round(-.8/G.dx):round(-.1/G.dx)    
  l=l+1; D.j(l,1)=i; D.j(l,2)=j; D.P(l)=max(0,1-sqrt((i*G.dx)^2+(j*G.dx+.45)^2)/0.35);
end, end
% --------------------------------------- 2D Box --------------------------------------
for i=round(-.25/G.dx):round(.25/G.dx), for j=round(.1/G.dx):round(.6/G.dx)
  l=l+1; D.j(l,1)=i; D.j(l,2)=j; D.P(l)=1;
end, end
% --------------------- (keep one or both of the above 2 sections) --------------------
D.m=l; D.n=D.m; [D]=Initialize_vuwik(D,G,2);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [D]=Initialize_vuwik(D,G,b);
for l=b:D.n
  % ----------------------------- 2D Solid Body Rotation ------------------------------
  D.v(l,1)=2.*double(D.j(l,2))*G.dx; D.v(l,2)=-2.*double(D.j(l,1))*G.dx;
  % ----------------------------- 2D Northwest Convection -----------------------------
  %  D.v(l,1)=0; D.v(l,2)=1;
  % ------------------------- (keep one of the above 2 sections) ----------------------
  for d=1:G.d, D.w(l,d)=max(D.v(l,d),0); D.u(l,d)=min(D.v(l,d),0); end  % Init u and w.
end
D.i(b:D.n,:)=ones(D.n-b+1,G.d,'int16'); D.k(b:D.n,:)=ones(D.n-b+1,G.d,'int16'); 
for l=D.n:-1:b,                                         % Search list for neighbors to
  for t=2:l-1, diff=(D.j(l,:)-D.j(t,:));                % init i and k.  For large D.n,
    if sum(~diff)==G.d-1; [Y,d] = max(abs(diff));       % THIS IS THE EXPENSIVE BIT!
      if     D.j(l,d)==D.j(t,d)+1, D.i(l,d)=t; D.k(t,d)=l; % Due to careful programming
	  elseif D.j(t,d)==D.j(l,d)+1, D.k(l,d)=t; D.i(t,d)=l; % of Modify_pointset, we do
  end, end, end                                            % not call it very often...
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Rotate_Plot(D,G), figure(1);                          % check_connections(D,G)
N=round(2/G.dx+1); M=round((N-1)/2+1); Pfull(1:N,1:N)=1/0; for l=2:D.n, i=D.j(l,1)+M; j=D.j(l,2)+M;
  if i>0 & i<=N & j>0 & j<=N, Pfull(i,j)=D.P(l); end, end
colormap(cool); surf([-1:G.dx:1],[-1:G.dx:1],Pfull); axis([-1 1 -1 1 0 1.001]); % view(0,90);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [D]=Modify_pointset(D,G)               % Shift dataset to relevant gridpoints.
D.m=D.n; l=D.m;
while D.P(l)<G.thresh; l=l-1; D.m=D.m-1; end, l=l-1;  % Find last big element.
while l>1, if D.P(l)<G.thresh,     % We now move all big elements to the range 2:D.m,
  for d=1:G.d;                     % and small elements to the range D.m+1:D.n.
    if     D.i(l,d)==D.m, D.i(l,d)=D.i(D.m,d); D.i(D.m,d)=l;  % First, fix pointers...
    elseif D.i(D.m,d)==l, D.i(D.m,d)=D.i(l,d); D.i(l,d)=D.m;
    else   [D.i(l,d),D.i(D.m,d)]=Swap(D.i(l,d),D.i(D.m,d));  end
    if     D.k(l,d)==D.m, D.k(l,d)=D.k(D.m,d); D.k(D.m,d)=l;
    elseif D.k(D.m,d)==l, D.k(D.m,d)=D.k(l,d); D.k(l,d)=D.m;
    else   [D.k(l,d),D.k(D.m,d)]=Swap(D.k(l,d),D.k(D.m,d));  end
    D.i(D.k(l,d),d)=l; D.i(D.k(D.m,d),d)=D.m;     
	D.k(D.i(l,d),d)=l; D.k(D.i(D.m,d),d)=D.m;
  end                                             
  [D.P(l),  D.P(D.m)  ]=Swap(D.P(l),  D.P(D.m));    % ... then swap elements l and D.m.
  [D.j(l,:),D.j(D.m,:)]=Swap(D.j(l,:),D.j(D.m,:)); 
  [D.v(l,:),D.v(D.m,:)]=Swap(D.v(l,:),D.v(D.m,:)); 
  [D.f(l,:),D.f(D.m,:)]=Swap(D.f(l,:),D.f(D.m,:));
  [D.u(l,:),D.u(D.m,:)]=Swap(D.u(l,:),D.u(D.m,:));
  [D.w(l,:),D.w(D.m,:)]=Swap(D.w(l,:),D.w(D.m,:));
  D.m=D.m-1;
end, l=l-1; end
D.f(D.m+1:D.n,1)=zeros(D.n-D.m,1);  % Next, identify the neighbors to the big elements,
for l=2:D.m, for d=1:G.d            % and create entries for them if necessary.
  if D.i(l,d)==1, D=Create(D,G,D.j(l,:)-G.Y(d,:)); else, D.f(D.i(l,d),1)=1; end
  if D.k(l,d)==1, D=Create(D,G,D.j(l,:)+G.Y(d,:)); else, D.f(D.k(l,d),1)=1; end
  for e=d:G.d,                      % (the following computes the corner entries)
    if D.i(D.i(l,e),d)==1, D=Create(D,G,D.j(l,:)-G.Y(d,:)-G.Y(e,:));
	  else, D.f(D.i(D.i(l,e),d),1)=1; end
    if D.i(D.k(l,e),d)==1, D=Create(D,G,D.j(l,:)-G.Y(d,:)+G.Y(e,:));
	  else, D.f(D.i(D.k(l,e),d),1)=1; end
    if D.k(D.i(l,e),d)==1, D=Create(D,G,D.j(l,:)+G.Y(d,:)-G.Y(e,:));
	  else, D.f(D.k(D.i(l,e),d),1)=1; end
    if D.k(D.k(l,e),d)==1, D=Create(D,G,D.j(l,:)+G.Y(d,:)+G.Y(e,:));
	  else, D.f(D.k(D.k(l,e),d),1)=1; end
  end
end, end
l=D.m+1; while l<=D.n, if D.f(l,1)~=1,   % Remove small elements which do not neighbor
  for d=1:G.d;                           % the big elements.  First, fix pointers...
    D.i(D.k(l,d),d)=1; if l<D.n, D.i(D.k(D.n,d),d)=l; end
    D.k(D.i(l,d),d)=1; if l<D.n, D.k(D.i(D.n,d),d)=l; end
    if D.j(D.n,:)-G.Y(d,:)==D.j(l,:), D.i(l,d)=1; else, D.i(l,d)=D.i(D.n,d); end
    if D.j(D.n,:)+G.Y(d,:)==D.j(l,:), D.k(l,d)=1; else, D.k(l,d)=D.k(D.n,d); end
  end                                            
  D.j(l,:)=D.j(D.n,:); D.P(l)=D.P(D.n); D.v(l,:)=D.v(D.n,:);     % then replace element
  D.u(l,:)=D.u(D.n,:); D.w(l,:)=D.w(D.n,:); D.f(l,1)=D.f(D.n,1); % l with element D.n.
  D.n=D.n-1;
else, l=l+1; end, end
for l=2:D.n, D.P(l)=max(D.P(l),0); end, D.P(1)=0; D.i(1,1:G.d)=1; D.k(1,1:G.d)=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [b,a]=Swap(a,b); end  % Swap two elements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [D]=Create(D,G,j);  % Create a new element in D
D.n=D.n+1; D.P(D.n)=0;  D.j(D.n,:)=j; [D]=Initialize_vuwik(D,G,D.n); D.f(D.n,1)=1;
end  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [K]=RHS_P(D,P,G)
D.f(1:D.n,1:G.d)=0; P(1)=0; K(1:D.n,1)=0;
% -------------------------------- NONCONSERVATIVE FORM -------------------------------
% for l=2:D.n, for d=1:G.d, K(l,1)=K(l,1)-D.w(D.i(l,d),d)*(P(l)-P(D.i(l,d)))/G.dx ...
%							             -D.u(l,d)*(P(D.k(l,d))-P(l))/G.dx;    end, end
% --------------------------------- CONSERVATIVE FORM ---------------------------------                                         
for l=2:D.n, for d=1:G.d, D.f(l,d)=D.w(l,d)*P(l)+D.u(l,d)*P(D.k(l,d)); end, end
%------------------------- (keep one of the above 2 sections) -------------------------
for d=1:G.d, for l=2:D.n, i=D.i(l,d); if l<=D.m | (i>1 & i<=D.m),
  F=G.h*(P(l)-P(i))/(2*G.dx);      
  for e=1:G.d, if e~=d,
    D.f(l,e)=D.f(l,e)-D.w(l,e)*D.w(i,d)*F; j=D.i(l,e);   % Compute corner transport
    D.f(j,e)=D.f(j,e)-D.u(j,e)*D.w(i,d)*F;               % upwind (CTU) flux terms.
    D.f(i,e)=D.f(i,e)-D.w(i,e)*D.u(i,d)*F; p=D.i(i,e);
    D.f(p,e)=D.f(p,e)-D.u(p,e)*D.u(i,d)*F;
   end, end
  if D.v(i,d)>0, th=(P(i)-P(D.i(i,d)))/(P(l)-P(i));           % Compute second-order
  else,          th=(P(D.k(l,d))-P(l))/(P(l)-P(i)); end,      % correction flux term.
  t=abs(D.v(i,d)); D.f(i,d)=D.f(i,d)+t*(G.dx/G.h-t)*F*MC(th); % Flux: use MC or VL.
end, end, end
for l=2:D.n, for d=1:G.d, K(l,1)=K(l,1)-(D.f(l,d)-D.f(D.i(l,d),d))/G.dx; end, end
end % function RHS_P
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [phi]=MC(th), phi=max(0,min([(1+th)/2 2 2*th]));   end         % Flux limiters
function [phi]=VL(th), phi=min((th+abs(th))/(1+abs(th)),0); end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function check_connections(D,G)
for l=2:D.n, for d=1:G.d
  if D.i(l,d)>1, if D.j(D.i(l,d),:)+G.Y(d,:)~=D.j(l,:), disp 'prob!', pause, end, end
  if D.k(l,d)>1, if D.j(D.k(l,d),:)-G.Y(d,:)~=D.j(l,:), disp 'prob!', pause, end, end
end, end, disp 'checked', end