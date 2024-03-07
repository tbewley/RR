function PoissonMG2DTest                             % Numerical Renaissance Codebase 1.0
% A 2D Poisson solver on a uniform mesh using multigrid with red/black smoothing.  The RHS
% vector is assumed to be scaled such that the discretized Laplace operator has a 1 on the
% diagonal element.
clear; global XBC YBC N1 N2 N3 xo yo d v g verbose
% -------------------------------------- USER INPUT --------------------------------------
% XBC=1 for hom. Dirichlet (0:NX), =2 for periodic (-1:NX), =3 for hom. Neumann (-1:NX+1).
% Same for YBC. NX, NY must be powers of two with NX>=NY. N1,N2,N3 set how much smoothing
NX=32; NY=32; XBC=2; YBC=3; N1=2; N2=2; N3=2;               % is applied at various steps.
% ----------------------------------- END OF USER INPUT ----------------------------------
fprintf('BCs:%2g,%2g. Smoothing:%2g,%2g,%2g.\nGrids:\n',XBC,YBC,N1,N2,N3);
for verbose=1:2
  PoissonMG2DInit(NX,NY);                                  % The RHS vector b is stored in
  d{1}(3:g{1}.xm-2,3:g{1}.ym-2)=rand(g{1}.xm-4,g{1}.ym-4); % the initial value of -d [see 
  i=sum(sum(d{1}(:,:)))/((g{1}.xm-4)*(g{1}.ym-4));         % (3.8a)], here taken as a zero
  d{1}(3:g{1}.xm-2,3:g{1}.ym-2)=d{1}(3:g{1}.xm-2,3:g{1}.ym-2)-i; % mean random number.
  PoissonMG2D; pause;
end
end % function PoissonMG2DTest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PoissonMG2DInit(NX,NY)
% This initialization routine allocates several global arrays to avoid the repeated
% memory allocation/deallocation otherwise caused by recursion.  Note that d and v are
% defined as cell arrays, which are of different size at each level l.
global XBC YBC xo yo nlev d v g
switch XBC case 1, xo=1; case 2, xo=2; case 3, xo=2; end
switch YBC case 1, yo=1; case 2, yo=2; case 3, yo=2; end
nlev=log2(NY);
for l=1:nlev
   g{l}.nx = NX/(2^(l-1)); g{l}.ny = NY/(2^(l-1)); % The g data structure contains
   g{l}.xm=g{l}.nx+XBC; g{l}.ym=g{l}.ny+YBC;       % information about the grids.
   v{l} = zeros(g{l}.xm,g{l}.ym);   d{l}=v{l};     % d=defect, v=correction.
   fprintf('%5g%5g%5g\n',l,g{l}.nx,g{l}.ny)
end
end % function PoissonMG2DInit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PoissonMG2D
global N1 verbose
e=MaxDefect(0); fprintf('Iter=0, max defect=%0.3e\n',e);     
for i=1:N1; Smooth(1); end  % APPLY SMOOTHING STEPS BEFORE STARTING MULTIGRID (N1 times)
tic; for iter=1:10          % PERFORM UP TO 10 MULTIGRID CYCLES.
   o=e;  Multigrid(1); e = MaxDefect(iter);
   if verbose>0, fprintf('Iter=%0.6g, max defect=%0.3e, factor=%0.4f\n',iter,e,o/e); end
   if e<1E-13,   fprintf('Converged\n'), break, end
end; t=toc; 
fprintf('-> Total time: %0.3g sec; Time/iteration: %0.3g sec\n',t,t/iter);
end % function PoissonMG2D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Multigrid(l)
% The main recursive function for the multigrid algorithm. It calls the smoothing function,
% it performs the restriction and prolongation, and calls itself on the coarser grid.
global N2 N3 xo yo nlev d v g verbose
for i=1:N2; Smooth(l); end     % APPLY SMOOTHING STEPS BEFORE COARSENING (N2 times)
% Now COMPUTE THE DEFECT and RESTRICT it to the coarser grid in a single step. 
% TRICK #1 we calculate the defect ONLY on the red points here, as the defect on the
% neighboring black points is zero coming out of the previous call to Smooth.
% TRICK #2: We skip a factor of /2 during the restriction here. We also skip factors of
% *4 during the smoothing and /2 during the prolongation, so the skipped factors cancel.
d{l+1}=zeros(g{l+1}.xm,g{l+1}.ym);           
for ic=2:g{l+1}.xm-1; i=2*(ic-xo)+xo; for jc=2:g{l+1}.ym-1; j=2*(jc-yo)+yo;
  d{l+1}(ic,jc)=(v{l}(i+1,j)+v{l}(i-1,j)+v{l}(i,j+1)+v{l}(i,j-1))/4 -v{l}(i,j) +d{l}(i,j);             
end; end; 
v{l+1}=d{l+1};     % TRICK #3: this is a better initial guess for v{l+1} than v{l+1}=0.
EnforceBCs(l+1)
% Now CONTINUE DOWN TO COARSER GRID, or SOLVE THE COARSEST SYSTEM (via 20 smooth steps).
% Use same smoother on coarse grid; ie, we SKIP a *4 [i.e., *(delta x)^2] factor (TRICK 2).
if (l<nlev-1);  Multigrid(l+1);  else;  for i=1:20;  Smooth(nlev);  end;  end 
% Now perform the PROLONGATION.  TRICK #4: Update black interior points only, as next call
% to Smooth recalculates all red points from scratch, so do not bother updating them here.
% We SKIP a /2 interpolation factor here (Trick 2).
for ic=2:g{l+1}.xm;  i=2*(ic-xo)+xo;  for jc=2:g{l+1}.ym;  j=2*(jc-yo)+yo;         
    if j<g{l}.ym, v{l}(i-1,j) = v{l}(i-1,j)+(v{l+1}(ic-1,jc)+v{l+1}(ic,jc)); end
    if i<g{l}.xm, v{l}(i,j-1) = v{l}(i,j-1)+(v{l+1}(ic,jc-1)+v{l+1}(ic,jc)); end
end; end
EnforceBCs(l)             
for i=1:N3; Smooth(l); end    % APPLY SMOOTHING STEPS AFTER COARSENING (N3 times)
end % function Multigrid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Smooth(l);      
% Checkerboard smoothing with A from Poisson equation scaled to unit diagonal elements.
% The set of points updated first, which we label as "red", includes the corners.
global xo yo d v g verbose
xm=g{l}.xm; ym=g{l}.ym; xmm=xm-1; ymm=ym-1; xmp=xm+1; ymp=ym+1;
if verbose>1, figure(1); clf; axis([1 xm 1 ym]); hold on; end
for irb=0:1;
  for i=2:xmm;      
    m=2+mod(i+irb+xo+yo,2);  v{l}(i,m:2:ymm)=d{l}(i,m:2:ymm) ...
    + (v{l}(i,m+1:2:ymm+1)+v{l}(i,m-1:2:ymm-1)+v{l}(i+1,m:2:ymm)+v{l}(i-1,m:2:ymm))/4;
  end;                                    % In matlab, inner loop should be on LAST index.
  if verbose>1, if irb==0, lsx='r+'; else, lsx='k+'; end;
    for i=2:xmm; m=2+mod(i+irb+xo+yo,2); for j=m:2:ymm, plot(i,j,lsx); end; end;
    pause(0.01); end;  % add fflush(1); before the pause if running octave!
  EnforceBCs(l);
end;
end % function Smooth
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function EnforceBCs(l)
% Enforce the Neumann and periodic boundary conditions (nothing to do for Dirichlet)
global XBC YBC v g
i=g{l}.xm-1; j=g{l}.ym-1;
switch XBC case 3, v{l}(1,2:j)=v{l}(3,2:j);         v{l}(g{l}.xm,2:j)=v{l}(g{l}.xm-2,2:j);
           case 2, v{l}(1,2:j)=v{l}(g{l}.xm-1,2:j); v{l}(g{l}.xm,2:j)=v{l}(2,2:j); end
switch YBC case 3, v{l}(2:i,1)=v{l}(2:i,3);         v{l}(2:i,g{l}.ym)=v{l}(2:i,g{l}.ym-2);
           case 2, v{l}(2:i,1)=v{l}(2:i,g{l}.ym-1); v{l}(2:i,g{l}.ym)=v{l}(2:i,2); end
end % function EnforceBCs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function e = MaxDefect(iter)
global d v g verbose xo yo
e=0.0; for i=2:g{1}.nx; for j=2:g{1}.ny                    % Compute the maximum defect.
  defect(i,j)=((v{1}(i+1,j)+v{1}(i-1,j)+v{1}(i,j+1)+v{1}(i,j-1))/4 -v{1}(i,j) +d{1}(i,j));
  e=max(e,abs(defect(i,j)));
end; end;
if verbose>1,                                              % Make some illustrative plots.
  figure(2); clf; contour(defect(xo:2:g{1}.nx,yo:2:g{1}.ny));
  title(sprintf('Defect at iter = %0.6g',iter));
  if verbose>2, fn=['err' num2str(iter) '.eps'];  print('-depsc',fn); end
  figure(3); clf; surf(v{1}(xo:g{1}.nx,yo:g{1}.ny));
  title(sprintf('Solution at iter = %0.6g',iter)); pause(0.01); % add fflush(1); in octave
end
end % function MaxDefect
