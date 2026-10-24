% script RR_best_lattices.m
% the best kissing and density for lattices (only) up to dimension 25.
% important note: this table does NOT include non-lattice packings.

kissing=[2 6 12 24 40 72 126 240 272 336 438 756 918 1422 2340 ...
          4320 5346 7398 10668 17400 27720 49896 93150 196560 197056];
figure(1); semilogy(kissing,'b+-','MarkerSize',10); hold on, grid
semilogy([8 12 16 24],kissing([8 12 16 24]),'ro','MarkerSize',15)
semilogy([1:25],[2:2:50],'k-')

% data from https://www.math.rwth-aachen.de/~Gabriele.Nebe/LATTICES/density.html
delta=[1/2 1/(2*sqrt(3)) 1/(4*sqrt(2)) 1/8 1/(8*sqrt(2)) 1/(8*sqrt(3)) 1/16 1/16 ...
 1/(16*sqrt(2)) 1/(16*sqrt(3)) 1/(18*sqrt(3)) 1/27 1/(18*sqrt(3)) 1/(16*sqrt(3)) 1/(16*sqrt(2)) 1/16 ...
 1/16 1/(8*sqrt(3)) 1/(8*sqrt(2)) 1/8 1/(4*sqrt(2)) 1/(2*sqrt(3)) 1/2 1 1/sqrt(2)]
for n=1:25, V(n)=pi^(n/2)/gamma(n/2+1); density(n)=delta(n)*V(n); Zdensity(n)=V(n)/2^n; end
Zdensity

figure(2); semilogy(density,'b+-','MarkerSize',10); hold on, grid
semilogy([8 12 16 24],density([8 12 16 24]),'ro','MarkerSize',15)
semilogy(Zdensity,'k-'), 


% Gosset Lattice E_8=Lambda_8
% Coxeter-Todd Lattice K_12, Lambda_12(max)
% Barnes-Wall Lattice BW_16=Lambda_16
% Leech Lattice Lambda_24
