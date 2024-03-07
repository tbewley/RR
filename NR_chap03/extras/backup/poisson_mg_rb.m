function RC_poisson_mg_rb
% A 2D Poisson solver on uniform mesh using Multigrid and Red/Black RC_Gauss-Seidel
% (Matlab syntax).  By Paolo Luchini and Thomas Bewley.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% USER INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Take g.xbc and g.ybc = 1 for homogeneous Dirichlet (grid:  0:nx   and  0:ny  ), 
%                      = 2 for homogeneous Neumann   (grid: -1:nx+1 and -1:ny+1), and
%                      = 3 for periodic              (grid: -1:nx   and -1:ny  ).
plots=1; g.nx=32; g.ny=32;  g.xbc=1;  g.ybc=1;
n1=2; n2=2; n3=2;     % # of rb iterations at various points (take each as 0, 1, or 2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END OF USER INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Grid: nx = %0.6g, ny = %0.6g  BCs: (%0.6g,%0.6g)\n',g.nx,g.ny,g.xbc,g.ybc),
switch g.xbc case 1, g.xo=1; g.xm=g.nx+1;           % Define offset and max grid variables
             case 2, g.xo=2; g.xm=g.nx+3;
             case 3, g.xo=2; g.xm=g.nx+2;  end
switch g.ybc case 1, g.yo=1; g.ym=g.ny+1;
             case 2, g.yo=2; g.ym=g.ny+3;
             case 3, g.yo=2; g.ym=g.ny+2;  end
v=zeros(g.xm,g.ym); d=v;                     % create a random rhs vector d with zero mean
di=rand(g.xm-4,g.ym-4); 
di=di-sum(sum(di))/((g.xm-4)*(g.ym-4)); d(3:g.xm-2,3:g.ym-2)=di;
% for i=3:g.xm-2; for j=3:g.ym-2; d(i,j)=sin((i+j)/10); end; end;
% i=sum(sum(d(:,:)))/((g.xm-4)*(g.ym-4));
% d(3:g.xm-2,3:g.ym-2)=d(3:g.xm-2,3:g.ym-2)-i;
e=max_error(v,d,g,0,2,0,0);
for smooth=1:n1, v=RC_poisson_rb(v,d,g); end                     % n1 iterations of smoothing
tic;
for main=1:150
  o=e; v=RC_poisson_rb(v,d,g); e=max_error(v,d,g,main,2,o,main);

%   o=e; v=RC_poisson_mg(v,d,g,n2,n3); e=max_error(v,d,g,main,plots,o);
%   fprintf('Iteration = %0.6g, error = %0.3e, factor = %0.4f\n',main,e,o/e)
%   if o/e==1, fprintf('Converged\n'), e=max_error(v,d,g,main,1,o);  break, end
end,
t=toc
fprintf('Total time = %0.4g sec for %0.6g iterations',t,main)
fprintf('-> time/iteration: %0.3g sec\n',t/main);        
e=max_error(v,d,g,main,1,o);
% end function RC_poisson_mg_rb
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function v = enforce_bcs(v,g);
% Enforce the Neumann and/or periodic boundary conditions (nothing to do for Dirichlet)
switch  g.xbc  case 2, m=g.ym-1; v(1,2:m)=v(3,     2:m); v(g.xm,2:m)=v(g.xm-2,2:m);
               case 3, m=g.ym-1; v(1,2:m)=v(g.xm-1,2:m); v(g.xm,2:m)=v(2,     2:m); end
switch  g.ybc  case 2, n=g.xm-1; v(2:n,1)=v(2:n,3     ); v(2:n,g.ym)=v(2:n,g.ym-2);
               case 3, n=g.xm-1; v(2:n,1)=v(2:n,g.ym-1); v(2:n,g.ym)=v(2:n,2     ); end     
% end function enforce_bcs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function vf = RC_poisson_mg(vf,df,gf,n2,n3)
% Apply Multigrid with Red/Black RC_Gauss-Seidel smoothing to the Poisson equation.
gc.nx=gf.nx/2;  gc.ny=gf.ny/2;  gc.xbc=gf.xbc;  gc.ybc=gf.ybc;        % Define coarse grid
switch gc.xbc case 1, gc.xm=gc.nx+1; gc.xo=1;
              case 2, gc.xm=gc.nx+3; gc.xo=2;
              case 3, gc.xm=gc.nx+2; gc.xo=2;  end
switch gc.ybc case 1, gc.ym=gc.ny+1; gc.yo=1;
              case 2, gc.ym=gc.ny+3; gc.yo=2;
              case 3, gc.ym=gc.ny+2; gc.yo=2;  end
% gf.xm, gf.ym, df, vf
for smooth=1:n2, vf=RC_poisson_rb(vf,df,gf); end          % n2 iterations of rb smoothing
vc=zeros(gc.xm,gc.ym);  dc=zeros(gc.xm,gc.ym);         % Initialize coarser grid variables
for ic=2:gc.xm-1                          % Calculate residual and perform the restriction      
   for jc=2:gc.ym-1                       % (using direct injection) in a single step.
      i=2*(ic-gc.xo)+gf.xo; j=2*(jc-gc.yo)+gf.yo; 
      dc(ic,jc)=((vf(i,j+1)+vf(i,j-1)+vf(i+1,j)+vf(i-1,j))*0.25-vf(i,j)+df(i,j));
      vc(ic,jc)=dc(ic,jc);       % Paolo's trick: this is a better guess than 0 to init vc
   end
end
% gc.xm, dc, vc, pause;
vc=enforce_bcs(vc,gc);
if gc.nx > 3 & gc.ny > 3 & mod(gf.nx,4)==0 & mod(gf.ny,4)==0 
   vc=RC_poisson_mg(vc,dc,gc,n2,n3);                 % Continue down to an even coarser grid,
else                                              % or
   for loop=1:20, vc=RC_poisson_rb(vc,dc,gc); end    % solve coarsest system (almost exactly)
end
for ic=2:gc.xm       % Prolongation (bilinear interpolation) on the black interior points.
   for jc=2:gc.ym    % Note: the next call to RC_poisson_rb will take care of the red points.
      i=2*(ic-gc.xo)+gf.xo; j=2*(jc-gc.yo)+gf.yo;
      if j<=gf.ym, vf(i-1,j)=vf(i-1,j)+(vc(ic-1,jc)+vc(ic,jc)); end
      if i<=gf.xm, vf(i,j-1)=vf(i,j-1)+(vc(ic,jc-1)+vc(ic,jc)); end
   end
end
vf=enforce_bcs(vf,gf);
for smooth=1:n3, vf=RC_poisson_rb(vf,df,gf); end                 % n3 iterations of smoothing
% end function RC_poisson_mg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function v = RC_poisson_rb(v,d,g);
% Apply Red/Black RC_Gauss-Seidel smoothing, with L derived from the Poisson equation
% (normalized s.t. the diagonal elements of L are 1) on the grid g, to Lv=d.
for rb=0:1,  for i=2:g.xm-1                  % update red points first, then black points.
   m=2+mod(i+rb+g.xo+g.yo,2); n=g.ym-1;
   mp=m+1; mm=m-1; np=n+1; nm=n-1; ip=i+1; im=i-1;
   v(i,m:2:n)=(v(i,mp:2:np)+v(i,mm:2:nm)+v(ip,m:2:n)+v(im,m:2:n))*0.25+d(i,m:2:n);
end, v=enforce_bcs(v,g); end
% end function RC_poisson_rb
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function e = max_error(v,d,g,main,plots,iter)
% Compute the maximum error and, if requested, plot both the solution and the error.
e=0;
for i=2:g.nx, for j=2:g.ny
   e=max(e,abs((v(i,j+1)+v(i,j-1)+v(i+1,j)+v(i-1,j))*0.25+d(i,j)-v(i,j)));
end, end
if plots>0,
   figure(1);  clf; surf(v(g.xo:g.xo+g.nx,g.yo:g.yo+g.ny)); 
   title(sprintf('Solution at iteration = %0.6g',main))
   for i=2:g.xm-1, for j=2:g.ym-1
      error(i,j)=((v(i,j+1)+v(i,j-1)+v(i+1,j)+v(i-1,j))*0.25+d(i,j)-v(i,j));
   end, end
   figure(2);  clf; surf(error(2:2:g.xm-1,2:2:g.ym-1));
   title(sprintf('Error at iteration = %0.6g',main))
   if plots>1, fn=['err' num2str(iter) '.eps'];  print('-depsc',fn); end
end
% end function max_error
