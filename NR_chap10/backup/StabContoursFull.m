% script RC_StabContoursFull.m                          % Numerical Renaissance Codebase 1.0
Np=101; V=[1 1.0000000001];
name = strvcat('EE','IE','CN','RK2','RK3','RK4','AB2','AB3','AB4','AB5','RC_AB6', ...
               'AM3','AM4','AM5','AM6','BDF2','BDF3','BDF4','BDF5','BDF6', ...
               'ESD2','ESD3','ESD4','ESD5','ESD6','ESD7','ESD8','ESD9', ...
               'GLRK4','GLRK6','DIRK4','DIRK42p','RK4352R','RK4353R','RK5483R','CNtheta','CNphi','IMEXDIRK','IMEXERK');
for k=38:39
  switch k
    case {1,2,3},                   B=[ -2.55; 2.05; -2.25; 2.25];  % bounds for EE, IE, CN
    case {4,5,6},                   B=[ -4.05; 2.05; -3.05; 3.05];  % bounds for RK
    case {7,8,9,10,11},             B=[ -1.35; 0.35; -0.85; 0.85];  % bounds for AB
    case {12,13,14,15},             B=[ -6.55; 0.55; -3.55; 3.55];  % bounds for AM
    case {16,17,18,19,20},          B=[-11.05; 5.05; -8.05; 8.05];  % bounds for BDF
    case {21,22,23,24,25,26,27,28}, B=[-11.05; 5.05; -8.05; 8.05];  % bounds for ESD
    case 29, B=[ -5.01; 9.01; -7.01; 7.01];                         % GLRK4
      A=zeros(2); A(1,1)=1/4; A(1,2)=1/4-sqrt(3)/6; A(2,1)=1/4+sqrt(3)/6; A(2,2)=1/4; b(1)=1/2; b(2)=1/2; 
    case 30, B=[ -5.01; 9.01; -7.01; 7.01];                         % GLRK6
      A=zeros(3); A(1,1)=5/36; A(1,2)=2/9-sqrt(15)/15; A(1,3)=5/36-sqrt(15)/30;                          
      A(2,1)=5/36+sqrt(15)/24; A(2,2)=2/9; A(2,3)=5/36-sqrt(15)/24;
      A(3,1)=5/36+sqrt(15)/30; A(3,2)=2/9+sqrt(15)/15; A(3,3)=5/36; b(1)=5/18; b(2)=8/18; b(3)=5/18; 
    case 31, B=[ -5.01; 9.01; -7.01; 7.01];                         % DIRK4
      gamma=sqrt(2)*cos(acos(sqrt(2^3)/3)/3+4*pi/3)+1;                                        
      A=zeros(4); A(2,1)=gamma; A(2,2)=gamma; A(3,3)=gamma; A(4,4)=gamma;
      A(3,1)=(-20*gamma^2+10*gamma-1)/(4*gamma); A(3,2)=(4*gamma-1)*(2*gamma-1)/(4*gamma);
      A(4,1)=(24*gamma^3-36*gamma^2+12*gamma-1)/(12*gamma*(1-2*gamma)); A(4,2)=(12*gamma^2-6*gamma+1)/(12*gamma*(1-4*gamma));
      A(4,3)=(6*gamma^2-6*gamma+1)/(3*(4*gamma-1)*(2*gamma-1)); b=A(4,:)';     
    case 32, B=[ -5.01; 9.01; -7.01; 7.01];                         % DIRK42p
      A=zeros(4); A(1,1)=1; A(2,2)=3/5; A(3,3)=1; A(4,4)=3/5;                               
      A(3,1)=171/44; A(3,2)=-215/44; A(4,1)=-43/20; A(4,2)=39/20;
      b(1)=11/72; b(2)=25/72; b(3)=11/72; b(4)=25/72;
    case 33, B=[ -6.55; 1.55; -4.05; 4.05];                         % RK4352R
      A=zeros(5);
      A(2,1)= 970286171893/4311952581923; A(3,2)= 6584761158862/12103376702013; A(4,3)= 2251764453980/15575788980749;
      A(5,4)= 26877169314380/34165994151039; b(1)= 1153189308089/22510343858157; b(2)= 1772645290293/4653164025191; 
      b(3)= -1672844663538/4480602732383; b(4)= 2114624349019/3568978502595; b(5)= 5198255086312/14908931495163;
      A(3:5,1)=b(1); A(4:5,2)=b(2); A(5,3)=b(3);
    case 34, B=[ -6.55; 1.55; -4.05; 4.05];                         % RK4353R
      A=zeros(5);
      A(2,1)= 2365592473904/8146167614645; A(3,2)= 4278267785271/6823155464066; A(4,3)= 2789585899612/8986505720531;
      A(5,4)= 15310836689591/24358012670437; A(3,1)= -722262345248/10870640012513; A(4,2)= 1365858020701/8494387045469;
      A(5,3)= 3819021186/2763618202291; b(1)= 846876320697/6523801458457;  b(2)= 3032295699695/12397907741132;
      b(3)= 612618101729/6534652265123; b(4)= 1155491934595/2954287928812; b(5)= 707644755468/5028292464395;
      A(4:5,1)=b(1); A(5,2)=b(2);
    case 35, B=[ -6.55; 1.55; -4.05; 4.05];                         % RK5483R
      A=zeros(8);
      A(2,1)=141236061735/3636543850841; A(3,2)=7367658691349/25881828075080; A(4,3)=6185269491390/13597512850793;
      A(5,4)=2669739616339/18583622645114; A(6,5)=42158992267337/9664249073111; A(7,6)=970532350048/4459675494195;
      A(8,7)=1415616989537/7108576874996; A(3,1)=- 343061178215/2523150225462; A(4,2)=- 4057757969325/18246604264081;
      A(5,3)=1415180642415/13311741862438; A(6,4)=- 93461894168145/25333855312294; A(7,5)=7285104933991/14106269434317;
      A(8,6)=- 4825949463597/16828400578907; b(1)=  514862045033/4637360145389; b(2)=0; b(3)=0; b(4)=0; 
      b(5)=2561084526938/7959061818733; b(6)=4857652849/7350455163355; b(7)=1059943012790/2822036905401; b(8)=2987336121747/15645656703944;
      A(4:8,1)=b(1); A(5:8,2)=b(2); A(6:8,3)=b(3); A(7:8,4)=b(4); A(8,5)=b(5);
    case {36,37}, B=2.5*[ -1.55; 6.55; -4.05; 4.05];                % CN(theta), CN(phi)
    case 38, B=[ -6.55; 1.55; -4.05; 4.05];                         % IMEX-DIRK
      A=zeros(4); gamma=0.4358665215; delta=-0.644373171; eta=0.3966543747; mu=0.5529291479;
      A(2,2)=gamma; A(3,2)= (1-gamma)/2; A(3,3)= gamma;
      A(4,2)= 1-delta-gamma; A(4,3)= delta; A(4,4)= gamma; b(1)=0;
      b(2)  = 1-delta-gamma; b(3)  = delta; b(4)  = gamma;
    case 39, B=[ -6.55; 1.55; -4.05; 4.05];                         % IMEX-ERK
      A=zeros(4); gamma=0.4358665215; delta=-0.644373171; eta=0.3966543747; mu=0.5529291479;
      A(2,1)=gamma; A(3,1)= (1+gamma)/2-eta; A(3,2)= eta;
      A(4,1)= 1-2*mu; A(4,2)= mu; A(4,3)= mu; b(1)=0;
      b(2)  = 1-delta-gamma; b(3)  = delta; b(4)  = gamma;    
  end % switch
  LR(:,1)=[B(1):(B(2)-B(1))/(Np-1):B(2)]';
  LI(:,1)=[B(3):(B(4)-B(3))/(Np-1):B(4)]';
  for j=1:Np; for i=1:Np;
    L = LR(j) + sqrt(-1) * LI(i);
    switch k
      case  1, sig(i,j)=abs(1+L);                                                                     % EE
      case  2, sig(i,j)=abs(1/(1-L));                                                                 % IE
      case  3, sig(i,j)=abs((1+L/2)/(1-L/2));                                                         % CN
      case  4, sig(i,j)=abs(1+L+L^2/2);                                                               % RK2
      case  5, sig(i,j)=abs(1+L+L^2/2+L^3/6);                                                         % RK3
      case  6, sig(i,j)=abs(1+L+L^2/2+L^3/6+L^4/24);                                                  % RK4
      case  7, sig(i,j)=max(abs(roots([1 -1 0]-[0 3 -1]*L/2)));                                       % AB2
      case  8, sig(i,j)=max(abs(roots([1 -1 0 0]-[0 23 -16 5]*L/12)));                                % AB3
      case  9, sig(i,j)=max(abs(roots([1 -1 0 0 0]-[0 55 -59 37 -9]*L/24)));                          % AB4 
      case 10, sig(i,j)=max(abs(roots([1 -1 0 0 0 0]-[0 1901 -2774 2616 -1274 251]*L/720)));          % AB5
      case 11, sig(i,j)=max(abs(roots([1 -1 0 0 0 0 0]-[0 4277 -7923 9982 -7298 2877 -475]*L/1440))); % RC_AB6
      case 12, sig(i,j)=max(abs(roots([1 -1 0]-[5 8 -1]*L/12)));                                      % AM3
      case 13, sig(i,j)=max(abs(roots([1 -1 0 0]-[9 19 -5 1]*L/24)));                                 % AM4
      case 14, sig(i,j)=max(abs(roots([1 -1 0 0 0]-[251 646 -264 106 -19]*L/720)));                   % AM5
      case 15, sig(i,j)=max(abs(roots([1 -1 0 0 0 0]-[475 1427 -798 482 -173 27]*L/1440)));           % AM6
      case 16, sig(i,j)=max(abs(roots([1 0 0]-[2*L 4 -1]/3)));                                        % BDF2
      case 17, sig(i,j)=max(abs(roots([1 0 0 0]-[6*L 18 -9 2]/11)));                                  % BDF3
      case 18, sig(i,j)=max(abs(roots([1 0 0 0 0]-[12*L 48 -36 16 -3]/25)));                          % BDF4
      case 19, sig(i,j)=max(abs(roots([1 0 0 0 0 0]-[60*L 300 -300 200 -75 12]/137)));                % BDF5
      case 20, sig(i,j)=max(abs(roots([1 0 0 0 0 0 0]-[60*L 360 -450 400 -225 72 -10]/147)));         % BDF6
      case 21, sig(i,j)=max(abs(roots([1 -1]-[2-L 0]*L/2)));                                          % ESD2-9
      case 22, sig(i,j)=max(abs(roots([1 -1]-[4-L 2]*L/6)));          
      case 23, sig(i,j)=max(abs(roots([1 -1 0]-[29-6*L 20 -1]*L/48)));          
      case 24, sig(i,j)=max(abs(roots([1 -1 0 0]-[614-114*L 513 -54 7]*L/1080)));          
      case 25, sig(i,j)=max(abs(roots([1 -1 0 0 0]-[3133-540*L 3008 -492 128 -17]*L/5760)));
      case 26, sig(i,j)=max(abs(roots([1 -1 0 0 0 0]-[317731-51780*L 340440 -76260 29840 -7935 984]*L/604800)));            
      case 27, sig(i,j)=max(abs(roots([1 -1 0 0 0 0 0]-[247021*3-275*420*L 12079*72 -13823*18 8131*16 -5771*9 179*72 -731*2]*L/1451520)));            
      case 28, sig(i,j)=max(abs(roots([1 -1 0 0 0 0 0 0]-[1758023*54-33953*420*L 1147051*105 -133643*315 157513*175 -2797*5250 86791*63 -35453*35 8563*15]*L/190512000)));
      case 29,                                                                                       % GLRK4
        Lmod=(eye(2)-L*A)\[L;L];
        sig(i,j)=abs(1+b(1)*Lmod(1)+b(2)*Lmod(2));
      case 30,                                                                                       % GLRK6
        Lmod=(eye(3)-L*A)\[L;L;L];
        sig(i,j)=abs(1+b(1)*Lmod(1)+b(2)*Lmod(2)+b(3)*Lmod(3));  
      case 31,                                                                                       % DIRK4
        Lmod=(eye(4)-L*A)\[L;L;L;L];
        sig(i,j)=abs(1+b(1)*Lmod(1)+b(2)*Lmod(2)+b(3)*Lmod(3)+b(4)*Lmod(4));    
      case 32,                                                                                       % DIRK42p
        Lmod=(eye(4)-L*A)\[L;L;L;L];
        sig(i,j)=abs(1+b(1)*Lmod(1)+b(2)*Lmod(2)+b(3)*Lmod(3)+b(4)*Lmod(4));    
      case 33,                                                                                       % RK4352R                      
        Lmod=(eye(5)-L*A)\[L;L;L;L;L];
        sig(i,j)=abs(1+b(1)*Lmod(1)+b(2)*Lmod(2)+b(3)*Lmod(3)+b(4)*Lmod(4)+b(5)*Lmod(5)); 
      case 34,                                                                                       % RK4353R
        Lmod=(eye(5)-L*A)\[L;L;L;L;L];
        sig(i,j)=abs(1+b(1)*Lmod(1)+b(2)*Lmod(2)+b(3)*Lmod(3)+b(4)*Lmod(4)+b(5)*Lmod(5));    
      case 35,                                                                                       % RK5483R
        Lmod=(eye(8)-L*A)\[L;L;L;L;L;L;L;L];
        sig(i,j)=abs(1+b(1)*Lmod(1)+b(2)*Lmod(2)+b(3)*Lmod(3)+b(4)*Lmod(4)+b(5)*Lmod(5)+b(6)*Lmod(6)+b(7)*Lmod(7)+b(8)*Lmod(8));    
      case 36,                                                                                       % CN(theta)
        theta=1/8; sig(i,j)=max(abs(roots([1 -1]-((1-theta)*[1 1]/2+theta*[1 0])*L)));
      case 37,                                                                                       % CN(phi)
        phi=1; sig(i,j)=max(abs(roots([1 -1 0]-((1-phi)*[1 1 0]/2+phi*[3 0 1]/4)*L)));
      case 38,                                                                                       % IMEX-DIRK
        Lmod=(eye(4)-L*A)\[L;L;L;L];
        sig(i,j)=abs(1+b(1)*Lmod(1)+b(2)*Lmod(2)+b(3)*Lmod(3)+b(4)*Lmod(4));    
      case 39,                                                                                       % IMEX-ERK
        Lmod=(eye(4)-L*A)\[L;L;L;L];
        sig(i,j)=abs(1+b(1)*Lmod(1)+b(2)*Lmod(2)+b(3)*Lmod(3)+b(4)*Lmod(4));    
    end % switch
  end; end
  figure(k); clf; contourf(LR(:),LI(:),1./sig(:,:),V,'k-'); colormap autumn;
  set(gca,'FontSize',15); axis('square'); title(name(k,:),'FontSize',18); hold on; 
  plot([B(1) B(2)],[0,0],'k-'); plot([0,0],[B(3) B(4)],'k-');
  hold off;  pause(1); eval(['print -depsc ',sprintf('stab%s',name(k,:))])
end % for k
% end script RC_StabContoursFull.m