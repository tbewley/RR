% script RR_Truss_GUI
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 6)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, figure(1), clf
global truss height s load curvature ax
truss="Pennsylvania"; height=0.2; s=6; load=0.5; curvature=0;  % Initial values

fig=uifigure; g=uigridlayout(fig);           % Set up a grid for all of the elements
g.RowHeight = {'1x',40};                     % Tall upper row, fixed hight lower row
g.ColumnWidth = {'1x','1x','1x','1x','1x'};  % Five equal-width columns
ax = uiaxes(g);                              % Frame into which we will put our plot
ax.Layout.Row=1; ax.Layout.Column=[1 5];     % This is in all 5 columns of row 1 of g
update_truss

% truss choice
dd = uidropdown(g,"ValueChangedFcn",@(src,event)update1(src,event), ...
    "Items",["Warren","Howe","Pratt","Pennsylvania","K"]);
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

cla(ax), hold on, s=round(s); clear Q U C;
% Locations of the fixed nodes of the truss (note: normalized units)
P=[0 1; 0 0]; p=2;  

% Locations of the free nodes of the truss
if strcmp(truss,'Pennsylvania'), sb=s*2; else, sb=s; end
for i=1:sb-1, Q(:,i)=[i/sb; 0]; end, q=sb-1;   % free nodes in bottom row
switch truss                                   
    case 'Warren'
        for i=1:s,   Q(:,q+i)=[(i-0.5)/s; height*(1-curvature*4*((i-0.5)/s-0.5)^2)]; end, q=q+s; % free nodes in top row
    case {'Howe','Pratt'}
        for i=1:s-1, Q(:,q+i)=[i/s; height*(1-curvature*4*(i/s-0.5)^2)]; end, q=q+s-1; % free nodes in top row
    case 'Pennsylvania'
        for i=1:s-1, Q(:,q+i)=[i/s; height*(1-curvature*4*(i/s-0.5)^2)]; end, q=q+s-1; % free nodes in top row
        Q(:,q+1)=[(1/2)/s;   Q(2,sb)/2]; q=q+1;
        for i=2:s-1, Q(:,q+i-1)=[(i-1/2)/s; min(Q(2,sb+i-2),Q(2,sb+i-1))/2]; end; q=q+s-2; % free nodes in middle row
        Q(:,q+1)=[1-(1/2)/s; Q(2,sb)/2]; q=q+1;
    case 'K'
        for i=1:s-1, Q(:,q+i)=[i/s; height*(1-curvature*4*(i/s-0.5)^2)]; end, q=q+s-1; % free nodes in top    row
        for i=1:s-1, Q(:,q+i)=[i/s; (height/2)*(1-curvature*4*(i/s-0.5)^2)]; end, q=q+s-1; % free nodes in middle row
end
n=q+p; Qsize=size(Q);

% External forces on the free nodes of the lower surface of the truss (normalized)
load=round(load*sb*10)/(sb*10);
s1=floor(load*sb); s2=ceil(load*sb);
U=zeros(2,q);
if s1==s2,  U(2,s1)=-1; else
  if s1>0,  U(2,s1)=sb*load-s2; end
  if s2<sb, U(2,s2)=s1-sb*load; end
end

% Connectivity of the truss. This clever idea was developed by Robert Skelton.
% A bit of logic is needed here to define different classes of truss for arbitrary s.
% Note that each column of C^T has exactly one entry equal to +1, and one entry equal to -1.
switch truss                        % free nodes in top row
    case 'Warren'
        m=4*s-1; C=zeros(m,q+p);
        C(1,n-1)=-1;   C(1,1)=1; j=1;                               % bottom row to left fixed node
        for i=1:s-2,   C(j+i,i)=-1; C(j+i,i+1)=1;     end, j=j+s-2; % bottom row
        C(j+1,s-1)=-1; C(j+1,n)=1; j=j+1;                           % bottom row to right fixed node
        for i=1:s-1,   C(j+i,s-1+i)=-1; C(j+i,s+i)=1; end, j=j+s-1; % top row
        C(j+1,n-1)=-1; C(j+1,s)=1; j=j+1;                           % left diagonal to fixed node
        for i=1:s-1,   C(j+2*i-1,s+i-1)=-1; C(j+2*i-1,i)=1;         % internal diagonals
                       C(j+2*i,i)=1; C(j+2*i,s+i)=-1; end, j=j+2*s-2;  
        C(j+1,n-2)=-1; C(j+1,n)=1; j=j+1;                             % right diagonal to fixed node
    case 'Howe'
        m=4*s-3; C=zeros(m,q+p);
        C(1,n-1)=-1;   C(1,1)=1; j=1;                               % bottom row to left fixed node
        for i=1:s-2,   C(j+i,i)=-1; C(j+i,i+1)=1;     end, j=j+s-2; % bottom row
        C(j+1,s-1)=-1; C(j+1,n)=1; j=j+1;                           % bottom row to right fixed node
        for i=1:s-2,   C(j+i,s-1+i)=-1; C(j+i,s+i)=1; end, j=j+s-2; % top row
        C(j+1,n-1)=-1; C(j+1,s)=1; j=j+1;                           % left diagonal to fixed node
        for i=1:s-1,   C(j+i,i)=-1; C(j+i,s-1+i)=1;   end, j=j+s-1; % internal verticals
        num=ceil((s-2)/2);
        for i=1:num, C(j+i,i)=-1;   C(j+i,s  +i)=1;   end, j=j+num; % up/right diagonals
        for i=1:num, C(j+i,s-i)=-1; C(j+i,2*s-i-2)=1; end, j=j+num; % up/left  diagonals
        C(j+1,n-2)=-1; C(j+1,n)=1; j=j+1;                           % right diagonal to fixed node
    case 'Pratt'
        m=4*s-3; C=zeros(m,q+p);
        C(1,n-1)=-1;   C(1,1)=1; j=1;                               % bottom row to left fixed node
        for i=1:s-2,   C(j+i,i)=-1; C(j+i,i+1)=1;     end, j=j+s-2; % bottom row
        C(j+1,s-1)=-1; C(j+1,n)=1; j=j+1;                           % bottom row to right fixed node
        for i=1:s-2,   C(j+i,s-1+i)=-1; C(j+i,s+i)=1; end, j=j+s-2; % top row
        C(j+1,n-1)=-1; C(j+1,s)=1; j=j+1;                           % left diagonal to fixed node
        for i=1:s-1,   C(j+i,i)=-1; C(j+i,s-1+i)=1;   end, j=j+s-1; % internal verticals
        num=ceil((s-2)/2);
        for i=1:num, C(j+i,i+1)=-1; C(j+i,s+i-1)=1;   end, j=j+num; % up/left  diagonals
        for i=1:num, C(j+i,s-i-1)=-1; C(j+i,2*s-i-1)=1; end, j=j+num; % up/right diagonals
        C(j+1,n-2)=-1; C(j+1,n)=1; j=j+1;                           % right diagonal to fixed node
    case 'Pennsylvania'
        m=9*s+1; if mod(s,2)==1, m=m+5; end, C=zeros(m,q+p);
        C(1,n-1)=-1;    C(1,1)=1; j=1;                                  % bottom row to left fixed node
        for i=1:sb-2,   C(j+i,i)=-1; C(j+i,i+1)=1;       end, j=j+sb-2; % bottom row
        C(j+1,sb-1)=-1; C(j+1,n)=1; j=j+1;                              % bottom row to right fixed node
        for i=1:s-2,    C(j+i,sb-1+i)=-1; C(j+i,sb+i)=1; end, j=j+s-2;  % top row
        k=sb+s-2;
        C(j+1,n-1)=-1;  C(j+1,k+1)=1;  C(j+2,n  ) =-1;  C(j+2,k+s)=1;    % left/right diagonal areas to fixed nodes
        C(j+3,1  )=-1;  C(j+3,k+1)=1;  C(j+4,sb-1)=-1;  C(j+4,k+s)=1;
        C(j+5,2)  =-1;  C(j+5,k+1)=1;  C(j+6,sb-2)=-1;  C(j+6,k+s)=1; 
        C(j+7,sb) =-1;  C(j+7,k+1)=1;  C(j+8,k)=-1;     C(j+8,k+s)=1;  j=j+8; 
        for i=1:s-1,    C(j+i,2*i)=-1; C(j+i,sb-1+i)=1;  end, j=j+s-1;  % internal verticals
        num=floor(s/2);
        for i=2:num
            C(j+1,2*i-2) =-1;  C(j+1,k+i)=1; C(j+5,sb-2*i+2) =-1;  C(j+5,k+s+1-i)=1;    % left/right diagonal areas to fixed nodes
            C(j+2,2*i-1) =-1;  C(j+2,k+i)=1; C(j+6,sb-2*i+1)=-1;   C(j+6,k+s+1-i)=1;
            C(j+3,2*i)   =-1;  C(j+3,k+i)=1; C(j+7,sb-2*i  )=-1;   C(j+7,k+s+1-i)=1; 
            C(j+4,sb+i-2)=-1;  C(j+4,k+i)=1; C(j+8,k+2-i)   =-1;   C(j+8,k+s+1-i)=1;
            j=j+8; 
        end
        if mod(s,2)==1
            C(j+1,s-1)      =-1;  C(j+1,k+num+1)=1;
            C(j+2,s)        =-1;  C(j+2,k+num+1)=1;
            C(j+3,s+1)      =-1;  C(j+3,k+num+1)=1;
            C(j+4,2*s+num-1)=-1;  C(j+4,k+num+1)=1;
            C(j+5,2*s+num)  =-1;  C(j+5,k+num+1)=1;
        end
    case 'K'
        m=6*s-4; C=zeros(m,q+p);
        C(1,n-1)=-1;   C(1,1)=1; j=1;                               % bottom row to left fixed node
        for i=1:s-2,   C(j+i,i)=-1; C(j+i,i+1)=1;     end, j=j+s-2; % bottom row
        C(j+1,s-1)=-1; C(j+1,n)=1; j=j+1;                           % bottom row to right fixed node
        for i=1:s-2,   C(j+i,s-1+i)=-1; C(j+i,s+i)=1; end, j=j+s-2; % top row
        C(j+1,n-1)=-1; C(j+1,s)=1; j=j+1;                           % left diagonal to fixed node
        for i=1:s-1,   C(j+i,i)=-1;       C(j+i,2*s-2+i)=1; end, j=j+s-1; % internal verticals
        for i=1:s-1,   C(j+i,2*s-2+i)=-1; C(j+i,s-1+i)=1;   end, j=j+s-1; % internal verticals
        num=ceil((s-2)/2);
        for i=1:num, C(j+i,i+1)=-1;   C(j+i,2*s+i-2)=1; end, j=j+num; % up/left  diagonals
        for i=1:num, C(j+i,s+i)=-1;   C(j+i,2*s+i-2)=1; end, j=j+num; % up/left  diagonals
        for i=1:num, C(j+i,s-i-1)=-1; C(j+i,3*s-i-2)=1; end, j=j+num; % up/right diagonals
        for i=1:num, C(j+i,2*s-i-2)=-1; C(j+i,3*s-i-2)=1; end, j=j+num; % up/right diagonals
        C(j+1,n-s-1)=-1; C(j+1,n)=1; j=j+1;                           % right diagonal to fixed node
end, disp(' '); 

% THE FOLLOWING TWO LINES IS WHERE THE MAGIC HAPPENS!  :)
[A,b]=RR_Convert_DXCQ_eq_U_to_Ax_eq_b(Q,P,C,U); % Convert D*X*CQ=U problem to standard A*x=u form
x=pinv(A)*b;      % Compute tensile and compressive forces x in the truss, assuming no pretension

error=norm(A*x-b)

RR_Plot_Truss1(Q,P,C,x,ax);  % Plot the truss (blue=tension, red=compression, black=no_force)
if height>0, f=quiver(ax,load,0,0,0.1*(-1),0);        % Plot the load applied to the truss
else,        f=quiver(ax,load,-0.1*(-1),0,0.11*(-1));
end
set(f,'MaxHeadSize',10000,'linewidth',3,'color','k'); % Set the arrow style
if s1<s2, if     s1==0,  plot(ax,[P(1,1)  Q(1,s2)],[P(2,1)  Q(2,s2)],'m-',"LineWidth",6)
          elseif s2==sb, plot(ax,[Q(1,s1) P(1,2) ],[Q(2,s1) P(2,2) ],'m-',"LineWidth",6)
          else,          plot(ax,[Q(1,s1) Q(1,s2)],[Q(2,s1) Q(2,s2)],'m-',"LineWidth",6), end
end
end % function update_truss

function RR_Plot_Truss1(Q,P,C,x,ax);
N=[Q P]; [m,n]=size(C); [d,q]=size(Q); [d,p]=size(P);
axis equal, axis tight, grid(ax), axis(ax,[-0.05 1.05 -0.3 0.4]), hold(ax,"on")
h=max(Q(2,:));
if h==0; fac=0; plot(ax,-0.035,min(Q(2,:))-.01,'w.');
else,    fac=1; plot(ax,-0.035,h+.01,'w.'); end
fill(ax,P(1,1)+[-.035     0 .035*fac],P(2,1)+[-.05 0 -.05],'k-')
fill(ax,P(1,2)+[-.035*fac 0 .035    ],P(2,2)+[-.05 0 -.05],'k-')
N=[Q P];
mx=max(x); fprintf('maximum tension (red, bold)      = %0.5g\n',mx)
mn=min(x); fprintf('maximum compression (blue, bold) = %0.5g\n',abs(mn))
for i=1:m
  [i1,d1]=max(C(i,:)); [i2,d2]=min(C(i,:)); lw=3; 
  if x(i)<-0.01,    sy='b-'; if x(i)<mn*0.95, lw=6; end
  elseif x(i)>0.01, sy='r-'; if x(i)>mx*0.95, lw=6; end
  else, sy='k-'; end
  plot(ax,[N(1,d1) N(1,d2)],[N(2,d1) N(2,d2)],sy,"LineWidth",lw)
end
axis(ax,"tight"), axis(ax,"equal")
end % % function update_truss