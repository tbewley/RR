function X=RR_randu(NBITS,M,N,P)
% function X=RR_randu(NBITS,M,N,P) or X=RR_randi(IMAX,[M N P]) or X=RR_randi(IMAX,size(A))
% Generate a scalar, vector (length M), matrix (MxN), or rank-3 (MxNxP) array, each entry
% of which is an UNSIGNED INTEGER with uniform distribution over the range 0 to 2^NBITS-1.
% For NBITS<=64, vectors or matrices or arrays of (uint8,uint16,uint32,uint64) are generated;
% for NBITS>64, cell arrays of (RR_uint128,RR_uint256,RR_uint512,RR_uint1024) are generated.
% INPUTS: NBITS = max number of nonzero bits   (OPTIONAL, default NBITS=64)
%         M,N,P = dimension(s) of output array (OPTIONAL, default M=N=P=1)
% OUTPUT: X     = scalar, vector, matrix, or rank-3 array (or cell array) of unsigned integers
% TEST:   X=RR_randu(5,50000);           % vector of 50000 5-bit unsigned integers on [0,31]
%         clf, histogram(X,[-0.5:1:31.5],'Normalization','probability')
%         hold on; plot([0 31],[1 1]/32,'k-',linewidth=2)
%         Y=RR_randu(48,5,5), dec2hex(Y(1,1),16) % 5x5 matrix of RR_uint64 on [0,2^48-1]
%         Z=RR_randu(120,5,5), Z{1,1}            % 5x5 cell array of RR_uint128 on [0,2^120-1]
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

if nargin==0, NBITS=64; end
if NBITS<1 | NBITS>1024, error('Need 1<=NBITS<=1024 in RR_randu'), end

global RR_PRNG_OUTPUT RR_PRNG_GENERATOR
if ~strcmp(RR_PRNG_GENERATOR,'xoshiro256++'), RR_prng('stochastic','xoshiro256++'), end

% Calculate IMAX and {M,N,P} from input data
if nargin==2 & length(M)>1, N=M(2); if length(M)>2, P=M(3); end, M=M(1); end
if ~exist('M'), M=1; end, if ~exist('N'), N=1; end, if ~exist('P'), P=1; end

if NBITS<=64
	X=reshape(bitsrl(RR_prng_draw(M*N*P),64-NBITS),M,N,P);
	if NBITS<9, X=uint8(X); elseif NBITS<17, X=uint16(X); elseif NBITS<33, X=uint32(X); end
else, for i=1:M, for j=1:N, for k=1:P
	if NBITS<=128,
	    X{i,j,k}=RR_bitsrl(RR_uint128(RR_xoshiro256pp,RR_xoshiro256pp),128-NBITS);
	elseif NBITS<=256,
	 	X{i,j,k}=RR_bitsrl(RR_uint256(RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp),...
	 		               256-NBITS);
	elseif NBITS<=512,
		X{i,j,k}=RR_bitsrl(RR_uint512(RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp,...
				                      RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp),...
		                   512-NBITS);
	else
		X{i,j,k}=RR_bitsrl(RR_uint1024(RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp,...
		                               RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp,...
		                               RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp,...
		                               RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp),...
						   1024-NBITS);
	end
end, end, end, end