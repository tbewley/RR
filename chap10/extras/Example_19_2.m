% script <a href="matlab:Example_19_2">Example_19_2</a>
% Symbolically perform the algebra of Example 19.2.
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Example 19.2.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap19">Chapter 19</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.

clear; syms R4;   V0=5; R1=1e3; R2=1e3; R3=1e3; R5=1e5;
A=[1 -1 0 -1 0 0 0 0; 0 1 -1 0 0 -1 0 0; 0 0 0 1 -1 1 0 0; 0 R1 0 0 0 0 1 0;  ...
   0 0 0 R3 0 0 0 1; 0 0 0 0 0 R5 -1 1; 0 0 R2 0 0 0 -1 0; 0 0 0 0 R4 0 0 -1];
b=[0; 0; 0; V0; V0; 0; 0; 0];  x=A\b

clear; syms C4 s V0;   R1=1e3; R2=1e3; C3=1e-5; R5=1e5;
A=[1 -1 0 -1 0 0 0 0; 0 1 -1 0 0 -1 0 0; 0 0 0 1 -1 1 0 0; 0 R1 0 0 0 0 1 0;  ...
   0 0 0 1 0 0 0 C3*s; 0 0 0 0 0 R5 -1 1; 0 0 R2 0 0 0 -1 0; 0 0 0 0 1 0 0 -C4*s];
b=[0; 0; 0; V0; C3*s*V0; 0; 0; 0];  x=A\b

% end script Example_19_2
