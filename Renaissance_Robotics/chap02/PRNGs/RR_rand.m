function X=RR_rand(M,N,P)
% function X=RR_rand(M,N,P) or X=RR_rand([M N P]) or X=RR_rand(size(A))
% Generate a scalar, vector (length M), matrix (MxN), or rank-3 (MxNxP) array, each entry
% of which is a REAL number UNIFORMLY DISTRIBUTED on the open interval (0,1).
% INPUTS: M,N,P = dimension(s) of output array (OPTIONAL, default M=N=P=1)
% OUTPUT: X     = scalar, vector, matrix, or rank-3 array of random numbers on (0,1)
% TEST: X=RR_rand(10,10)                   % 10x10 array of real numbers on (0,1)
%       Min=min(min(X)), Max=max(max(X)) 
%       Y=-2+4*RR_rand(10000);             % 10000 real numbers on (-2,2)
%       clf, histogram(Y,[-2:0.2:2],'Normalization','pdf')
%       hold on; plot([-2 2],[1 1]/4,'k-',linewidth=2)   
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

global RR_PRNG_GENERATOR
if ~strcmp(RR_PRNG_GENERATOR,'xoshiro256++'), RR_prng('stochastic','xoshiro256++'), end

% Calculate {M,N,P} from input data
if nargin==1 & length(M)>1, N=M(2); if length(M)>2, P=M(3); end, M=M(1); end
if ~exist('M'), M=1; end, if ~exist('N'), N=1; end, if ~exist('P'), P=1; end

% Then, draw M*N*P random integers on [0,2^64-1], grab their top 52 bits, normalize,
% and reshape into the desired matrix form
X=reshape(double(bitsra(RR_prng_draw(M*N*P),12)+1)/4.503599627370497e+15,M,N,P);
