function PoissonMG2dInit(NX,NY)
% This initialization routine must be called before calling PoissonMG2d.
global XBC YBC N1 N2 N3 xo yo nlev d v g verbose direction m1 m2 m3 m4
switch XBC case 1, xo=1; case 2, xo=2; case 3, xo=2; end
switch YBC case 1, yo=1; case 2, yo=2; case 3, yo=2; end
nlev=log2(min([NX,NY]));
for lev=1:nlev
   g{lev}.nx = NX/(2^(lev-1)); g{lev}.ny = NY/(2^(lev-1));
   g{lev}.xm=g{lev}.nx+XBC; g{lev}.ym=g{lev}.ny+YBC;
   v{lev} = zeros(g{lev}.xm,g{lev}.ym);   d{lev}=v{lev};
   fprintf('%5g%5g%5g\n',lev,g{lev}.nx,g{lev}.ny)
end
% end function PoissonMG2dInit