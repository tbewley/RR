function RC_NonlinearMG2DTest                           % Numerical Renaissance Codebase 1.0
% Solve (11.62a) on a uniform mesh using nonlinear multigrid with N-R r/b G-S smoothing.
% The RHS vector is assumed to be scaled such that the discretized Laplace operator has a
% 1 on the diagonal element.  This code was formed by modification of PoissonMG2DTest.m,
% to which the reader is referred for extensive comments; only the significant
% modifications for extension to the nonlinear case are marked with comments here;
% see especially those four points indicated by comment *** NOTE ***.
clear; global XBC YBC N1 N2 N3 xo yo d v x g nlev alpha betabar verbose
% -------------------------------------- USER INPUT --------------------------------------
NX=32; NY=32; XBC=1; YBC=1; N1=5; N2=3; N3=3; alpha=0.1, beta=0.5
% ----------------------------------- END OF USER INPUT ----------------------------------
fprintf('BCs:%2g,%2g. Smoothing:%2g,%2g,%2g.\nGrids:\n',XBC,YBC,N1,N2,N3);
for verbose=1:2
  RC_NonlinearMG2DInit(NX,NY), for l=1:nlev, betabar(l)=-beta/(4*g{l}.nx^2); end            
  d{1}(3:g{1}.xm-2,3:g{1}.ym-2)=rand(g{1}.xm-4,g{1}.ym-4);
  i=sum(sum(d{1}(:,:)))/((g{1}.xm-4)*(g{1}.ym-4));
  d{1}(3:g{1}.xm-2,3:g{1}.ym-2)=d{1}(3:g{1}.xm-2,3:g{1}.ym-2)-i;
  RC_NonlinearMG2D;
end
end % function RC_NonlinearMG2DTest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function RC_NonlinearMG2DInit(NX,NY)
global XBC YBC xo yo d v x g nlev
switch XBC case 1, xo=1; case 2, xo=2; case 3, xo=2; end
switch YBC case 1, yo=1; case 2, yo=2; case 3, yo=2; end
nlev=log2(NY);
for l=1:nlev
   g{l}.nx = NX/(2^(l-1)); g{l}.ny = NY/(2^(l-1)); 
   g{l}.xm=g{l}.nx+XBC; g{l}.ym=g{l}.ny+YBC;       
   v{l}=zeros(g{l}.xm,g{l}.ym); d{l}=v{l}; x{l}=v{l};   % initialize x=solution
   fprintf('%5g%5g%5g\n',l,g{l}.nx,g{l}.ny)
end 
end % function RC_NonlinearMG2DInit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function RC_NonlinearMG2D
global N1 verbose
e=MaxDefect(0); fprintf('Iter=0, max defect=%0.3e\n',e);
for i=1:N1; Smooth(1); e = MaxDefect(i); end
tic; for iter=1:20   % Do up to 20 multigrid cycles (convergence slower than linear case).
   o=e;  Multigrid(1); e = MaxDefect(iter);
   if verbose>0, fprintf('Iter=%0.6g, max defect=%0.3e, factor=%0.4f\n',iter,e,o/e); end
   if e<1E-13,   fprintf('Converged\n'), break, end
end; t=toc;
fprintf('-> Total time: %0.3g sec; Time/iteration: %0.3g sec\n',t,t/iter);
end % function RC_NonlinearMG2D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Multigrid(l)
global N2 N3 xo yo d v x g nlev alpha betabar
for i=1:N2; Smooth(l); end
d{l+1}=zeros(g{l+1}.xm,g{l+1}.ym);  x{l+1}=d{l+1};  
for ic=2:g{l+1}.xm-1; i=2*(ic-xo)+xo; for jc=2:g{l+1}.ym-1; j=2*(jc-yo)+yo;
% Compute and restrict d in a single step.                                    *** NOTE ***
d{l+1}(ic,jc)=(v{l}(i+1,j)+v{l}(i-1,j)+v{l}(i,j+1)+v{l}(i,j-1))/4-v{l}(i,j)+d{l}(i,j)  ...
  +((v{l}(i+1,j)-v{l}(i-1,j))^2+2*(x{l}(i+1,j)-x{l}(i-1,j))*(v{l}(i+1,j)-v{l}(i-1,j))  ...
   +(v{l}(i,j+1)-v{l}(i,j-1))^2+2*(x{l}(i,j+1)-x{l}(i,j-1))*(v{l}(i,j+1)-v{l}(i,j-1))  ...
   )*alpha/16 + betabar(l)*(v{l}(i,j)^2 + 2*v{l}(i,j)*x{l}(i,j));
% Restrict x as well.                                                         *** NOTE ***
x{l+1}(ic,jc)=(x{l}(i,j)+v{l}(i,j))/2+(x{l}(i+1,j)+x{l}(i-1,j)+x{l}(i,j+1)+x{l}(i,j-1) ...
                                      +v{l}(i+1,j)+v{l}(i-1,j)+v{l}(i,j+1)+v{l}(i,j-1))/8;
end; end;
v{l+1}=d{l+1};
EnforceBCs(l+1)
if (l<nlev-1);  Multigrid(l+1);  else;  for i=1:20;  Smooth(nlev);  end;  end 
for ic=2:g{l+1}.xm;  i=2*(ic-xo)+xo;  for jc=2:g{l+1}.ym;  j=2*(jc-yo)+yo;         
    if j<g{l}.ym, v{l}(i-1,j) = v{l}(i-1,j)+(v{l+1}(ic-1,jc)+v{l+1}(ic,jc)); end
    if i<g{l}.xm, v{l}(i,j-1) = v{l}(i,j-1)+(v{l+1}(ic,jc-1)+v{l+1}(ic,jc)); end
end; end
EnforceBCs(l)             
for i=1:N3; Smooth(l); end
end % function Multigrid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Smooth(l);      
global xo yo d v x g alpha betabar verbose
xm=g{l}.xm; ym=g{l}.ym; xmm=xm-1; ymm=ym-1; xmp=xm+1; ymp=ym+1;
if verbose>1, figure(1); clf; axis([1 xm 1 ym]); hold on; end
for irb=0:1;
  for i=2:xmm; m=2+mod(i+irb+xo+yo,2);  
% Apply Newton-Raphson red/black RC_Gauss-Seidel smoothing.                      *** NOTE ***
v{l}(i,m:2:ymm)=v{l}(i,m:2:ymm)-(v{l}(i,m:2:ymm)-d{l}(i,m:2:ymm)                       ... 
-(v{l}(i,m+1:2:ymm+1)+v{l}(i,m-1:2:ymm-1)+v{l}(i+1,m:2:ymm)+v{l}(i-1,m:2:ymm))/4       ...
-((v{l}(i,m+1:2:ymm+1)-v{l}(i,m-1:2:ymm-1)).^2+(v{l}(i+1,m:2:ymm)-v{l}(i-1,m:2:ymm)).^2...
+2*(x{l}(i,m+1:2:ymm+1)-x{l}(i,m-1:2:ymm-1)).*(v{l}(i,m+1:2:ymm+1)-v{l}(i,m-1:2:ymm-1))...
+2*(x{l}(i+1,m:2:ymm)-x{l}(i-1,m:2:ymm)).*(v{l}(i+1,m:2:ymm)-v{l}(i-1,m:2:ymm))        ...
    )*alpha/16-betabar(l)*(v{l}(i,m:2:ymm).^2 + 2*v{l}(i,m:2:ymm).*x{l}(i,m:2:ymm)))./ ...
                          (1+betabar(l)*(2*v{l}(i,m:2:ymm)+2*x{l}(i,m:2:ymm)));
  end
  if verbose>1, if irb==0, lsx='r+'; else, lsx='k+'; end;
    for i=2:xmm; m=2+mod(i+irb+xo+yo,2); for j=m:2:ymm, plot(i,j,lsx); end; end;
  pause(0.01); end; EnforceBCs(l);
end;
end % function Smooth
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function EnforceBCs(l)
global XBC YBC v g
i=g{l}.xm-1; j=g{l}.ym-1;
switch XBC case 3, v{l}(1,2:j)=v{l}(3,2:j);         v{l}(g{l}.xm,2:j)=v{l}(g{l}.xm-2,2:j);
           case 2, v{l}(1,2:j)=v{l}(g{l}.xm-1,2:j); v{l}(g{l}.xm,2:j)=v{l}(2,2:j); end
switch YBC case 3, v{l}(2:i,1)=v{l}(2:i,3);         v{l}(2:i,g{l}.ym)=v{l}(2:i,g{l}.ym-2);
           case 2, v{l}(2:i,1)=v{l}(2:i,g{l}.ym-1); v{l}(2:i,g{l}.ym)=v{l}(2:i,2); end
end % function EnforceBCs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function e = MaxDefect(iter)
global xo yo d v x g alpha betabar verbose
e=0.0; for i=2:g{1}.nx; for j=2:g{1}.ny
% Compute defect                                                              *** NOTE ***
  def(i,j)=-v{1}(i,j)-x{1}(i,j) +d{1}(i,j) + (v{1}(i+1,j)+x{1}(i+1,j)                  ... 
           +v{1}(i-1,j)+x{1}(i-1,j)+v{1}(i,j+1)+x{1}(i,j+1)+v{1}(i,j-1)+x{1}(i,j-1))/4 ...
           + ( (v{1}(i+1,j)+x{1}(i+1,j)-v{1}(i-1,j)-x{1}(i-1,j))^2                     ...
              +(v{1}(i,j+1)+x{1}(i,j+1)-v{1}(i,j-1)-x{1}(i,j-1))^2)*alpha/16           ...
		     + betabar(1)*(v{1}(i,j)^2);
  e=max(e,abs(def(i,j)));
end; end;
if verbose>1,
  figure(2); clf; surf(def(xo:2:g{1}.nx,yo:2:g{1}.ny));
  title(sprintf('Defect at iteration = %0.6g',iter));
  if verbose>2, fn=['err' num2str(iter) '.eps'];  print('-depsc',fn); end
  figure(3); clf; surf(x{1}(xo:g{1}.nx,yo:g{1}.ny)+v{1}(xo:g{1}.nx,yo:g{1}.ny));
  title(sprintf('Solution at iteration = %0.6g',iter)); pause(0.01);
end
end % function MaxDefect
