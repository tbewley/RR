function [ab,Jb]=Brent(ComputeJ,aa,ab,ac,Ja,Jb,Jc,tol,x,p,params,verbose) 
% Numerical Renaissance Codebase 1.0 (based on Brent implementation in Numerical Recipes)
% INPUT: {aa,ab,ac} bracket the alpha that minimizes ComputeJ(x+alpha*p).
% OUTPUT: alpha=ab locally minimizes J(x+alpha*p), with accuarcy tol*abs(ab) and value Jb.
% For convenience, anything lumped into params is just passed along to the ComputeJ fn.
aInc=0; al=min(ac,aa); ar=max(ac,aa);
if (abs(ab-aa) > abs(ac-ab)); [aa,ac]=Swap(aa,ac); [Ja,Jc]=Swap(Ja,Jc); end;
for iter=1:50
  if iter<3, aInt=2*(ar-al); end, tol1=tol*abs(ab)+1E-25; tol2=2*tol1; flag=0; % Initialize
  am=(al+ar)/2; if (ar-al)/2+abs(ab-am)<tol2, if nargin==12, inner_iterations=iter, end; return, end % Check convergence
  if (abs(aInt)>tol1 | iter<3)
    % Perform a parabolic fit based on points {aa,ab,ac} [see (15.2)]
    T=(ab-aa)*(Jb-Jc); D=(ab-ac)*(Jb-Ja); N=(ab-ac)*D-(ab-aa)*T; D=2*(T-D); 
    if D<0.; N=-N; D=-D; end; T=aInt; aInt=aInc;
    if (abs(N)<abs(D*T/2) & N>D*(al-ab) & N<D*(ar-ab)) % aInc=N/D within reasonable range?
      aInc=N/D; an=ab+aInc; flag=1;                    % Success! aInc is new increment.
      if (an-al<tol2 | ar-an<tol2); aInc=abs(tol1)*sign(am-ab); end  % Fix if an near ends
    end
  end
  % If parabolic fit unsuccessful, do a golden section step based on bracket {al,ab,ar}
  if flag==0; if ab>am; aInt=al-ab; else; aInt=ar-ab; end; aInc=0.381966*aInt; end
  if abs(aInc)>tol1; an=ab+aInc; else; an=ab+abs(tol1)*sign(aInc); end
  Jn=ComputeJ(x+an*p,params);
  if Jn<=Jb                                   % Keep 6 (not necessarily distinct) points
    if an>ab; al=ab; else; ar=ab; end         % defining the interval from one iteration
    ac=aa; Jc=Ja; aa=ab; Ja=Jb; ab=an; Jb=Jn; % to the next:
  else                                        % {al,ab,ar} bracket the minimum
    if an<ab; al=an; else; ar=an; end         % ab=Lowest point, most recent if tied w/ aa
    if (Jn<=Ja | aa==ab)                      % aa=Second-to-lowest point.
      ac=aa; Jc=Ja; aa=an; Ja=Jn;             % ac=Third-to-lowest point
    elseif (Jn<=Jc | ac==ab | ac==aa)         % an=Newest point
      ac=an; Jc=Jn;                           % Parabolic fit based on {aa,ab,ac}
    end                                       % Golden section search based on {al,ab,ar}
  end
  if nargin==12, disp(sprintf('%d %d %g %g %g %g %g %g %g %g %g %g %g',iter,al,ab,ar,Jb)); end
end
end % function Brent