function RR_Plot_Frame(Q,C,U,x,P,R,S,M,flip_vp,flip_p,flip_u);
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 5)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

if nargin<7, S=[]; if nargin<6, R=[]; if nargin<5, P=[]; end, end, end, N=[Q P R S];
[m,n]=size(C); [ds,s]=size(S); [dr,r]=size(R); [dp,p]=size(P); [d,q]=size(Q);
if nargin<8, M=zeros(1,m); end
if nargin<9  | length(flip_vp)~=p, flip_vp=ones(1,p); end
if nargin<10 | length(flip_p )~=p, flip_p =ones(1,p); end
if nargin<11 | length(flip_u )~=q, flip_u =ones(1,q); end

F(1:m,1:n,1:d)=0;    % extract nonzero forces on members at nodes from x
for i=1:m, for j=1:n, if C(i,j)==1, for k=1:d, F(i,j,k)=x(1); x=x(2:end); end,end,end,end

VP=[]; VR=[]; VS=[]; % extract nonzero reaction forces at P,R,S support points from x
for i=1:p, for k=1:d, VP(k,i)=x(1);       x=x(2:end); end, end
for i=1:r,   if d==2, VR(:,i)=[0;x(1)]; else, VR(:,i)=[0;0;x(1)]; end, x=x(2:end); end 
for i=1:s, for k=1:d, VS(k,i)=x(1);       x=x(2:end); end, end
% extract nonzero moments at S support points from x
for i=1:s, if d==2,         MS(i)=x(1);   x=x(2:end);
           else, for k=1:d, MS(k,i)=x(1); x=x(2:end); end
end, end

% print out the tension in compression in the 2-force members (only) 
sc=0;
for i=1:m
  if sum(C(i,:))==2, [m,j]=maxk(C(i,:),2); sw(i)=3;
    f1=reshape(F(i,j(1),:),1,[]);
    f2=reshape(F(i,j(2),:),1,[]);
%    t2=norm(()+0.01*f1)-(N(:,j(2))+0.01*f2));
%    t3=norm((N(:,j(1))-0.01*f1)-(N(:,j(2))-0.01*f2));
    if norm(f1-f2)<1e-5;
       fprintf('Two-force           member #%d nearly slack.\n',i),     sy(i,:)='k-';
    elseif dot(N(:,j(1))-N(:,j(2)),f1-f2)>0
       fprintf('Pure tension     in member #%d = %0.5g N\n',i,norm(f1)), sy(i,:)='r-';
    else
       fprintf('Pure compression in member #%d = %0.5g N\n',i,norm(f1)), sy(i,:)='b-';
    end
  else
    sw(i)=6;
    switch mod(sc,2)
      case 0, sy(i,:)='g-';
      case 1, sy(i,:)='c-';
      case 2, sy(i,:)='m-';
      case 3, sy(i,:)='k-'; 
    end; sc=sc+1;
  end
end
for i=1:size(U,2),
  fprintf('Externally-applied load at free node #%d: %0.5g N\n',i,norm(U(:,i)))
end
for i=1:size(VP,2),
  fprintf('Reaction force at pinned node #%d: %0.5g N\n',i,norm(VP(:,i)))
end
for i=1:size(VR,2),
  fprintf('Reaction force at roller node #%d: %0.5g N\n',i,norm(VR(:,i)))
end
for i=1:size(VS,2),
  fprintf('Reaction force at  fixed node #%d: %0.5g N\n',i,norm(VS(:,i)))
  if (d==2)
    fprintf('Reaction moment at fixed node #%d: %0.5g N m\n',i,MS(i)),
  else
    fprintf('Reaction moment at fixed node #%d: (%0.5g,%0.5g,%0.5g) N m\n',i,MS(i,:)),
  end
end
fac_b=1*(max(max(N))-min(min(N))); fac_f=0.1/max(max([U VP VR VS]))*fac_b; 
figure(1), clf, axis equal, axis tight, grid, hold on, h=max(Q(2,:));

if d==2
  for i=1:p, hp(i)=1; end % ADJUST THIS
  % Plot little triagles below/above the pinned support points in 2D
  for i=1:p,  fill(P(1,i)+fac_b*[-.035 0 .035],P(2,i)+hp(i)*fac_b*[-.05 0 -.05],'k-'), end
  for i=1:r % Plot little triagles with little circles below the roller support points in 2D
             fill(R(1,i)+fac_b*[-.035 0 .035],R(2,i)+fac_b*[-.05 0 -.05],'k-')
    RR_drawcircle2([R(1,i)-fac_b*.02 R(2,i)-fac_b*.065],fac_b*.015,3,'k')
    RR_drawcircle2([R(1,i)+fac_b*.02 R(2,i)-fac_b*.065],fac_b*.015,3,'k')
  end
  % Plot little rectangles at the fixed support points in 2D
  for i=1:s, fill(S(1,i)+fac_b*[-.1 -.1 .1 .1],S(2,i)+fac_b*[-.05 0 0 -.05],'k-'), end
else
  for i=1:p, if VP(3,i)<0, hp(i)=-1; else, hp(i)=1; end, end
  % Plot little pyramids below the pinned support points in 3D
  for i=1:p, RR_Plot_Pyramid(P(:,i),fac_b*.05), end 
  for i=1:r % Plot little pyramids with little spheres below the roller support points in 3D
    RR_Plot_Pyramid(R(:,i),fac_b*.05)
    disp('TODO: Draw the rollers!'), beep
  end
  % Plot little rectangular prisms below the fixed support points in 3D     
  for i=1:s, RR_Plot_Cube(S(:,i),fac_b*.05), end 
end
[row,col] = find(C'); % This finds the row and col of nonzero entries of C'

member=0;
for i=1:length(row)   % This plots the members of the structure in both 2D and 3D.
  newx=N(1,row(i)); newy=N(2,row(i)); if d==3, newz=N(3,row(i)); end 
  if col(i)>member, member=member+1;
  else, if d==2, plot([lastx newx],[lasty newy],sy(member,:),"LineWidth",sw(member));
        else     plot3([lastx newx],[lasty newy],[lastz newz],sy(member,:),"LineWidth",sw(member)); end
  end
  lastx=newx; lasty=newy; if d==3, lastz=newz; end 
end

if d==2              % this handles the rest of the d=2 (2D) case
  t1=sum(U,2);  t2=sum([VP VR VS],2);
  fprintf('Sum of all applied  forces in (x,y) = (%+0.5g, %+0.5g) N\n',t1(1),t1(2))
  if p+r+s>0, fprintf('Sum of all reaction forces in (x,y) = (%+0.5g, %+0.5g) N\n',t2(1),t2(2)), end
  for i=1:q
    if flip_u(i)>0
      f=quiver(N(1,i),N(2,i),fac_f*U(1,i),fac_f*U(2,i),0);
    else
      f=quiver(N(1,i)-fac_f*U(1,i),N(2,i)-fac_f*U(2,i),fac_f*U(1,i),fac_f*U(2,i),0);
    end
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','m');
  end
  for i=1:p
    if flip_u(i)>0
      f=quiver(P(1,i),P(2,i),fac_f*VP(1,i),fac_f*VP(2,i),0);
    else
      f=quiver(P(1,i)-fac_f*VP(1,i),P(2,i)-fac_f*VP(2,i),fac_f*VP(1,i),fac_f*VP(2,i),0);
    end
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','r');
  end
  for i=1:r
    if h*sign(VR(2,i))>0
      f=quiver(R(1,i),R(2,i),fac_f*VR(1,i),fac_f*VR(2,i),0);
    else
      f=quiver(R(1,i)-fac_f*VR(1,i),R(2,i)-fac_f*VR(2,i),fac_f*VR(1,i),fac_f*VR(2,i),0);
    end
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','r');
  end
  h=-1; for i=1:s
    if h*sign(VS(2,i))>0
      f=quiver(S(1,i),S(2,i),fac_f*VS(1,i),fac_f*VS(2,i),0);
    else
      f=quiver(S(1,i)-fac_f*VS(1,i),S(2,i)-fac_f*VS(2,i),fac_f*VS(1,i),fac_f*VS(2,i),0);
    end
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','r');
    if MS(i)<0
      r=0.4; t=-2*pi*7/8; x=S(1,i)+r*cos(t); y=S(1,i)+r*sin(t);
      RR_drawcircle2(S(:,i),0.4,3,'r',0,t)
      plot([x x-r/2],[y y+r/20],'r','LineWidth',3)
      plot([x x-r/4],[y y+r/2], 'r','LineWidth',3)
    else 
      r=0.4; t=2*pi*3/8; x=S(1,i)+r*cos(t); y=S(1,i)+r*sin(t);
      RR_drawcircle2(S(:,i),0.4,3,'r',-pi,t)
      plot([x x+r/2],[y y+r/20],'r','LineWidth',3)
      plot([x x+r/4],[y y+r/2], 'r','LineWidth',3)
    end
  end
else              % this handles the rest of the d=3 (3D) case
  t1=sum(U,2);  t2=sum([VP VR VS],2);
  fprintf('Sum of all applied  forces in (x,y,z) = (%+0.5g, %+0.5g, %+0.5g) N\n',t1(1),t1(2),t1(3))
  if p+r+s>0, fprintf('Sum of all reaction forces in (x,y,z) = (%+0.5g, %+0.5g, %+0.5g) N\n',t2(1),t2(2),t2(3)), end
  fac_b=fac_b*0.07; fac_f=fac_f*2;                   % Tweak the scale factors for 3D

  for i=1:q
     if flip_u(i)>0
            f=quiver3(Q(1,i)-fac_f*U(1,i), Q(2,i)-fac_f*U(2,i), Q(3,i)-fac_f*U(3,i), ...
                      fac_f*U(1,i),        fac_f*U(2,i),        fac_f*U(3,i),0);
    else,   f=quiver3(Q(1,i),       Q(2,i),       Q(3,i), ...
                      fac_f*U(1,i), fac_f*U(2,i), fac_f*U(3,i),0);
    end
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','m');
  end
  for i=1:p
    if flip_vp(i)>0
      f=quiver3(P(1,i)-fac_f*VP(1,i), P(2,i)-fac_f*VP(2,i), P(3,i)-fac_f*VP(3,i), ...
                       fac_f*VP(1,i),        fac_f*VP(2,i),        fac_f*VP(3,i),0);
    else
      f=quiver3(P(1,i),        P(2,i),        P(3,i), ...
                fac_f*VP(1,i), fac_f*VP(2,i), fac_f*VP(3,i),0);
    end      
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','r');
  end
  for i=1:r
    if h*VR(3,i)>0,
            f=quiver3(R(1,i)-fac_f*VR(1,i), R(2,i)-fac_f*VR(2,i), R(3,i)-fac_f*VR(3,i), ...
                      fac_f*VR(1,i),        fac_f*VR(2,i),        fac_f*VR(3,i),0);
    else,   f=quiver3(R(1,i),        R(2,i),        R(3,i), ...
                      fac_f*VR(1,i), fac_f*VR(2,i), fac_f*VR(3,i),0);
    end
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','r');
  end
  for i=1:s
    if h*VS(3,i)>0,
            f=quiver3(S(1,i)-fac_f*VS(1,i), S(2,i)-fac_f*VS(2,i), S(3,i)-fac_f*VS(3,i), ...
                      fac_f*VS(1,i),        fac_f*VS(2,i),        fac_f*VS(3,i),0);
    else,   f=quiver3(S(1,i),        S(2,i),        S(3,i), ...
                      fac_f*VS(1,i), fac_f*VS(2,i), fac_f*VS(3,i),0);
    end
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','r');
    if norm(MS(i))>1e-8  % plot the vector moment as a double headed arrow
       f=quiver3(S(1,i),        S(2,i),        S(3,i), ...
                 fac_f*MS(1,i), fac_f*MS(2,i), fac_f*MS(3,i),0);
      set(f,'MaxHeadSize',10000,'linewidth',3,'color','g');
      fac_m=1.5*fac_f
      f=quiver3(S(1,i),        S(2,i),        S(3,i), ...
                 fac_m*MS(1,i), fac_m*MS(2,i), fac_m*MS(3,i),0);
      set(f,'MaxHeadSize',10000,'linewidth',3,'color','g');
    end
  end
  view(-75.3,6.05)
end
axis tight
end % function RR_Plot_Frame
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function RR_drawcircle2(loc,r,w,c,deg_min,deg_max)
if nargin<4; c=[0 .7 0]; end
if nargin<6; deg_min=0; deg_max=2*pi; end
N=40;
THETA=linspace(deg_min,deg_max,N);
RHO=ones(1,N)*r;
[X,Y] = pol2cart(THETA,RHO);
X=X+loc(1);
Y=Y+loc(2);
Z=0*X;
H=line(X,Y,Z);
set(H,'LineWidth',w);
set(H,'Color',c);
end % function RR_drawcircle2