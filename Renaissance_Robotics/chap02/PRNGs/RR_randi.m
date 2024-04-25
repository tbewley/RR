function X=RR_randi(IMAX,M,N,P)
% function X=RR_randi(IMAX,M,N,P) or X=RR_randi(IMAX,[M N P]) or X=RR_randi(IMAX,size(A))
% Pseudorandomly generate a scalar, vector (length M), matrix (size MxN), or rank-3 array (size MxNxP),
% each entry of which is a integer with discrete uniform distribution on 1:IMAX
% INPUTS: IMAX  = max integer generated        (OPTIONAL, default IMAX=10)
%         M,N,P = dimension(s) of output array (OPTIONAL, default M=N=P=1)
% OUTPUT: X     = scalar, vector, matrix, or rank-3 array of random integers on 1:IMAX
% TEST: X=RR_randi(99,10,10)                % 10x10 array of integers on 1:99
%         Min=min(min(X)), Max=max(max(X)) 
%       Y=10+RR_randi(10,5000);             % 5000 integers on 11:20
%         histogram(Y,[10.5:1:20.5],'Normalization','probability')
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

% Calculate IMAX and {M,N,P} from input data
if nargin==0, IMAX=100, end
if nargin==2 & length(M)>1, N=M(2); if length(M)>2, P=M(3); end, M=M(1); end
if ~exist('M'), M=1; end, if ~exist('N'), N=1; end, if ~exist('P'), P=1; end

global RR_PRNG_OUTPUT RR_PRNG_GENERATOR
if ~strcmp(RR_PRNG_GENERATOR,'xoshiro256++'), RR_prng('stochastic','xoshiro256++'), end
intmax=0xFFFFFFFFFFFFFFFF;

cat_total=double(floor(intmax/IMAX)); % total number of integers per catagory
draw_max=cat_total*IMAX-1;            % prepare to draw integers from [0,draw_max]

Z=RR_prng_draw(M*N*P);                % Select random integers on [0,draw_max]
% Normalize X by cat_total, round down to range 1:IMAX, and reshape to desired matrix form
for i=1:M*N*P, while Z(i)>draw_max,
	Z(i)=RR_prng_draw(1); % Replace those (few) draws that are greater than draw_max
end, end
if RR_PRNG_OUTPUT=='32bit', X=reshape(uint32(floor(double(Z)/cat_total))+1,M,N,P);
else,                       X=reshape(uint64(floor(double(Z)/cat_total))+1,M,N,P); end

if     IMAX<256,        X=uint8(X);
elseif IMAX<65536,      X=uint16(X);
elseif IMAX<4294967296, X=uint32(X);
end