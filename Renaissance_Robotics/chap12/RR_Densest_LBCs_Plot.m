% script RR_Densest_LBCs_Plot
% This code plots Figure 7.3 in Renaissance Robotics.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 12)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

clear; close all; h=figure(1); hold on; ko=0; 
axis([0 log2(64) 0.18 1.0]), grid

% single parity check:  n,n-1,2  (2,1,2  3,2,2  4,3,2  5,4,2  6,5,2  ...)      
plotshortened(65,64,63,0,0,'k.','k-','k-.','k.',1);

% hamming: (3,1,3  7,4,3  15,11,3  31,26,3  63,57,3  127,120,3)
[no,ko]=plotshortened(7,4,2,0,0,'r.','r-','r-.','r.',0);
[no,ko]=plotshortened(15,11,6,0,0,'r.','r-','r-.','r.',0);
[no,ko]=plotshortened(31,26,14,0,0,'r.','r-','r-.','r.',0);
[no,ko]=plotshortened(63,57,30,0,0,'r.','r-','r-.','r.',0);
[no,ko]=plotshortened(127,120,62,0,0,'r.','r-','r-.','r.',0);

% extended hamming: (4,1,4  8,4,4  16,11,4  32,26,4  64,57,4  128,120,4)  
[no,ko]=plotshortened(8,4,2,0,0,'r.','r-','r-.','r.',1);
[no,ko]=plotshortened(16,11,6,0,0,'r.','r-','r-.','r.',1);
[no,ko]=plotshortened(32,26,14,0,0,'r.','r-','r-.','r.',1);
[no,ko]=plotshortened(64,57,30,0,0,'r.','r-','r-.','r.',1);
[no,ko]=plotshortened(128,120,62,0,0,'r.','r-','r-.','r.',1);

% quadratic residue
[no,ko]=plotshortened(17,9,4,0,0,'b.','b-','b-.','b.',0);     % d=5
[no,ko]=plotshortened(23,12,6,0,0,'m.','m-','m-.','m.',0);    % d=7
% [no,ko]=plotshortened(31,16,3,0,0,'m.','m-','m-.','m.',0);  % d=7
[no,ko]=plotshortened(41,21,4,0,0,'g.','g-','g-.','g.',0);    % d=9
[no,ko]=plotshortened(47,24,10,0,0,'c.','c-','c-.','c.',0);   % d=11

% extended quadratic residue (includes self-dual)
[no,ko]=plotshortened(18,9,4,0,0,'b.','b-','b-.','b.',1);     % d=6
        plotshortened(24,12,2,0,0,'b.','b-','','b.',3);       % d=7-8
[no,ko]=plotshortened(24,12,6,0,0,'m.','m-','m-.','m.',1);    % d=8
% [no,ko]=plotshortened(32,16,3,0,0,'m.','m-','m-.','m.',1);  % d=8
[no,ko]=plotshortened(42,21,4,0,0,'g.','g-','g-.','g.',1);    % d=10
        plotshortened(48,24,2,0,0,'g.','g-','','g.',3);       % d=9-10
[no,ko]=plotshortened(48,24,10,0,0,'c.','c-','c-.','c.',1);   % d=12

% 57,29,?        58,29,?
% 71,36,         72,36,
% 73,37,         74,37,
% 89,45,         90,45,
% 97,49,         98,49,
% 103,52,        104,52,
% 113,57,        114,57,
% 127,64,15      128,64,16

% biorthogonal: (16,5,8  32,6,16  64,7,32  128,8,64  256,9,128) includes simplex
plotshortened(16,5,0,0,0,'b.','b-','','b.',3);             % d=6-5
[no,ko]=plotshortened(15,5,2,0,0,'m.','m-','m-.','m.',0);  % d=7
[no,ko]=plotshortened(16,5,2,0,0,'m.','m-','m-.','m.',1);  % d=8

% other
plotshortened(9,2,0,0,0,'b.','b-','','b.',1);     % d=5-6
plotshortened(11,4,1,0,0,'b.','b-','','b.',0);    % d=5
plotshortened(12,4,1,0,0,'b.','b-','','b.',1);    % d=6
plotshortened(23,14,4,0,0,'b.','b-','','b.',0);   % d=5
plotshortened(24,14,4,0,0,'b.','b-','','b.',1);   % d=6
plotshortened(33,23,8,0,0,'b.','b-','','b.',0);   % d=5
plotshortened(34,23,8,0,0,'b.','b-','','b.',1);   % d=6
plotshortened(47,36,12,0,0,'b.','b-','','b.',0);   % d=5
plotshortened(48,36,12,0,0,'b.','b-','','b.',1);   % d=6
plotshortened(65,53,16,0,0,'b.','b-','','b.',0);   % d=5
plotshortened(66,53,16,0,0,'b.','b-','','b.',1);   % d=6
plotshortened(77,64,10,0,0,'b.','b-','','b.',0);   % d=5
plotshortened(78,64,10,0,0,'b.','b-','','b.',1);   % d=6

plotshortened(27,14,1,0,0,'m.','m-','','m.',0);   % d=7
plotshortened(28,14,1,0,0,'m.','m-','','m.',1);   % d=8
plotshortened(31,17,2,0,0,'m.','m-','','m.',0);   % d=7
plotshortened(32,17,2,0,0,'m.','m-','','m.',1);   % d=8
plotshortened(37,22,4,0,0,'m.','m-','','m.',0);   % d=7
plotshortened(38,22,4,0,0,'m.','m-','','m.',1);   % d=8
plotshortened(47,31,8,0,0,'m.','m-','','m.',0);   % d=7
plotshortened(48,31,8,0,0,'m.','m-','','m.',1);   % d=8
plotshortened(63,46,14,0,0,'m.','m-','','m.',0);   % d=7
plotshortened(64,46,14,0,0,'m.','m-','','m.',1);   % d=8
plotshortened(68,50,3,0,0,'m.','m-','','m.',0);   % d=7
plotshortened(69,50,3,0,0,'m.','m-','','m.',1);   % d=8
plotshortened(83,64,13,0,0,'m.','m-','','m.',0);   % d=7
plotshortened(84,64,13,0,0,'m.','m-','','m.',1);   % d=8

plotshortened(20,5,1,0,0,'g.','g-','','g.',0);    % d=9
plotshortened(21,5,1,0,0,'g.','g-','','g.',1);    % d=10
plotshortened(23,7,1,0,0,'g.','g-','','g.',0);    % d=9
plotshortened(24,7,1,0,0,'g.','g-','','g.',1);    % d=10
plotshortened(27,10,2,0,0,'g.','g-','','g.',0);   % d=9
plotshortened(28,10,2,0,0,'g.','g-','','g.',1);   % d=10
plotshortened(31,13,2,0,0,'g.','g-','','g.',0);   % d=9
plotshortened(32,13,2,0,0,'g.','g-','','g.',1);   % d=10
plotshortened(35,16,2,0,0,'g.','g-','','g.',0);   % d=9
plotshortened(36,16,2,0,0,'g.','g-','','g.',1);   % d=10
plotshortened(45,24,2,0,0,'g.','g-','','g.',0);   % d=9
plotshortened(46,24,2,0,0,'g.','g-','','g.',1);   % d=10
plotshortened(49,27,2,0,0,'g.','g-','','g.',0);   % d=9
plotshortened(50,27,2,0,0,'g.','g-','','g.',1);   % d=10
plotshortened(54,31,3,0,0,'g.','g-','','g.',0);   % d=9
plotshortened(55,31,3,0,0,'g.','g-','','g.',1);   % d=10
plotshortened(64,40,8,0,0,'g.','g-','','g.',0);   % d=9
plotshortened(65,40,8,0,0,'g.','g-','','g.',1);   % d=10
plotshortened(72,47,6,0,0,'g.','g-','','g.',0);   % d=9
plotshortened(73,47,6,0,0,'g.','g-','','g.',1);   % d=10
plotshortened(77,51,3,0,0,'g.','g-','','g.',0);   % d=9
plotshortened(78,51,3,0,0,'g.','g-','','g.',1);   % d=10
plotshortened(91,64,12,0,0,'g.','g-','','g.',0);   % d=9
plotshortened(92,64,12,0,0,'g.','g-','','g.',1);   % d=10

plotshortened(24,5,0,0,0,'c.','c-','','c.',1);   % d=12
plotshortened(26,7,1,0,0,'c.','c-','','c.',0);   % d=11
plotshortened(27,7,1,0,0,'c.','c-','','c.',1);   % d=12
plotshortened(31,11,3,0,0,'c.','c-','','c.',0);   % d=11
plotshortened(32,11,3,0,0,'c.','c-','','c.',1);   % d=12
plotshortened(34,12,0,0,0,'c.','c-','','c.',1);   % d=12
plotshortened(36,13,0,0,0,'c.','c-','','c.',1);   % d=12
plotshortened(52,25,0,0,0,'c.','c-','','c.',1);   % d=12
plotshortened(63,36,10,0,0,'c.','c-','','c.',0);   % d=11
plotshortened(64,36,10,0,0,'c.','c-','','c.',1);   % d=12
plotshortened(69,41,4,0,0,'c.','c-','','c.',0);   % d=11
plotshortened(70,41,4,0,0,'c.','c-','','c.',1);   % d=12
plotshortened(72,42,0,0,0,'c.','c-','','c.',1);   % d=11-12
plotshortened(75,43,0,0,0,'c.','c-','','c.',1);   % d=11-12
plotshortened(78,46,2,0,0,'c.','c-','','c.',0);   % d=11
plotshortened(79,46,2,0,0,'c.','c-','','c.',1);   % d=12
plotshortened(89,56,9,0,0,'c.','c-','','c.',0);   % d=11
plotshortened(90,56,9,0,0,'c.','c-','','c.',1);   % d=12
plotshortened(98,64,7,0,0,'c.','c-','','c.',0);   % d=11
plotshortened(99,64,7,0,0,'c.','c-','','c.',1);   % d=12

% repetition; n,1,n
% 2,1,2  3,1,3  4,1,4  5,1,5   6,1,6   7,1,7   8,1,8  ...  20,1,20
for n=1:2,   plot(log2(1),1/n,'k.'); end
for n=3:4,   plot(log2(1),1/n,'r.'); end
for n=5:6,   plot(log2(1),1/n,'b.'); end
for n=7:8,   plot(log2(1),1/n,'m.'); end
for n=9:9,  plot(log2(1),1/n,'g.'); end

set(h, 'XTickLabel',[])                      % suppress current x-labels
xt = get(h, 'XTick');
yl = get(h, 'YLim');
str = cellstr( num2str(2.^xt(:),'%d') );       % format x-ticks as 2^{xx}
hTxt = text(xt, yl(ones(size(xt))), str, ...   % create text at same locations
    'Interpreter','tex', ...                   % specify tex interpreter
    'VerticalAlignment','top', ...             % v-align to be underneath
    'HorizontalAlignment','center');           % h-aligh to be centered
h.XAxis.MinorTick = 'on';         % Must turn on minor ticks if they are off
h.XAxis.MinorTickValues = [log2(3:63)]; 

function [no,ko]=plotcode(n,k,c1,no,ko,c2)
    plot(log2(k),k/n,c1)
    if no>0, plot([log2(ko) log2(k)],[ko/no k/n],c2), end
    no=n; ko=k;
end

function [no,ko]=plotshortened(n,k,s,no,ko,c1,c2,c3,c4,p)
     [no,ko]=plotcode(n-s,k-s,c4,no,ko,c3);
     no1=no; ko1=ko; for p1=p:-1:1, [no1,ko1]=plotcode(n-s-p1,k-s,c4,no1,ko1,c2); end
     for s1=s-1:-1:1, if k-s1<=64
         [no,ko]=plotcode(n-s1,k-s1,c4,no,ko,c2);
         no1=no; ko1=ko; for p1=p:-1:1, [no1,ko1]=plotcode(n-s1-p1,k-s1,c4,no1,ko1,c2); end
     end, end
     if k<=64, [no,ko]=plotcode(n,k,c1,no,ko,c2);
         no1=no; ko1=ko; for p1=p:-1:1, [no1,ko1]=plotcode(n-p1,k,c4,no1,ko1,c2); end    
     end
end
