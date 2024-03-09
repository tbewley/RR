function Smooth(lev);      
% Checkerboard smoothing with L from Poisson equation normalized to unit diagonal elements.
% The set of points updated first, which we label as "red", includes the corners.
global xo yo d v g verbose
xm=g{lev}.xm; ym=g{lev}.ym; xmm=xm-1; ymm=ym-1; xmp=xm+1; ymp=ym+1;
if verbose>1, figure(1); clf; axis([1 xm 1 ym]); hold on; end
for irb=0:1;
  if verbose>1,  if irb==0, lsx='r+'; lsd='r'; else, lsx='k+'; lsd='k'; end; end
    for i=2:xmm;      
      m=2+mod(i+irb+xo+yo,2); n=ymm; mp=m+1; mm=m-1; np=n+1; nm=n-1; ip=i+1; im=i-1;
      v{lev}(i,m:2:n)=(v{lev}(i,mp:2:np) +v{lev}(i,mm:2:nm) +v{lev}(ip,m:2:n) ...
                      +v{lev}(im,m:2:n))*0.25+d{lev}(i,m:2:n);
    end;
    if verbose>1, for i=2:xmm; m=2+mod(i+irb+xo+yo,2); n=ymm; for j=m:2:n, plot(i,j,lsx);
    end; end; e=fflush(1); pause(0.01); end;
end;
% end function Smooth

