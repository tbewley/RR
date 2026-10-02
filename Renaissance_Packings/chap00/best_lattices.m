% the best kissing and density for lattices (only) up to dimension 25.
% important note: this table does NOT include non-lattice packings.

kissing=[2 6 12 24 40 72 126 240 272 336 438 756 918 1422 2340 ...
          4320 5346 7398 10668 17400 27720 49896 93150 196560 196656];
figure(1); semilogy(kissing,'k+-','MarkerSize',10); hold on, grid
semilogy([8 12 16 24],kissing([8 12 16 24]),'ro','MarkerSize',15)

density=[1 0.9069 0.7405 0.6169 0.4653 0.3729 0.2953 0.2537 0.1457 ...
         0.09961 0.06622 0.04945 0.03201 0.02162 0.01586 0.01185 0.007559 ...
         0.005118 0.003408 0.002490 0.001925 0.001642 0.001550 .0019296 0.001332];
figure(2); semilogy(density,'k+-','MarkerSize',10); hold on, grid
semilogy([8 12 16 24],density([8 12 16 24]),'ro','MarkerSize',15)

% Gosset Lattice E_8=Lambda_8
% Coxeter-Todd Lattice K_12, Lambda_12(max)
% Barnes-Wall Lattice BW_16=Lambda_16
% Leech Lattice Lambda_24
