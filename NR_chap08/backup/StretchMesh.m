function x=StretchMesh(x,kind,xmin,xmax,c0,c1)
% function x=StretchMesh(x,kind,xmin,xmax,c0,c1)
% Strech a vector x distributed over [0,1] according to (8.11a) if kind='h', (8.11b) if
% kind='p', and (8.11c) if kind='c', then scale to cover the domain [xmin,xmax].
% For 'h' (hyperbolic tangent) stretching, small values of c0>0 make a more uniform mesh.
% For 'p' (polynomial) stretching, increasing c0,c1 increases clustering near xmin,xmax.
% For 'c' (cosine) stretching, we "correct" the orientation, so gridpoints increase in x.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 8.1.3.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap08">Chapter 8</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also PlotMesh.  Verify with: StretchMeshTest.

xint=xmax-xmin; switch kind
 case 'h', x=xmin+xint*(tanh(c0*(2*x-1))/tanh(c0)+1)/2;
 case 'c', x=xmin+xint*(1-cos(pi*x))/2;
 case 'p', conc=c0+10*c1; switch conc
     case 00,x=x;                               case 02,x=x.^3;
     case 10,x=-x.^2+2*x;                       case 12,x=-3*x.^4+4*x.^3;               
     case 20,x=x.^3-3*x.^2+3*x;                 case 22,x=6*x.^5-15*x.^4+10*x.^3; 
     case 30,x=-x.^4+4*x.^3-6*x.^2+4*x;         case 32,x=-10*x.^6+36*x.^5-45*x.^4+20*x.^3;   
     case 01,x=x.^2;                            case 03,x=x.^4;
     case 11,x=-2*x.^3+3*x.^2;                  case 13,x=-4*x.^5+5*x.^4;
     case 21,x=3*x.^4-8*x.^3+6*x.^2;            case 23,x=10*x.^6-24*x.^5+15*x.^4;
     case 31,x=-4*x.^5+15*x.^4-20*x.^3+10*x.^2; case 33,x=-20*x.^7+70*x.^6-84*x.^5+35*x.^4;
   end, x=xmin+xint*x;
end
end % function StretchMesh