function stationarity=NR_PolyStationarity(p)
% function stationarity=NR_PolyStationarity(p)
% Find the number of roots of the polynomial p(z) that are inside, on, and outside the
% unit circle, referred to as the stationarity of p(z), WITHOUT calculating the roots
% of the polynomial p(z).  Algorithm due to Bistritz (2002).
% INPUT:  p = vectors of coefficients of input polynomial p(z)
% OUTPUT: stationarity = vector quantifying number of roots [inside on outside] the unit circle   
% TEST:   p=NR_PolyConv([1 -0.5],[1 0 1],[1 0.77],[1 0.5],[1 -0.99]), NR_PolyStationarity(p);
%         check_roots_of_p=roots(p), magnitude_of_roots=abs(check_roots_of_p)
% Numerical Renaissance codebase, Appendix B, https://github.com/tbewley/NR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also PolyInertia for CT analog.

i=find(abs(p)>1e-12,1); p=p(i:end); z1roots=0;           % strip off leading zeros, remove
while abs(NR_PolyVal(p,1))<1e-12, p=NR_PolyDiv(p,[1 -1]); z1roots=z1roots+1; end  % roots at z=1
disp(['  Simplified p:',sprintf(' %7.4g',p)])
deg=length(p)-1; T2=p+p(end:-1:1); T1=NR_PolyDiv(p-p(end:-1:1),[1 -1]);
show('Bistritz',deg,T2), show('Bistritz',deg-1,T1), nu_n=0; nu_s=0; s=0;
for n=deg-1:-1:0
  if norm(T1,1)>1e-12,
    k=find(abs(T1)>1e-14,1)-1; d=T2(1)/T1(1+k);
    p=NR_PolyAdd(d*T1(1:end-k),d*[T1(1+k:end) zeros(1,k+1)],-T2); T0=p(2:n+1);
  elseif T2(1)==0,
    T0=-T2(2:n+1);
  else                                                                     % Singular case
    p=T2(1:n+1).*(n+1:-1:1); p=-p(end:-1:1); if (s==0), s=n+1; end
    T1=p+p(end:-1:1); T0=NR_PolyDiv(p-p(end:-1:1),[1 -1]); show('     NEW',n,T1)
  end
  eta=(NR_PolyVal(T2,1)+eps)/(NR_PolyVal(T1,1)+eps);  nu_n=nu_n+(eta<0);
  if (s>0), nu_s=nu_s+(eta<0); end,  if n>0, show('Bistritz',n-1,T0); T2=T1; T1=T0; end
end
pairs=s-nu_s; disp(['nu_n=',num2str(nu_n),' s=',num2str(s),' nu_s=',num2str(nu_s)])
a=deg-nu_n; b=2*nu_s-s; c=deg-a-b; stationarity=[a b+z1roots c], s='stable DT system';
if stationarity(3)>0 s=['un',s]; elseif stationarity(2)>0 s=['marginally ',s]; end
disp(s), if pairs>0, disp([num2str(pairs),' pair(s) of reciprocal roots']), end
end % function NR_PolyStationarity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function show(t,num,data); disp([t,' row ',num2str(num),':',sprintf(' %7.4g',data)]), end
