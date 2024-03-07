function RC_poisson_mg_rb_3d
% A 3D Poisson solver on uniform mesh using Multigrid and Red/Black RC_Gauss-Seidel.
% By Thomas Bewley, Anish Karandikar, and Paolo Luchini.
global XBC YBC ZBC N1 N2 N3 xo yo zo nlev d v g
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% USER INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% XBC=1 for hom. Dirichlet (0:NX), =2 for periodic (-1:NX), =3 for hom. Neumann (-1:NX+1).
% Similar for YBC, ZBC. NX, NY, NZ must be powers of two. N1, N2, N3 should be 1, 2, or 3.
NX=16; NY=32; NZ=16; XBC=3; YBC=3; ZBC=3; N1=3; N2=3; N3=2; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END OF USER INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('BCs:%2g,%2g,%2g.  Smoothing:%2g,%2g,%2g.  Grids:\n',XBC,YBC,ZBC,N1,N2,N3)
switch XBC case 1, xo=1; case 2, xo=2; case 3, xo=2; end
switch YBC case 1, yo=1; case 2, yo=2; case 3, yo=2; end
switch ZBC case 1, zo=1; case 2, zo=2; case 3, zo=2; end
nlev=log2(min([NX,NY,NZ]));
for lev=1:nlev
   g{lev}.nx = NX/(2^(lev-1)); g{lev}.ny = NY/(2^(lev-1)); g{lev}.nz = NZ/(2^(lev-1));
   g{lev}.xm=g{lev}.nx+XBC; g{lev}.ym=g{lev}.ny+YBC; g{lev}.zm=g{lev}.nz+ZBC;
   v{lev} = zeros(g{lev}.xm,g{lev}.ym,g{lev}.zm);  d{lev}=v{lev};
   fprintf('%5g%5g%5g%5g\n',lev,g{lev}.nx,g{lev}.ny,g{lev}.nz)
end
d{1}(3:g{1}.xm-2,3:g{1}.ym-2,3:g{1}.zm-2)=rand(g{1}.xm-4,g{1}.ym-4,g{1}.zm-4);
i=sum(sum(sum(d{1}(:,:,:))))/((g{1}.xm-4)*(g{1}.ym-4)*(g{1}.zm-4))+0.0001;
d{1}(3:g{1}.xm-2,3:g{1}.ym-2,3:g{1}.zm-2)=d{1}(3:g{1}.xm-2,3:g{1}.ym-2,3:g{1}.zm-2)-i;
e=max_error(1); fprintf('Iteration =  0, error = %0.3e\n',e)                                     
for i=1:N1; RC_poisson_rb(1); end
tic;
for iter=1:10 
   o=e;  RC_poisson_mg(1); e = max_error(1);
   fprintf('Iteration = %0.6g, error = %0.3e, factor = %0.4f\n',iter,e,o/e)
   if e<1E-14, fprintf('Converged\n'), break, end
end 
t=toc
fprintf('Total time = %0.4g sec for %0.6g iterations',t,iter)
fprintf('-> time/iteration: %0.3g sec\n',t/iter);
% end function RC_poisson_mg_rb_3d
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function enforce_bcs(lev)
global XBC YBC ZBC N1 N2 N3 xo yo zo nlev d v g
% Enforce the Neumann and/or periodic boundary conditions (nothing to do for Dirichlet)
i=g{lev}.xm-1; j=g{lev}.ym-1; k=g{lev}.zm-1; 
switch XBC case 3, v{lev}(1,        2:j,2:k)=v{lev}(3,          2:j,2:k);
                   v{lev}(g{lev}.xm,2:j,2:k)=v{lev}(g{lev}.xm-2,2:j,2:k);
           case 2, v{lev}(1,        2:j,2:k)=v{lev}(g{lev}.xm-1,2:j,2:k);
                   v{lev}(g{lev}.xm,2:j,2:k)=v{lev}(2,          2:j,2:k); end
switch YBC case 3, v{lev}(2:i,1,        2:k)=v{lev}(2:i,3,          2:k);
                   v{lev}(2:i,g{lev}.ym,2:k)=v{lev}(2:i,g{lev}.ym-2,2:k);
           case 2, v{lev}(2:i,1,        2:k)=v{lev}(2:i,g{lev}.ym-1,2:k);
                   v{lev}(2:i,g{lev}.ym,2:k)=v{lev}(2:i,2,          2:k); end
switch ZBC case 3, v{lev}(2:i,2:j,1        )=v{lev}(2:i,2:j,3          );
                   v{lev}(2:i,2:j,g{lev}.zm)=v{lev}(2:i,2:j,g{lev}.zm-2);
           case 2, v{lev}(2:i,2:j,1        )=v{lev}(2:i,2:j,g{lev}.zm-1);
                   v{lev}(2:i,2:j,g{lev}.zm)=v{lev}(2:i,2:j,2          ); end
% end function enforce_bcs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function RC_poisson_mg(lev)
global XBC YBC ZBC N1 N2 N3 xo yo zo nlev d v g
for i=1:N2; RC_poisson_rb(lev); end 
for ic=2:g{lev+1}.xm-1; for jc=2:g{lev+1}.ym-1; for kc=2:g{lev+1}.zm-1; % Compute residual
   i=2*(ic-xo)+xo; j=2*(jc-yo)+yo; k=2*(kc-zo)+zo;          % and restrict to coarser grid
   d{lev+1}(ic,jc,kc)=(v{lev}(i+1,j,k)+v{lev}(i-1,j,k)+v{lev}(i,j+1,k)+v{lev}(i,j-1,k)...
                      +v{lev}(i,j,k+1)+v{lev}(i,j,k-1))/6.d0-v{lev}(i,j,k)+d{lev}(i,j,k);                                  
end; end; end
v{lev+1}=d{lev+1};  enforce_bcs(lev)
if (lev<nlev-1),   RC_poisson_mg(lev+1)       % Continue to even coarser grid, or
else, for i=1:20;  RC_poisson_rb(nlev); end   % solve coarsest system (almost exactly)
end
for ic=2:g{lev+1}.xm; for jc=2:g{lev+1}.ym; for kc=2:g{lev+1}.zm; % Prolongation (using
   i=2*(ic-xo)+xo; j=2*(jc-yo)+yo; k=2*(kc-zo)+zo;            % bilinear interpolation)
   if ((j<=g{lev}.ym) & (k<=g{lev}.zm))                     % on black interior points
      v{lev}(i-1,j,k) = v{lev}(i-1,j,k)+(v{lev+1}(ic-1,jc,kc)+v{lev+1}(ic,jc,kc));
   end
   if ((i<=g{lev}.xm) & (k<=g{lev}.zm))
      v{lev}(i,j-1,k) = v{lev}(i,j-1,k)+(v{lev+1}(ic,jc-1,kc)+v{lev+1}(ic,jc,kc));
   end
   if ((i<=g{lev}.xm) & (j<=g{lev}.ym)),
      v{lev}(i,j,k-1) = v{lev}(i,j,k-1)+(v{lev+1}(ic,jc,kc-1)+v{lev+1}(ic,jc,kc));
   end
   v{lev}(i-1,j-1,k-1)=v{lev}(i-1,j-1,k-1)+(v{lev+1}(ic,jc,kc)+v{lev+1}(ic-1,jc,kc)...
         +v{lev+1}(ic,jc-1,kc)  +v{lev+1}(ic-1,jc-1,kc)+v{lev+1}(ic,jc,kc-1)...
         +v{lev+1}(ic-1,jc,kc-1)+v{lev+1}(ic,jc-1,kc-1)+v{lev+1}(ic-1,jc-1,kc-1))*0.25;
end; end; end    % Note that the next call to RC_poisson_rb takes care of red points
enforce_bcs(lev)
for i=1:N3; RC_poisson_rb(lev); end
% end function RC_poisson_mg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function RC_poisson_rb(lev);              % Apply Red/Black RC_Gauss-Seidel, with L from Poisson
global XBC YBC ZBC N1 N2 N3 xo yo zo nlev d v g
for irb=0:1; for i=2:g{lev}.xm-1; for j=2:g{lev}.ym-1       % update red first, then black
m=2+mod(i+j+irb+xo+yo+zo,2); n=g{lev}.zm-1;
mp=m+1; mm=m-1; np=n+1; nm=n-1; jp=j+1; jm=j-1; ip=i+1; im=i-1;
v{lev}(i,j,m:2:n)=(v{lev}(i,j,mp:2:np) +v{lev}(i,j,mm:2:nm) +v{lev}(ip,j,m:2:n) ...
     +v{lev}(im,j,m:2:n) +v{lev}(i,jp,m:2:n) +v{lev}(i,jm,m:2:n))/6.d0+d{lev}(i,j,m:2:n);
     if i==2 & j==2; v{lev}(i,j,2)=0; end;
end; end; enforce_bcs(lev); end
% end function RC_poisson_rb
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function e = max_error(lev)
global XBC YBC ZBC N1 N2 N3 xo yo zo nlev d v g
% Compute the maximum error and, if requested, plot both the solution and the error.
e = 0.0; for k=2:g{1}.nz; for j=2:g{1}.ny; for i=2:g{1}.nx
e = max(e,abs((v{1}(i+1,j,k)+v{1}(i-1,j,k)+v{1}(i,j+1,k)+v{1}(i,j-1,k) ...
              +v{1}(i,j,k-1)+v{1}(i,j,k+1))/6.d0 +d{1}(i,j,k) -v{1}(i,j,k)));
end; end; end
% end function max_error