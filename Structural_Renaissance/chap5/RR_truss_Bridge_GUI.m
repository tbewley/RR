% script RR_truss_Bridge_GUI
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 5)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, close all
global truss height s load curvature ax
truss="Pennsylvania"; height=0.2; s=8; load=0.5; curvature=0;  % Initial values

fig=uifigure; g=uigridlayout(fig);           % Set up a ui grid for all of the figure elements
g.RowHeight = {'1x',40};                     % Tall upper row, fixed hight lower row
g.ColumnWidth = {'1x','1x','1x','1x','1x'};  % Five equal-width columns
ax = uiaxes(g);                              % Frame into which we will put our plot
ax.Layout.Row=1; ax.Layout.Column=[1 5];     % This is in all 5 columns of row 1 of g
update_truss

% truss choice
dd = uidropdown(g,"ValueChangedFcn",@(src,event)update1(src,event), ...
    "Items",["Warren","Howe","Pratt","Pennsylvania","K1","K2"]);
dd.Layout.Row=2; dd.Layout.Column=1; dd.Value=truss;                         % This is in column 1 of row 2 of g 

% height slider (relative height)
s1 = uislider(g,"ValueChangedFcn",@(src,event)update2(src,event));
s1.Layout.Row=2; s1.Layout.Column=2; s1.Value=height; s1.Limits=[-0.3 0.4];  % This is in column 2 of row 2 of g

% segments slider (sets the number of horizontal segments)
s2 = uislider(g,"ValueChangedFcn",@(src,event)update3(src,event));
s2.Layout.Row=2; s2.Layout.Column=3; s2.Value=s;      s2.Limits=[2 15];      % This is in column 3 of row 2 of g

% load slider (position along the bridge that the point load is applied)
s3 = uislider(g,"ValueChangedFcn",@(src,event)update4(src,event));
s3.Layout.Row=2; s3.Layout.Column=4; s3.Value=load;   s3.Limits=[0.01 0.99]; % This is in column 4 of row 2 of g

% curvature slider (controls curvature of top chord)
s4 = uislider(g,"ValueChangedFcn",@(src,event)update5(src,event));  
s4.Layout.Row=2; s4.Layout.Column=5; s4.Value=curvature; s4.Limits=[0 1];    % This is in column 5 of row 2 of g

function update1(src,event), global truss;     truss    =event.Value; update_truss, end
function update2(src,event), global height;    height   =event.Value; update_truss, end
function update3(src,event), global s;         s        =event.Value; update_truss, end
function update4(src,event), global load;      load     =event.Value; update_truss, end
function update5(src,event), global curvature; curvature=event.Value; update_truss, end

%%%%%%%%%%%%%%%%%%%%%% main part of code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function update_truss
global truss height s load curvature ax

cla(ax), hold on, s=round(s); clear S L;
% Locations of the fixed nodes of the truss (note: normalized units)
S.P=[0; 0]; S.R=[1; 0]; p=1; r=1; 

% Locations of the free nodes of the truss
if strcmp(truss,'Pennsylvania'), sb=s*2; else, sb=s; end
for i=1:sb-1, S.Q(:,i)=[i/sb; 0]; end, q=sb-1;   % free nodes in bottom row

switch truss                                   
    case 'Warren'
        for i=1:s,   S.Q(:,q+i)=[(i-0.5)/s; height*(1-curvature*4*((i-0.5)/s-0.5)^2)]; end, q=q+s; % free nodes in top row
    case {'Howe','Pratt'}
        for i=1:s-1, S.Q(:,q+i)=[i/s; height*(1-curvature*4*(i/s-0.5)^2)]; end, q=q+s-1;     % free nodes in top row
    case 'Pennsylvania'
        for i=1:s-1, S.Q(:,q+i)=[i/s; height*(1-curvature*4*(i/s-0.5)^2)]; end, q=q+s-1;     % free nodes in top row
        S.Q(:,q+1)=[(1/2)/s;   S.Q(2,sb)/2]; q=q+1;
        for i=2:s-1, S.Q(:,q+i-1)=[(i-1/2)/s; min(S.Q(2,sb+i-2),S.Q(2,sb+i-1))/2]; end; q=q+s-2; % free nodes in middle row
        S.Q(:,q+1)=[1-(1/2)/s; S.Q(2,sb)/2]; q=q+1;
    case {'K1','K2'}
        for i=1:s-1, S.Q(:,q+i)=[i/s; height*(1-curvature*4*(i/s-0.5)^2)]; end, q=q+s-1;     % free nodes in top    row
        for i=1:s-1, S.Q(:,q+i)=[i/s; (height/2)*(1-curvature*4*(i/s-0.5)^2)]; end, q=q+s-1; % free nodes in middle row
end
n=q+p+r; Qsize=size(S.Q);

% Connectivity of the truss. This clever idea was developed by Robert Skelton.
% A bit of logic is needed here to define different classes of truss for arbitrary s.
% Each row of C defines the connectivity of a member, and has exactly two entries equal to +1
% (for the puropose of the corresponding analysis, one entry in each row is switched to a -1
%  within the RR_Structure_Analyze code, we need not do that here, which is a bit cumbersome)
switch truss
    case 'Warren'
        m=4*s-1; S.C=zeros(m,q+p+r);
        S.C(1,n-1)=1;   S.C(1,1)=1; j=1;                                 % bottom row to left fixed node
        for i=1:s-2,    S.C(j+i,i)=1; S.C(j+i,i+1)=1;     end, j=j+s-2;  % bottom row
        S.C(j+1,s-1)=1; S.C(j+1,n)=1; j=j+1;                             % bottom row to right fixed node
        for i=1:s-1,    S.C(j+i,s-1+i)=1; S.C(j+i,s+i)=1; end, j=j+s-1;  % top row
        S.C(j+1,n-1)=1; S.C(j+1,s)=1; j=j+1;                             % left diagonal to fixed node
        for i=1:s-1,    S.C(j+2*i-1,s+i-1)=1; S.C(j+2*i-1,i)=1;          % internal diagonals
                        S.C(j+2*i,i)=1; S.C(j+2*i,s+i)=1; end, j=j+2*s-2;  
        S.C(j+1,n-2)=1; S.C(j+1,n)=1; j=j+1;                             % right diagonal to fixed node
    case 'Howe'
        m=4*s-3; if mod(s,2)==1, m=m+1; end, S.C=zeros(m,q+p+r);
        S.C(1,n-1)=1;   S.C(1,1)=1; j=1;                                 % bottom row to left fixed node
        for i=1:s-2,    S.C(j+i,i)=1; S.C(j+i,i+1)=1;     end, j=j+s-2;  % bottom row
        S.C(j+1,s-1)=1; S.C(j+1,n)=1; j=j+1;                             % bottom row to right fixed node
        for i=1:s-2,    S.C(j+i,s-1+i)=1; S.C(j+i,s+i)=1; end, j=j+s-2;  % top row
        S.C(j+1,n-1)=1; S.C(j+1,s)=1; j=j+1;                             % left diagonal to fixed node
        for i=1:s-1,    S.C(j+i,i)=1; S.C(j+i,s-1+i)=1;   end, j=j+s-1;  % internal verticals
        num=ceil((s-2)/2);
        for i=1:num, S.C(j+i,i)=1;   S.C(j+i,s  +i)=1;     end, j=j+num; % up/right diagonals
        for i=1:num, S.C(j+i,s-i)=1; S.C(j+i,2*s-i-2)=1;   end, j=j+num; % up/left  diagonals
        S.C(j+1,n-2)=1; S.C(j+1,n)=1; j=j+1;                             % right diagonal to fixed node
    case 'Pratt'
        m=4*s-3; if mod(s,2)==1, m=m+1; end, S.C=zeros(m,q+p+r);
        S.C(1,n-1)=1;   S.C(1,1)=1; j=1;                                 % bottom row to left fixed node
        for i=1:s-2,    S.C(j+i,i)=1; S.C(j+i,i+1)=1;     end, j=j+s-2;  % bottom row
        S.C(j+1,s-1)=1; S.C(j+1,n)=1; j=j+1;                             % bottom row to right fixed node
        for i=1:s-2,    S.C(j+i,s-1+i)=1; S.C(j+i,s+i)=1; end, j=j+s-2;  % top row
        S.C(j+1,n-1)=1; S.C(j+1,s)=1; j=j+1;                             % left diagonal to fixed node
        for i=1:s-1,    S.C(j+i,i)=1; S.C(j+i,s-1+i)=1;   end, j=j+s-1;  % internal verticals
        num=ceil((s-2)/2);
        for i=1:num, S.C(j+i,i+1)=1; S.C(j+i,s+i-1)=1;     end, j=j+num; % up/left  diagonals
        for i=1:num, S.C(j+i,s-i-1)=1; S.C(j+i,2*s-i-1)=1; end, j=j+num; % up/right diagonals
        S.C(j+1,n-2)=1; S.C(j+1,n)=1; j=j+1;                             % right diagonal to fixed node
    case 'Pennsylvania'
        m=8*s-3, if mod(s,2)==1, m=m+1; end, S.C=zeros(m,q+p+r);
        S.C(1,n-1)=1;    S.C(1,1)=1; j=1;                                   % bottom row to left fixed node
        for i=1:sb-2,    S.C(j+i,i)=1; S.C(j+i,i+1)=1;       end, j=j+sb-2; % bottom row
        S.C(j+1,sb-1)=1; S.C(j+1,n)=1; j=j+1;                               % bottom row to right fixed node
        for i=1:s-2,     S.C(j+i,sb-1+i)=1; S.C(j+i,sb+i)=1; end, j=j+s-2;  % top row
        k=sb+s-2;
        S.C(j+1,n-1)=1;  S.C(j+1,k+1)=1;  S.C(j+2,n  ) =1;  S.C(j+2,k+s)=1; % left/right diagonals to fixed nodes
        S.C(j+3,1  )=1;  S.C(j+3,k+1)=1;  S.C(j+4,sb-1)=1;  S.C(j+4,k+s)=1;
        S.C(j+5,2)  =1;  S.C(j+5,k+1)=1;  S.C(j+6,sb-2)=1;  S.C(j+6,k+s)=1; 
        S.C(j+7,sb) =1;  S.C(j+7,k+1)=1;  S.C(j+8,k)=1;     S.C(j+8,k+s)=1;  j=j+8; 
        for i=1:s-1,     S.C(j+i,2*i)=1; S.C(j+i,sb-1+i)=1;  end, j=j+s-1;  % internal verticals
        num=floor(s/2);
        for i=2:num
            S.C(j+1,2*i-2) =1;  S.C(j+1,k+i)=1; S.C(j+5,sb-2*i+2) =1; S.C(j+5,k+s+1-i)=1; % left/right diagonals
            S.C(j+2,2*i-1) =1;  S.C(j+2,k+i)=1; S.C(j+6,sb-2*i+1)=1;  S.C(j+6,k+s+1-i)=1; % to fixed nodes
            S.C(j+3,2*i)   =1;  S.C(j+3,k+i)=1; S.C(j+7,sb-2*i  )=1;  S.C(j+7,k+s+1-i)=1; 
            S.C(j+4,sb+i-2)=1;  S.C(j+4,k+i)=1; S.C(j+8,k+2-i)   =1;  S.C(j+8,k+s+1-i)=1;
            j=j+8; 
        end  
        if mod(s,2)==1
            S.C(j+1,s-1)      =1; S.C(j+1,k+num+1)=1;
            S.C(j+2,s)        =1; S.C(j+2,k+num+1)=1;
            S.C(j+3,s+1)      =1; S.C(j+3,k+num+1)=1;
            S.C(j+4,2*s+num-1)=1; S.C(j+4,k+num+1)=1;
            S.C(j+5,2*s+num)  =1; S.C(j+5,k+num+1)=1;
            j=j+5;
        end
    case 'K1'
        m=6*s-6; if mod(s,2)==1, m=m+2; end, S.C=zeros(m,q+p+r);
        S.C(1,n-1)=1;   S.C(1,1)=1; j=1;                                   % bottom row to left fixed node
        for i=1:s-2,    S.C(j+i,i)=1; S.C(j+i,i+1)=1;       end, j=j+s-2;  % bottom row
        S.C(j+1,s-1)=1; S.C(j+1,n)=1; j=j+1;                               % bottom row to right fixed node
        for i=1:s-2,    S.C(j+i,s-1+i)=1; S.C(j+i,s+i)=1;   end, j=j+s-2;  % top row
        S.C(j+1,n-1)=1; S.C(j+1,s)=1; j=j+1;                               % left diagonal to fixed node
        for i=1:s-1, S.C(j+i,i)=1;       S.C(j+i,2*s-2+i)=1; end, j=j+s-1; % internal verticals
        for i=1:s-1, S.C(j+i,2*s-2+i)=1; S.C(j+i,s-1+i)=1;   end, j=j+s-1; % internal verticals
        num=ceil((s-2)/2);
        for i=1:num, S.C(j+i,i+1)=1;     S.C(j+i,2*s+i-2)=1; end, j=j+num; % up/left  diagonals
        for i=1:num, S.C(j+i,s+i)=1;     S.C(j+i,2*s+i-2)=1; end, j=j+num; % up/left  diagonals
        for i=1:num, S.C(j+i,s-i-1)=1;   S.C(j+i,3*s-i-2)=1; end, j=j+num; % up/right diagonals
        for i=1:num, S.C(j+i,2*s-i-2)=1; S.C(j+i,3*s-i-2)=1; end, j=j+num; % up/right diagonals
        S.C(j+1,n-s-1)=1; S.C(j+1,n)=1; j=j+1;                             % right diagonal to fixed node
    case 'K2'
        m=6*s-6; if mod(s,2)==1, m=m+2; end, S.C=zeros(m,q+p+r);
        S.C(1,n-1)=1;   S.C(1,1)=1; j=1;                                   % bottom row to left fixed node
        for i=1:s-2,    S.C(j+i,i)=1; S.C(j+i,i+1)=1;       end, j=j+s-2;  % bottom row
        S.C(j+1,s-1)=1; S.C(j+1,n)=1; j=j+1;                               % bottom row to right fixed node
        for i=1:s-2,    S.C(j+i,s-1+i)=1; S.C(j+i,s+i)=1;   end, j=j+s-2;  % top row
        S.C(j+1,n-1)=1; S.C(j+1,s)=1; j=j+1;                               % left diagonal to fixed node
        for i=1:s-1, S.C(j+i,i)=1;       S.C(j+i,2*s-2+i)=1; end, j=j+s-1; % internal verticals
        for i=1:s-1, S.C(j+i,2*s-2+i)=1; S.C(j+i,s-1+i)=1;   end, j=j+s-1; % internal verticals
        num=ceil((s-2)/2);
        for i=1:num, S.C(j+i,i)=1;       S.C(j+i,2*s+i-1)=1; end, j=j+num; % up/left  diagonals
        for i=1:num, S.C(j+i,s+i-1)=1;   S.C(j+i,2*s+i-1)=1; end, j=j+num; % up/left  diagonals
        for i=1:num, S.C(j+i,s-i)=1;     S.C(j+i,3*s-i-3)=1; end, j=j+num; % up/right diagonals
        for i=1:num, S.C(j+i,2*s-i-1)=1; S.C(j+i,3*s-i-3)=1; end, j=j+num; % up/right diagonals
        S.C(j+1,n-s-1)=1; S.C(j+1,n)=1; j=j+1;                             % right diagonal to fixed node
end, disp(' '); 

% External forces on the free nodes of the lower surface of the truss (normalized)
load=round(load*sb*10)/(sb*10);
s1=floor(load*sb); s2=ceil(load*sb);

if s1==s2
  L.U=zeros(2,q); L.U(2,s1)=-1;
else
  % add a node at the location of the applied force
  S.C=[S.C(:,1:q) zeros(m,1) S.C(:,q+1:end)];
  q=q+1; L.U=zeros(2,q); S.Q(:,q)=[load; 0]; L.U(2,q)=-1;
  if s1==0, s1=q+1; elseif s2==sb, s2=q+2; end
  % find two-force member that connects s1 and s2.
  % make that member also connect to this new nodal location (turns truss into a frame!!)
  for i=1:m
      S.C(i,:)
      j=find(S.C(i,:),2)   % check to see if this member should include the applied force
      if ((j(1)==s1 & j(2)==s2) | (j(2)==s1 & j(1)==s2))
         S.C(i,q)=1; break,
      end
      if i==m, error('Could not find which member to put load on...'), end
  end
end

if height>0, L.U_in=false(q,1), else, L.U_in=true(q,1), end

% THE FOLLOWING IS WHERE THE MAGIC HAPPENS!  :)
[A,b,S,L]=RR_Structure_Analyze(S,L); x=pinv(A)*b;
RR_Structure_Plot(S,L,x,ax); error=norm(A*x-b)
end % function update_truss
