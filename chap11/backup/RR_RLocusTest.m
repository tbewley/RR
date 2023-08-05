% script <a href="matlab:RLocusTest">RLocusTest</a>
% Test <a href="matlab:help RLocus">RLocus</a> on several examples (NR Figures 18.2-18.4).
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 18.1.1.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap18">Chapter 18</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.

close all
figure(1), g.K=logspace(-2,3,200);   g.axes=[-2.5 .5 -1.5 1.5]; RLocus([1 4 4],[1 0 1],1,1,g)
figure(2), g.K=logspace(-1.8,2,600); g.axes=[-7 1 -4 4];        RLocus([1 2],[1 0 0],1,1,g)
figure(3), g.K=logspace(-1.8,2,400); g.axes=[-3 1 -2 2];        RLocus([2],[1 2 0],1,1,g)

c=2; g.K=logspace(-2,2,400); g.axes=[-2.2 .2 -1.2 1.2];
figure(4), RLocus([1 c],[c 0],1,1,g)
figure(5), RLocus(1,[1 0],1,1,g)

g.K=logspace(-3.5,3.5,400); g.axes=[-2.2 .2 -1.2 1.2];
figure(6), RLocus([1 2*c c^2],[c 0 0],1,1,g)
figure(7), RLocus(1,[1 0 0],1,1,g)

g.K=logspace(-3.5,4,400); g.axes=[-3 1 -2 2]; 
figure(8), RLocus([1 3*c 3*c^2 c^3],[c 0 0 0],1,1,g)
figure(9), RLocus(1,[1 0 0 0],1,1,g)

g.K=logspace(-2,2,700); g.axes=[-12 2 -5 5]; 
figure(10), RLocus([1 .3],[1 12 20 0 0],15,1,g)
figure(11), RLocus([1 .2],[1 12 20 0 0],15,1,g)

% end script RLocusTest
