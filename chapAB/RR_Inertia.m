function inertia=RouthArray(p)
% function inertia=RouthArray(p)
% Finds the inertia of p=[p_n p_(n-1) ... p_0].  Algorithm due to G Meinsma (SCL, 1995).
% Numerical Renaissance codebase, Appendix B, https://github.com/tbewley/NR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 
i=find(abs(p)>1e-12,1); p(1:i-1)=[]; degree=length(p)-1; % strip off leading zeros
inertia=[0 0 0]; flag=0; show('Routh',degree,p(1:2:end))
for n=degree:-1:1 % Incrementally reduce the degree to 1
  k=find(abs(p(2:2:n+1))>1e-12,1); show('Routh',n-1,p(2:2:end))
  if length(k)==0, p(2:2:n+1)=p(1:2:n).*(n:-2:1); flag=1;
    if mod(n,2)==0, t='Even'; else, t='Odd'; end
    disp(['Case 3: ',t,' polynomial. Add its derivative.']), show('  NEW',n-1,p(2:2:end))
  elseif k>1, i=0:2:(n+1-2*k);
    if mod(k,2)==0, s=-1; t='Subtract'; else, s=1; t='Add'; end, p(i+2)=p(i+2)+s*p(i+2*k);
    disp(['Case 2: p_{n-1}=0. ',t,' s^',num2str(2*(k-1)),' times row ',num2str(n-1),'.'])
    show('  NEW',n-1,p(2:2:end))
  end
  eta=p(1)/p(2); if flag, inertia=inertia+[(eta<0) 0 (eta<0)];
                 else,    inertia=inertia+[(eta>0) 0 (eta<0)]; end
  p(3:2:n)=p(3:2:n)-eta*p(4:2:n+1); p(1)=[]; % Update p, strip off leading element
end
inertia=inertia+[0 degree-sum(inertia) 0];
end % function RouthArray
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function show(t,num,data); disp([t,' row ',num2str(num),':',sprintf(' %7.4g',data)]), end