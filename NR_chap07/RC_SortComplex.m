function [D,index]=RC_SortComplex(D,Trait,Alg) 
% function [D,index]=RC_SortComplex(D,Trait,Alg)
% Sort a matrix D based on the 'absolute value' or 'real part' (specified by Trait) of the
% complex elements in its first column, using 'RC_QuickSort', etc (specified by Alg).
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% Test with <a href="matlab:help PartialFractionExpansionTest">RC_SortComplexTest</a>.

if nargin<3, Alg=str2func('RC_QuickSort'); if nargin<2, Trait='real part'; end, end
switch Trait, case 'absolute value', D=[abs(D) D]; case 'real part', D=[real(D) D]; end
n=length(D); if nargout>1, [D,index]=Alg(D,0,n); else, D=Alg(D,0,n); end, D=D(:,2:end);
end % function RC_SortComplex
