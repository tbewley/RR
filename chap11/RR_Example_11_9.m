function Example_18_9
close all; syms a4 a3 a2 a1 a0 b2 b1 b0; format long;

% Inspired Guess
figure(1); g.K=logspace(-1.0,1.5,3000); g.axes=[-3 4 -3.5 3.5];
RLocus([1 -2],PolyConv([1 -1],[1 -3]),-1.08*[1 -1.5],1,g);
% print -depsc PathPendGuess.eps

% Minimum-Energy Stabilizing Control
PolyConv([1 0 -10 0 9],[a1 a0])+PolyConv([1 0 -4],[b3 b2 b1 b0])
A=[0 0 0 1 0 1; 0 0 1 0 1 0; 0 1 0 -4 0 -10; 1 0 -4 0 -10 0; 0 -4 0 0 0 9; -4 0 0 0 9 0];
b=[0; 1; 8; 22; 24; 9]; x=A\b, x*15
%
figure(2); g.K=logspace(-1.0,1.2,6000); g.axes=[-10 4 -7 7];
RLocus(PolyConv([1 2],[1 -2]),PolyConv([1 -1],[1 -3]),-[1 -1.714],[1 2.018],g)
% print -depsc PathPendMESC.eps

% Minimum-Energy Stabilizing Control, modified to achieve strictly proper controller form
PolyAdd(PolyConv([1 0 -10 0 9],[a4 a3 a2 a1 a0]),PolyConv([1 0 -4],[b3 b2 b1 b0]))
A=[0 0 0 0 0 0  0  0 1; 0 0 0  0 0  0  0 1 0; 0 0  0 0  0  0 1 0 -10; 0  0 0 1 0 1 0 -10 0;
   0 0 1 0 1 0 -10 0 9; 0 1 0 -4 0 -10 0 9 0; 1 0 -4 0 -10 0 9 0  0 ; 0 -4 0 0 0 9 0  0  0;
  -4 0 0 0 9 0  0  0 0];
b=[1; 128; 6382; 153864; 1795689; 8986680; 20460600; 20412000; 7290000]; x=A\b, x*15
zpk(tf([61163576 146549888 -208926936 -294313248],[15 1920 95880 -58836416 -118655888]))
%
figure(3); g.K=logspace(-1.4,0.5, 9991); g.axes=[-150 150 -150 150];
RLocus(PolyConv([1 2],[1 -2]),PolyConv([1 -1],[1 -3],[1 1],[1 3]),
       [61163576 146549888 -208926936 -294313248],[15 1920 95880 -58836416 -118655888],g)
% print -depsc PathPendMESCproper.eps
%
figure(4); g.K=logspace(-1.1,2, 4000); g.axes=[-6 4 -5 5];
RLocus(PolyConv([1 2],[1 -2]),PolyConv([1 -1],[1 -3]),
       4077600*[1 -1.604],PolyConv([1 2.0104],[1 -115.6],[1 2*zeta*omegac omegac^2]),g)
% print -depsc PathPendMESCproper1.eps

end % function Example_18_9
