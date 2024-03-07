function [x]=RC_Chebyshev(n,x,derivative,kind)
% function [x]=Chebyshev(n,x,derivative,kind)
% Compute the Chebyshev polynomial of the 1st kind, T, and its 1st & 2nd derivatives, as
% well as the Chebyshev polynomial of the 2nd kind, U, and its derivative (see Wikipedia).
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.13.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help ChebyshevTest">ChebyshevTest</a>.

if nargin<4, kind=1; if nargin<3, derivative=0; end, end
switch kind
  case 1, switch derivative
    case 0, T(1)=1; T(2)=x; for j=3:n+1, T(j)=2*x*T(j-1)-T(j-2); end, x=T(n+1);
    case 1, x=n*RC_Chebyshev(n-1,x,0,2);
    case 2, switch x
       case  1, x=(n^4-n^2)/3;
       case -1, x=(-1)^n*(n^4-n^2)/3;
       otherwise, x=n*((n+1)*RC_Chebyshev(n,x,0,1)-RC_Chebyshev(n,x,0,2))/(x^2-1); end
    otherwise, x=0; disp('Case not yet implemented'); end
  case 2, switch derivative
    case 0, U(1)=1; U(2)=2*x; for j=3:n+1, U(j)=2*x*U(j-1)-U(j-2); end, x=U(n+1);
    case 1, x=((n+1)*RC_Chebyshev(n+1,x,0,1)-x*RC_Chebyshev(n,x,0,2))/(s^2-1);
    otherwise, x=0; disp('Case not yet implemented'); end
end
end % function Chebyshev
