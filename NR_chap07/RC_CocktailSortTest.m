% script <a href="matlab:RC_CocktailSortTest">RC_CocktailSortTest</a>
% Test <a href="matlab:help RC_CocktailSort">RC_CocktailSort</a> on slightly out-of-order data.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

n=99; n1=(n+1)/2; D=0.85*([1:n]'-n1)/n1+0.15*(2*rand(n,1)-1); D([1 n])=D([n 1]);
close all, plot(D(:,1),'x'), pause(0.5), [D,index]=RC_CocktailSort(D,1,n); plot(D(:,1),'x')

% end script RC_CocktailSortTest
