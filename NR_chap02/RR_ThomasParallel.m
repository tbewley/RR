function [g] = RC_ThomasParallel(a,b,c,g,n,p)
% function [g] = RC_ThomasParallel(a,b,c,g,n,p)
% This function solves AX=g for X using the parallel Thomas algorithm on p proessors.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% Verify with <a href="matlab:help RC_ThomasParallelTest">RC_ThomasParallelTest</a>.

a=distributed(a); b=distributed(b); c=distributed(c); g=distributed(g); % Move data to labs

spmd % --------------------------- THIS BLOCK DONE IN PARALLEL ---------------------------
  aa=getLocalPart(a); bb=getLocalPart(b); cc=getLocalPart(c); gg=getLocalPart(g); 
  jm=length(aa);
  for j=1:jm-1                          % PARALLEL FORWARD SWEEPS
    mult     = -aa(j+1)/bb(j);
    bb(j+1)  = bb(j+1) + mult*cc(j);        
    gg(j+1)  = gg(j+1) + mult*gg(j);
    if labindex>1, aa(j+1) = mult*aa(j); else, aa(j+1) = 0; end
  end
  for j=jm-1:-1:2                       % PARALLEL BACKWARD SWEEPS
    mult     = -cc(j-1)/bb(j);  
    aa(j-1)  = aa(j-1) + mult*aa(j);        
    cc(j-1)  =           mult*cc(j);
    gg(j-1)  = gg(j-1) + mult*gg(j);
  end
  afirst=aa(1); bfirst=bb(1); cfirst=cc(1); gfirst=gg(1); % Make select data available
  alast=aa(jm); blast=bb(jm); clast=cc(jm); glast=gg(jm); % to the client
end % ------------------------------------------------------------------------------------

% Now set up and solve the tridiagonal problem that relates the p labs.
% Note: the notation alast{k} denotes data that is actually still resident on the labs,
% whereas the notation aaa(k) sets up a regular vector on the client, to be used by Thomas.
for k=2:p                               % One extra step of the last p-1 backward sweeps.
  mult      = -clast{k-1}/bfirst{k};  
  aaa(k-1,1)= alast{k-1};
  bbb(k-1,1)= blast{k-1} + mult*afirst{k};        
  ccc(k-1,1)=              mult*cfirst{k};
  ggg(k-1,1)= glast{k-1} + mult*gfirst{k};
end
aaa(p,1)=alast{p}; bbb(p,1)=blast{p}; ccc(p,1)=0; ggg(p,1)=glast{p};
ggg=Thomas(aaa,bbb,ccc,ggg,p);

spmd % --------------------------- THIS BLOCK DONE IN PARALLEL ---------------------------
  gg(jm)=ggg(labindex);
  for j = jm-1:-1:1                     % PARALLEL BACK SURC_BSTITUTIONS
    if labindex>1, gg(j) = (gg(j)-aa(j)*ggg(labindex-1)-cc(j)*gg(jm))/bb(j);
    else,          gg(j) = (gg(j)                      -cc(j)*gg(jm))/bb(j); end
  end
end % ------------------------------------------------------------------------------------

g=[]; for k=1:p, g=[g; gg{k}]; end      % Accumulate result to return from function.
end % function RC_ThomasParallel
