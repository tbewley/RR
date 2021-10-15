% script <a href="C2DzohTest">C2DzohTest</a>
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 18.1.5.2.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap18">Chapter 18</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.
% See also C2DTustinTest.

disp('Perform exact conversion of a D/A–G(s)–A/D cascade to discrete time,')
disp('assuming G(s)=b(s)/a(s) and the D/A incorporates a zoh.')

bs=[1], as=[1 2 1], h=.1;  [bz,az]=C2Dzoh(bs,as,h), disp(' ')
disp('Now compare to routine built into Matlab'), c2d(tf(bs,as),h,'zoh'), disp(' ')

bs=[1], as=[1 6 5], h=.1;  [bz,az]=C2Dzoh(bs,as,h), disp(' ')
disp('Now compare to routine built into Matlab'), c2d(tf(bs,as),h,'zoh'), disp(' ')



% end script C2DzohTest