% script RR_coordination_sequences.m

figure(1); clear;  
C_Z2 =[1,  4,   8,  12,   16,   20,   24,   28,   32,    36,    40];
C_Z3 =[1,  6,  18,  38,   66,  102,  146,  198,  258,   326,   402];
C_Z4 =[1,  8,  32,  88,  192,  360,  608,  952, 1408,  1992,  2720]; 
C_Z5 =[1, 10,  50, 170,  450, 1002, 1970, 3530, 5890,  9290, 14002]; 
C_Z6 =[1, 12,  72, 292,  912, 2364,  5336, 10836,  20256,  35436,  58728]; 
C_Z7 =[1, 14,  98, 462, 1666, 4942, 12642, 28814,  59906, 115598, 209762]; 
C_Z8 =[1, 16, 128, 688, 2816, 9424, 27008, 68464, 157184, 332688, 658048]; 


% See also: % https://arxiv.org/pdf/cond-mat/9706122
C_A2 =[1, 6, 12, 18, 24, 30, 36, 42, 48, 54, 60];                                         % https://oeis.org/A008458
C_FCC=[1, 12, 42, 92, 162, 252, 362, 492, 642, 812, 1002];                                % https://oeis.org/A005901
C_D4 =[1, 24, 144,   456,  1056,  2040,   3504,   5544,   8256,   11736, 16080];          % https://oeis.org/A007900
C_D5 =[1, 40, 370,  1640,  4930, 11752,  24050,  44200,  75010,  119720, 182002];         % https://oeis.org/A008355
C_E6 =[1, 72, 1062, 6696, 26316, 77688, 189810, 405720, 785304, 1408104, 2376126];        % https://oeis.org/A008399
C_E7 =[1, 126, 2898,  25886, 133506,  490014,  1433810,  3573054,   7902594,  15942206,  29896146];   % https://oeis.org/A008397
C_E8 =[1, 240, 9120, 121680, 864960, 4113840, 14905440, 44480400, 114879360, 265422960, 561403680];  % https://oeis.org/A008340
    
C_A2p=[1,  3,  6,   9,  12, 15,   18,   21,   24,    27,    30];  % https://oeis.org/A008486
C_bto=[1,  3,  6,  12,  24, 43,   64,   91,  124,   160,   202];  % https://digitalcommons.usf.edu/cgi/viewcontent.cgi?params=/context/etd/article/3746/&path_info=SFE0001843.pdf
C_Y49=[1,  3,  6,  12,  24, 48,   90,  146,  230,   336,   478];
C_Y59=[1,  3,  6,  12,  24, 48,   90,  168,  312,   532,   872];

C_A3p=[1,  4, 12, 24,  42,  64,  92, 124,  162,  204,  252];  % https://oeis.org/A008253
C_qzd=[1,  4, 12, 36,  72, 122, 188, 264,  354,  456,  570];  % https://digitalcommons.usf.edu/cgi/viewcontent.cgi?params=/context/etd/article/3746/&path_info=SFE0001843.pdf
C_T49=[1,  4, 12, 36,  92, 200, 384, 664, 1056, 1576, 2240]; 
% C_T59=[1,  4,  12,  36,  100, 258,   610, ?]

C_A5p=[1,  6,  30,  90,  240,  510, 1010, 1770, 2970,  4626,  7002];

clf, semilogy([0:10],C_Z2,'k--'); hold on; disp('Cartesian lattices for n=2 to 8')
semilogy([0:10],C_Z3,'k--'); semilogy([0:10],C_Z4,'k--'); semilogy([0:10],C_Z5,'k--');
semilogy([0:10],C_Z6,'k--'); semilogy([0:10],C_Z7,'k--'); semilogy([0:10],C_Z8,'k--');
pause; print -depsc coord_seq_Z.eps

clf; semilogy([0:10],C_A2,'k--'); hold on; disp('Densest lattices for n=2 to 8')
semilogy([0:10],C_FCC,'k--'); semilogy([0:10],C_D4,'k--'); semilogy([0:10],C_D5,'k--');
semilogy([0:10],C_E6,'k--');  semilogy([0:10],C_E7,'k--'); semilogy([0:10],C_E8,'k--');
print -depsc coord_seq_dense.eps

clf, semilogy([0:10],C_A2p,'k--'); hold on; disp('Best packings with coordination number tau=3 for n=2 to 5')
semilogy([0:10],C_bto,'k--'); semilogy([0:10],C_Y49,'k--'); semilogy([0:10],C_Y59,'k--');
semilogy([0 1],[3 3],'k:')
print -depsc coord_seq_best_tau_3.eps

clf,  semilogy([0:10],C_Z2,'k--'); hold on; disp('Best packings with coordination number tau=4 for n=2 to 5')
semilogy([0:10],C_A3p,'k--'); semilogy([0:10],C_qzd,'k--'); semilogy([0:10],C_T49,'k--'); % semilogy([0:10],C_Y59,'k--');
% semilogy([0:10],C_Z6,'k--'); semilogy([0:10],C_Z7,'k--'); semilogy([0:10],C_Z8,'k--');
semilogy([0 1],[4 4],'k:')
print -depsc coord_seq_best_tau_4.eps

clf,  semilogy([0:10],C_A2,'k--'); hold on; disp('Best packings with coordination number tau=6 for n=2, n=3, n-5')
semilogy([0:10],C_Z3,'k--'); semilogy([0:10],C_A5p,'k--');
semilogy([0 1],[6 6],'k:')
print -depsc coord_seq_best_tau_6.eps
