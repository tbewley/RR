function [c]=RC_TaylorTable(x,w) 
% function [c]=RC_TaylorTable(x,w) 
% Given x locations and w= which derivative, compute the corresponding FD expression.
% UNIFORM GRID TESTS ( h = spacing of gridpoints )
% TEST1:  syms h real; x=h*[-1 0],        w=1, [c]=RC_TaylorTable(x,w)', den=h,      num=c*den
% TEST2:  syms h real; x=h*[-1 0 1],      w=1, [c]=RC_TaylorTable(x,w)', den=2*h,    num=c*den
% TEST3:  syms h real; x=h*[-1 0 1],      w=2, [c]=RC_TaylorTable(x,w)', den=h^2,    num=c*den
% TEST4:  syms h real; x=h*[-2 -1 0 1 2], w=1, [c]=RC_TaylorTable(x,w)', den=12*h,   num=c*den
% TEST5:  syms h real; x=h*[-2 -1 0 1 2], w=2, [c]=RC_TaylorTable(x,w)', den=12*h^2, num=c*den
% TEST6:  syms h real; x=h*[0 1 2],       w=1, [c]=RC_TaylorTable(x,w)', den=2*h,    num=c*den
% STRETCHED GRID TESTS ( gridpoint locations: ... -xmm -xm 0 xp xpp ... )
% TEST2s: syms xm xp real; x=[-xm 0 xp], w=1, [c]=simplify(RC_TaylorTable(x,w)'), den=xm+xp,  num=c*den
%         c_uniform_case=subs(c,{xm,xp},[h,h])  % Gives same result as TEST2
% TEST3s: syms xm xp real; x=[-xm 0 xp], w=2, [c]=simplify(RC_TaylorTable(x,w)'), den=xm*xp,  num=c*den
%         c_uniform_case=subs(c,{xm,xp},[h,h])  % Gives same result as TEST3
% TEST4s: syms xmm xm xp xpp real; x=[-xmm -xm 0 xp xpp]; w=1; [c]=simplify(RC_TaylorTable(x,w)')
%         c_uniform_case=subs(c,{xmm,xm,xp,xpp},[2*h,h,h,2*h])  % Gives same result as TEST4
% TEST5s: syms xmm xm xp xpp real; x=[-xmm -xm 0 xp xpp]; w=2; [c]=simplify(RC_TaylorTable(x,w)')
%         c_uniform_case=subs(c,{xmm,xm,xp,xpp},[2*h,h,h,2*h])  % Gives same result as TEST5
% TEST6s: syms xp xpp real; x=[0 xp xpp]; w=1; [c]=simplify(RC_TaylorTable(x,w)')
%         c_uniform_case=subs(c,{xp,xpp},[h,2*h])  % Gives same result as TEST6

% Renaissance Codebase, https://github.com/tbewley/RC/NRchap08
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% Verify with: <a href="matlab:help RC_TaylorTableTest">TaylorTableTest</a>.

n=length(x); for i=1:n; for j=1:n; A(i,j)=x(j)^(i-1)/factorial(i-1); end; end
b=zeros(n,1); b(w+1)=1; c=A\b; 
end % function RC_TaylorTable
