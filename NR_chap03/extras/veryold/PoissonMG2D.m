function PoissonMG2D
global N1 verbose
e=MaxDefect(0); if verbose>0, fprintf('Iter=0, max defect=%0.3e\n',e); end        
for i=1:N1; Smooth(1); end  % APPLY SMOOTHING STEPS BEFORE STARTING MULTIGRID (N1 times)
tic; for iter=1:10          % PERFORM UP TO 10 MULTIGRID CYCLES.
   o=e;  Multigrid(1); e = MaxDefect(iter);
   if verbose>0, fprintf('Iter=%0.6g, max defect=%0.3e, factor=%0.4f\n',iter,e,o/e); end
   if e<1E-14,   fprintf('Converged\n'), break, end
end; t=toc; 
fprintf('-> Total time: %0.3g sec; Time/iteration: %0.3g sec\n',t,t/iter);
% end function PoissonMG2D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Multigrid(q)
% The main recursive function for the multigrid algorithm. It calls the smoothing function,
% it performs the restriction and prolongation, and calls itself on the coarser grid.
global N2 N3 xo yo nq d v g verbose
for i=1:N2; Smooth(q); end     % APPLY SMOOTHING STEPS BEFORE COARSENING (N2 times)
% Now COMPUTE THE DEFECT and RESTRICT it to the coarser grid in a single step.  TRICK #1:
% we will SKIP several factors below, including a /2 factor here; however, all skipped
% factors cancel.  TRICK #2 we calculate the defect ONLY on the red points here, as the
% defect on the neighboring black points is zero coming out of the previous call to Smooth.
% Note: this is restriction with half weighting [see (3.13)].
d{q+1}=zeros(g{q+1}.xm,g{q+1}.ym);           
for ic=2:g{q+1}.xm-1; i=2*(ic-xo)+xo; for jc=2:g{q+1}.ym-1; j=2*(jc-yo)+yo;
  d{q+1}(ic,jc)=(v{q}(i+1,j)+v{q}(i-1,j)+v{q}(i,j+1)+v{q}(i,j-1))/4 -v{q}(i,j) +d{q}(i,j);             
end; end; 
v{q+1}=d{q+1};     % TRICK #3: this is a better initial guess for v{q+1} than v{q+1}=0.
EnforceBCs(q+1)
% Now CONTINUE DOWN TO COARSER GRID, or SOLVE THE COARSEST SYSTEM (via 20 smooth steps).
% We use same smoother on coarser grid; ie, we SKIP a *4 [i.e., *(delta x)^2] factor here.
if (q<nq-1);  Multigrid(q+1);  else;  for i=1:20;  Smooth(nq);  end;  end 
% Now perform the PROLONGATION.  TRICK #4: Update black interior points only, as next call
% to Smooth recalculates all red points from scratch, so do not bother updating them here.
% We SKIP a /2 factor here (thus, we end up skipping a /2, *4, and /2, which all cancel).
for ic=2:g{q+1}.xm;  i=2*(ic-xo)+xo;  for jc=2:g{q+1}.ym;  j=2*(jc-yo)+yo;         
    if j<g{q}.ym, v{q}(i-1,j) = v{q}(i-1,j)+(v{q+1}(ic-1,jc)+v{q+1}(ic,jc)); end
    if i<g{q}.xm, v{q}(i,j-1) = v{q}(i,j-1)+(v{q+1}(ic,jc-1)+v{q+1}(ic,jc)); end
end; end
EnforceBCs(q)             
for i=1:N3; Smooth(q); end    % APPLY SMOOTHING STEPS AFTER COARSENING (N3 times)
% end function Multigrid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Smooth(q);      
% Checkerboard smoothing with A from Poisson equation scaled to unit diagonal elements.
% The set of points updated first, which we label as "red", includes the corners.
global xo yo d v g verbose
xm=g{q}.xm; ym=g{q}.ym; xmm=xm-1; ymm=ym-1; xmp=xm+1; ymp=ym+1;
if verbose>1, figure(1); clf; axis([1 xm 1 ym]); hold on; end
for irb=0:1;
  if verbose>1,  if irb==0, lsx='r+'; else, lsx='k+'; end; end
  for i=2:xmm;      
    m=2+mod(i+irb+xo+yo,2);  v{q}(i,m:2:ymm)=d{q}(i,m:2:ymm) ...
    + (v{q}(i,m+1:2:ymm+1)+v{q}(i,m-1:2:ymm-1)+v{q}(i+1,m:2:ymm)+v{q}(i-1,m:2:ymm))/4;
  end;
  if verbose>1, for i=2:xmm; m=2+mod(i+irb+xo+yo,2); n=ymm; for j=m:2:n,
    plot(i,j,lsx); end; end; e=fflush(1); pause(0.01); end;
  EnforceBCs(q);
end;
% end function Smooth
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function EnforceBCs(q)
% Enforce the Neumann and/or periodic boundary conditions (nothing to do for Dirichlet)
global XBC YBC v g
i=g{q}.xm-1; j=g{q}.ym-1;
switch XBC case 3, v{q}(1,2:j)=v{q}(3,2:j);         v{q}(g{q}.xm,2:j)=v{q}(g{q}.xm-2,2:j);
           case 2, v{q}(1,2:j)=v{q}(g{q}.xm-1,2:j); v{q}(g{q}.xm,2:j)=v{q}(2,2:j); end
switch YBC case 3, v{q}(2:i,1)=v{q}(2:i,3);         v{q}(2:i,g{q}.ym)=v{q}(2:i,g{q}.ym-2);
           case 2, v{q}(2:i,1)=v{q}(2:i,g{q}.ym-1); v{q}(2:i,g{q}.ym)=v{q}(2:i,2); end
% end function EnforceBCs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function e = MaxDefect(iter)
global d v g verbose xo yo
e=0.0; for i=2:g{1}.nx; for j=2:g{1}.ny             % Compute the maximum defect.
  defect(i,j)=((v{1}(i+1,j)+v{1}(i-1,j)+v{1}(i,j+1)+v{1}(i,j-1))/4 -v{1}(i,j) +d{1}(i,j));
  e=max(e,abs(defect(i,j)));
end; end;
if verbose>1, 
  figure(2); clf; contour(defect(xo:2:g{1}.nx,yo:2:g{1}.ny));
  title(sprintf('Defect at iteration = %0.6g',iter));
  if verbose>2, fn=['err' num2str(iter) '.eps'];  print('-depsc',fn); end
  figure(3); clf; surf(v{1}(xo:g{1}.nx,yo:g{1}.ny));
  title(sprintf('Solution at iteration = %0.6g',iter)); fflush(1); pause(0.01);
end
% end function MaxDefect
