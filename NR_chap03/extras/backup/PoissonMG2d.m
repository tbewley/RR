function RC_PoissonMG2d
% A 2D Poisson solver on UNIFORM (relax this!) mesh using MULTIGRID with CHECKERBOARD, ZEBRA, or TWEED
% smoothing. Input is assumed to be normalized such that the discretized Laplace operator
% has a 1 on the diagonal element. By Thomas Bewley, Paolo Luchini, and Anish Karandikar.
global XBC YBC N1 N2 N3 xo yo nlev d v g verbose direction m1 m2 m3 m4
e=max_error(1); if verbose>0, fprintf('Iter = 0, error = %0.3e\n',e); end

for i=1:N1; Smooth(1,m1); end  % APPLY SMOOTHING STEPS BEFORE STARTING MULTIGRID (N1 times)

tic; for iter=1:10             % PERFORM UP TO 10 MULTIGRID CYCLES.
   o=e;  Multigrid(1); e = max_error(1);
   if verbose>0, fprintf('Iter = %0.6g, error = %0.3e, factor = %0.4f\n',iter,e,o/e); end
   if e<1E-14,   fprintf('Converged\n'), break, end
end; t=toc; 

if verbose<2, fprintf('-> Total time: %0.3g; Time/iteration: %0.3g sec\n',t,t/iter); end
% end function RC_PoissonMG2d
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Multigrid(lev)
% The main recursive function for the multigrid algorithm. It calls the smoothing function,
% it performs the restriction and prolongation, and it calls itself on the coarser grid.
global XBC YBC N1 N2 N3 xo yo nlev d v g verbose direction m1 m2 m3 m4

for i=1:N2; Smooth(lev,m2); end     % APPLY SMOOTHING STEPS BEFORE COARSENING (N2 times)

% Now COMPUTE THE RESIDUAL and RESTRICT it to the coarser grid in a single step. 

% Trick #1: we will SKIP several factors below, including a /2 factor here; however, all
% skipped factors cancel.  Trick #2 (implemented here for the m2=='c' case only):
% we need calculate the residual ONLY on the red points here, as the residual on the
% neighboring black points is zero coming out of the previous call to Smooth

d{lev+1}=zeros(g{lev+1}.xm,g{lev+1}.ym);           

if m2=='c';
  for ic=2:g{lev+1}.xm-1; for jc=2:g{lev+1}.ym-1; i=2*(ic-xo)+xo; j=2*(jc-yo)+yo;
    d{lev+1}(ic,jc)=(v{lev}(i+1,j)+v{lev}(i-1,j)+v{lev}(i,j+1)+v{lev}(i,j-1))*0.25 ...
                    -v{lev}(i,j)+d{lev}(i,j);                            
  end; end; 
else;
  for ic=2:g{lev+1}.xm-1; for jc=2:g{lev+1}.ym-1; i=2*(ic-xo)+xo; j=2*(jc-yo)+yo;              
    d{lev+1}(ic,jc)= d{lev}(i,j) - 0.75*v{lev}(i,j) + ...
      0.25  *(d{lev}(i-1,j  )+d{lev}(i+1,j  )+d{lev}(i  ,j-1)+d{lev}(i  ,j+1)    ) + ...
      0.125 *(v{lev}(i-1,j-1)+v{lev}(i-1,j+1)+v{lev}(i+1,j-1)+v{lev}(i+1,j+1)    ) + ...
      0.0625*(v{lev}(i-2,j  )+v{lev}(i+2,j  )+v{lev}(i  ,j-2)+v{lev}(i  ,j+2)    );
  end; end; 
    
% The form below is equivalent to the above and easier to understand, but more expensive.
%    for ic=2:g{lev+1}.xm-1; for jc=2:g{lev+1}.ym-1; i=2*(ic-xo)+xo; j=2*(jc-yo)+yo;
%      d{lev+1}(ic,jc)=((v{lev}(i+1,j  )+v{lev}(i-1,j  )+v{lev}(i  ,j+1)+v{lev}(i  ,j-1))*0.25-v{lev}(i  ,j  )+d{lev}(i  ,j  ))+...
%                0.25 *((v{lev}(i+2,j  )+v{lev}(i  ,j  )+v{lev}(i+1,j+1)+v{lev}(i+1,j-1))*0.25-v{lev}(i+1,j  )+d{lev}(i+1,j  ))+...
%                0.25 *((v{lev}(i  ,j  )+v{lev}(i-2,j  )+v{lev}(i-1,j+1)+v{lev}(i-1,j-1))*0.25-v{lev}(i-1,j  )+d{lev}(i-1,j  ))+...
%                0.25 *((v{lev}(i+1,j-1)+v{lev}(i-1,j-1)+v{lev}(i  ,j  )+v{lev}(i  ,j-2))*0.25-v{lev}(i  ,j-1)+d{lev}(i  ,j-1))+...
%                0.25 *((v{lev}(i+1,j+1)+v{lev}(i-1,j+1)+v{lev}(i  ,j+2)+v{lev}(i  ,j  ))*0.25-v{lev}(i  ,j+1)+d{lev}(i  ,j+1));
%    end; end;

  % Apply corrections to the above residual computation / restriction for non-Dirichlet boundary conditions.
  if XBC==2
  end
  if YBC==2
  end
  if XBC==3
  end
  if YBC==3
  end
end

v{lev+1}=d{lev+1}; % Trick #3: this is a better initial guess for v{lev+1} than v{lev+1}=0.
EnforceBCs(lev+1)

% Now CONTINUE DOWN TO COARSER GRID, or SOLVE THE COARSEST SYSTEM (almost exactly).
% Use same smoother on coarser grid; ie, we SKIP a *4=(dx_fine / dx_coarse)^2 factor here.
if (lev<nlev-1);  Multigrid(lev+1);  else;  for i=1:20;  Smooth(nlev,m4);  end;  end 

% Now perform the PROLONGATION.  Trick #4 (fully implemented here for the m2=='c' case,
% partially implemented for the other two): Update black interior points only, as next call
% to Smooth recalculates all red points from scratch, so do not bother updating them here.
% We SKIP a /2 factor here (thus, we end up skipping a /2, *4, and /2, which all cancel).
if m3=='c'
  for ic=2:g{lev+1}.xm;  i=2*(ic-xo)+xo;  for jc=2:g{lev+1}.ym;  j=2*(jc-yo)+yo;         
    if j<g{lev}.ym, v{lev}(i-1,j) = v{lev}(i-1,j)+(v{lev+1}(ic-1,jc)+v{lev+1}(ic,jc)); end
    if i<g{lev}.xm, v{lev}(i,j-1) = v{lev}(i,j-1)+(v{lev+1}(ic,jc-1)+v{lev+1}(ic,jc)); end
  end; end
else  
  for ic=2:g{lev+1}.xm;  i=2*(ic-xo)+xo;  for jc=2:g{lev+1}.ym;  j=2*(jc-yo)+yo;  
    if j<g{lev}.ym, v{lev}(i-1,j) = v{lev}(i-1,j)+(v{lev+1}(ic-1,jc)+v{lev+1}(ic,jc)); if verbose>1, plot([ic-1/2],[jc],'gx'); end, end
    if i<g{lev}.xm, v{lev}(i,j-1) = v{lev}(i,j-1)+(v{lev+1}(ic,jc-1)+v{lev+1}(ic,jc)); if verbose>1, plot([ic],[jc-1/2],'gx'); end, end
    if (j<g{lev}.ym) & (i<g{lev}.xm), v{lev}(i,j)=v{lev}(i,j)+(v{lev+1}(ic,jc))*2.0;   if verbose>1, plot([ic],[jc],'bx');     end; end
  end; end
  if verbose>1; pause; end;
end;
EnforceBCs(lev)             

for i=1:N3; Smooth(lev,m3); end    % APPLY SMOOTHING STEPS AFTER COARSENING (N3 times)
% end function Multigrid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Smooth(lev,method);      
% Apply smoothing, with L from the Poisson equation normalized to unit diagonal elements.
% The set of points which we update first, which we label as "red", includes the corners.
global xo yo d v g verbose direction
xm=g{lev}.xm; ym=g{lev}.ym; xmm=xm-1; ymm=ym-1; xmp=xm+1; ymp=ym+1;
if verbose>1, figure(1); clf; axis([1 xm 1 ym]); hold on; end
if ym==3; 
  if verbose>1,  plot([2,xmm],[2 2],'r+-'); pause(.5); clf; pause(0.1); end
  if xm==3
     v{lev}(2,2)=(v{lev}(2,3) +v{lev}(2,1) +v{lev}(3,2)+v{lev}(1,2))*0.25+d{lev}(2,2);
  else
     v{lev}(2:xmm,2)=(v{lev}(2:xmm,3)+v{lev}(2:xmm,1))*0.25+d{lev}(2:xmm,2);
     v{lev}(2,2)=v{lev}(2,2)+v{lev}(1,2)*0.25;  v{lev}(xmm,2)=v{lev}(xmm,2)+v{lev}(xm,2)*0.25;
     v{lev}(2:xmm,2)=RC_ThomasTT(-0.25,1,-0.25,v{lev}(2:xmm,2),xm-2);
  end
  EnforceBCs(lev);
else; for irb=0:1;
  if verbose>1,  if irb==0, lsx='r+'; lsd='rx-'; else, lsx='k+'; lsd='kx-'; end; end
  
  if method=='c'                          % APPLY CHECKERBOARD SMOOTHING.
    for i=2:xmm;      
      m=2+mod(i+irb+xo+yo,2); n=ymm; mp=m+1; mm=m-1; np=n+1; nm=n-1; ip=i+1; im=i-1;
      v{lev}(i,m:2:n)=(v{lev}(i,mp:2:np) +v{lev}(i,mm:2:nm) +v{lev}(ip,m:2:n) ...
                      +v{lev}(im,m:2:n))*0.25+d{lev}(i,m:2:n);
    end;
    if verbose>1, for i=2:xmm; m=2+mod(i+irb+xo+yo,2); n=ymm; for j=m:2:n, plot(i,j,lsx);
    end; end; % e=fflush(1);
    pause(0.01); end;
    
  elseif method=='z'                      % APPLY ZEBRA SMOOTHING.
    if direction==0;  
      if YBC==1
        v{lev}(2+irb:2:xmm,2:ymm)=(v{lev}((2+irb:2:xmm)+1,2:ymm)+v{lev}((2+irb:2:xmm)-1,2:ymm))*0.25+d{lev}((2+irb:2:xmm),2:ymm);
        v{lev}(2+irb:2:xmm,2:ymm)=(RC_ThomasTT(-0.25,1,-0.25,(v{lev}(2+irb:2:xmm,2:ymm))',ym-2))';
      else
        % fix the boundary conditions on this!
        a=-0.25*ones(ymm); b=ones(ymm); c=a;
        v{lev}(2+irb:2:xmm,2:ymm)=(v{lev}((2+irb:2:xmm)+1,2:ymm)+v{lev}((2+irb:2:xmm)-1,2:ymm))*0.25+d{lev}((2+irb:2:xmm),2:ymm);
        v{lev}(2+irb:2:xmm,2:ymm)=(Thomas(a,b,c,(v{lev}(2+irb:2:xmm,2:ymm))',ymm-1))';
      end
      if verbose>1, for i=2+irb:2:xmm; plot([i i],[2 ymm],lsd); end; end;
    else
      if XBC==1
        v{lev}(2:xmm,2+irb:2:ymm)=(v{lev}(2:xmm,(2+irb:2:ymm)+1)+v{lev}(2:xmm,(2+irb:2:ymm)-1))*0.25+d{lev}(2:xmm,(2+irb:2:ymm))
        v{lev}(2:xmm,2+irb:2:ymm)=(RC_ThomasTT(-0.25,1,-0.25,v{lev}(2:xmm,2+irb:2:ymm),xmm-1)) ;
      else
        % fix the boundary conditions on this!
        a=-0.25*ones(ymm); b=ones(ymm); c=a;
        v{lev}(2:xmm,2+irb:2:ymm)=(v{lev}(2:xmm,(2+irb:2:ymm)+1)+v{lev}(2:xmm,(2+irb:2:ymm)-1))*0.25+d{lev}(2:xmm,(2+irb:2:ymm))
        v{lev}(2:xmm,2+irb:2:ymm)=(Thomas(a,b,c,v{lev}(2:xmm,2+irb:2:ymm),xmm-1)) ;
      end
      if verbose>1, for j=2+irb:2:ymm; plot([2 xmm],[j j],lsd); end; end;
    end;
    if verbose>1, e=fflush(1); pause(0.02*xmm); end;
    
  elseif method=='t'                      % APPLY TWEED SMOOTHING.
    if irb==0,
      if verbose>1, plot([2 2 xmm xmm],[2 ymm 2 ymm],lsx), end;
      v{lev}(2,2)    =(v{lev}(2,  3    ) +v{lev}(2,  1    ) +v{lev}(3,    2  )+v{lev}(1,    2  ))*0.25+d{lev}(2,  2  );
      v{lev}(xmm,2)  =(v{lev}(xmm,3    ) +v{lev}(xmm,1    ) +v{lev}(xmm+1,2  )+v{lev}(xmm-1,2  ))*0.25+d{lev}(xmm,2  );
      v{lev}(2,ymm)  =(v{lev}(2,  ymm+1) +v{lev}(2,  ymm-1) +v{lev}(3,    ymm)+v{lev}(1,    ymm))*0.25+d{lev}(2,  ymm);
      v{lev}(xmm,ymm)=(v{lev}(xmm,ymm+1) +v{lev}(xmm,ymm-1) +v{lev}(xmm+1,ymm)+v{lev}(xmm-1,ymm))*0.25+d{lev}(xmm,ymm);        
    end;
    for i=3+mod(irb+1,2):2:ymm/2
      if verbose>1, 
        plot([i     i     2  ],[2 i i],lsd);  plot([i     i     2  ],[ymm ymp-i ymp-i],lsd);
        plot([xmp-i xmp-i xmm],[2 i i],lsd);  plot([xmp-i xmp-i xmm],[ymm ymp-i ymp-i],lsd);
      end
      p=i-2+1; n=2; 
      A=-0.25*ones(p,n); B=1.0*ones(p,n); C=-0.25*ones(p,n);  % still a lot of work to do below.
      G(:,1,1)=(v{lev}(i-1,2:i-1)             +v{lev}(i+1,2:i-1)             )*0.25+d{lev}(i,2:i-1);
pause;
      G(:,2,1)=(v{lev}(2:i-1,i-1)             +v{lev}(2:i-1,i+1)             )*0.25+d{lev}(2:i-1,i);
      G(:,1,2)=(v{lev}(i-1,ymm:-1:ymp-i+1)    +v{lev}(i+1,ymm:-1:ymp-i+1)    )*0.25+d{lev}(i,ymm:-1:ymp-i+1);
      G(:,2,2)=(v{lev}(2:i-1,ymp-i-1)         +v{lev}(2:i-1,ymp-i+1)         )*0.25+d{lev}(2:i-1,ymp-i);
      G(:,1,3)=(v{lev}(xmp-i-1,2:i-1)         +v{lev}(xmp-i+1,2:i-1)         )*0.25+d{lev}(xmp-i,2:i-1);
      G(:,2,3)=(v{lev}(xmm:-1:xmp-i+1,i-1)    +v{lev}(xmm:-1:xmp-i+1,i+1)    )*0.25+d{lev}(xmm:-1:xmp-i+1,i);
      G(:,1,4)=(v{lev}(xmp-i-1,ymm:-1:ymp-i+1)   +v{lev}(xmp-i+1,ymm:-1:ymp-i+1)   )*0.25+d{lev}(xmp-i,ymm:-1:ymp-i+1);
      G(:,2,4)=(v{lev}(xmm:-1:xmp-i+1,ymp-i-1)+v{lev}(xmm:-1:xmp-i+1,ymp-i+1))*0.25+d{lev}(xmm:-1:xmp-i+1,ymp-i);
%      [G,e] = NLeggedThomas(A,B,C,G,d,e,2,p)
%      v{lev}(i,2:i-1)=G(:,1,1);
%      v{lev}(2:i-1,i)=G(:,2,1);
%      v{lev}(i,ymm:-1:ymp-i+1)=G(:,1,2);
%      v{lev}(2:i-1,ymp-i)=G(:,2,2);
%      v{lev}(xmp-i,2:i-1)=G(:,1,3);
%      v{lev}(xmm:-1:xmp-i+1,i)=G(:,2,3);
%      v{lev}(xmp-i,ymm:-1:ymp-i+1)=G(:,1,4);
%      v{lev}(xmm:-1:xmp-i+1,ymp-i)=G(:,2,4);

%        v{lev}(2,2)=v{lev}(2,2)+v{lev}(1,2)*0.25;  v{lev}(xmm,2)=v{lev}(xmm,2)+v{lev}(xm,2)*0.25;
%        v{lev}(2:xmm,2)=RC_ThomasTT(-0.25,1,-0.25,v{lev}(2:xmm,2),xm-2);

    end
    
%    pause;
    if irb==1, 
      if xm==ym,
        if verbose>1, plot([xmp/2 xmp/2],[2 ymm],lsd); plot([2 xmm],[ymp/2 ymp/2],lsd); end
      else
        if verbose>1, 
          plot([ymp/2 ymp/2],[2 ymm],  lsd); plot([xmp-ymp/2 xmp-ymp/2],[2 ymm],  lsd); 
          plot([2 ymp/2],[ymp/2 ymp/2],lsd); plot([xmp-2 xmp-ymp/2],[ymp/2 ymp/2],lsd);
        end
      end;
    end
    if verbose>1, for i=ymp/2+1+irb:2:xmp-ymp/2-1; plot([i i],[2 ymm],lsd); end; end
    if verbose>1, pause(1); end;
  end
  EnforceBCs(lev);
end; end
if method=='z', direction=mod(direction+1,2); end;
% end function Smooth
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function EnforceBCs(lev)
% Enforce the Neumann and/or periodic boundary conditions (nothing to do for Dirichlet)
global XBC YBC v g
i=g{lev}.xm-1; j=g{lev}.ym-1;
switch XBC case 3, v{lev}(1,        2:j)=v{lev}(3,          2:j);   % Note:  this is written specifically for the 'c' case for now (fix this).
                   v{lev}(g{lev}.xm,2:j)=v{lev}(g{lev}.xm-2,2:j);   % But we are working on Dirichlet for now anyway.
           case 2, v{lev}(1,        2:j)=v{lev}(g{lev}.xm-1,2:j);
                   v{lev}(g{lev}.xm,2:j)=v{lev}(2,          2:j); end
switch YBC case 3, v{lev}(2:i,1        )=v{lev}(2:i,3          );
                   v{lev}(2:i,g{lev}.ym)=v{lev}(2:i,g{lev}.ym-2);
           case 2, v{lev}(2:i,1        )=v{lev}(2:i,g{lev}.ym-1);
                   v{lev}(2:i,g{lev}.ym)=v{lev}(2:i,2          ); end
% end function EnforceBCs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function e = max_error(lev)
global d v g
% Compute the maximum error.
e=0.0; for i=2:g{1}.nx; for j=2:g{1}.ny
e=max(e,abs((v{1}(i+1,j)+v{1}(i-1,j)+v{1}(i,j+1)+v{1}(i,j-1))*0.25+d{1}(i,j)-v{1}(i,j)));
end; end;
% end function max_error