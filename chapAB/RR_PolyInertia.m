function inertia=NR_PolyInertia(p)
% function inertia=NR_PolyInertia(p)
% Find the number of roots of the polynomial p(s) that are in the LHP, on the imaginary
% axis, and in the RHP, referred to as the inertia of p(s), WITHOUT calculating the roots
% of the polynomial p(s).  Algorithm due to Routh (1895).
% INPUT:  p = vectors of coefficients of input polynomial
% OUTPUT: inertia = vector quantifying number of [LHP pure-imaginary RHP] roots 
% TEST:   p=NR_PolyConv([1 2.3],[1 1.7],[1 0 1],[1 0.99]), NR_PolyInertia(p);
%         check_roots_of_p=roots(p)
% Numerical Renaissance codebase, Appendix B, https://github.com/tbewley/NR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also PolyStationarity for DT analog.

i=find(abs(p)>1e-12,1); p=p(i:end); degree=length(p)-1;          % strip off leading zeros
inertia=[0 0 0]; flag=0; show('Routh',degree,p(1:2:end))
for n=degree:-1:1
  k=find(abs(p(2:2:n+1))>1e-14,1); show('Routh',n-1,p(2:2:end))  % Similar implementation
  if length(k)==0, flag=1;                                       % in Meinsma (SCL, 1995)
    if mod(n,2)==0, t='Even'; else, t='Odd'; end
    disp(['Case 3: ',t,' polynomial. Add its derivative.'])
    p(2:2:n+1)=p(1:2:n).*(n:-2:1); show('  NEW',n-1,p(2:2:end))
  elseif k>1
    if mod(k,2)==0, s=-1; t='Subtract'; else, s=1; t='Add'; end
    disp(['Case 2: p_{n-1}=0. ',t,' s^',num2str(2*(k-1)),' times row ',num2str(n-1),'.'])
    i=0:2:(n+1-2*k); p(i+2)=p(i+2)+s*p(i+2*k); show('  NEW',n-1,p(2:2:end))
  end
  eta=p(1)/p(2); if flag, inertia=inertia+[(eta<0) 0 (eta<0)];
                 else,    inertia=inertia+[(eta>0) 0 (eta<0)]; end
  p(3:2:n)=p(3:2:n)-eta*p(4:2:n+1); p=p(2:n+1);      % Update p, strip off leading element
end
inertia=inertia+[0 degree-sum(inertia) 0], s='stable CT system';
if inertia(3)>0 s=['un',s]; elseif inertia(2)>0 s=['marginally ',s]; end, disp(s)
end % function NR_PolyInertia
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function show(t,num,data); disp([t,' row ',num2str(num),':',sprintf(' %7.4g',data)]), end
