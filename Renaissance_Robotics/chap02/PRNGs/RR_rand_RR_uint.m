function X=RR_rand_RR_uint(NBITS,M,N,P)
% function X=RR_rand_RR_uint(NBITS,M,N,P) or X=RR_rand_RR_uint(IMAX,[M N P])
%
% Generate a scalar, or a vector (length M), matrix (MxN), or rank-3 (MxNxP) cell array, each
% entry of which is an RR UNSIGNED INTEGER with uniform distribution over the range 0 to 2^NBITS-1.
% For M*N*P>1, cell arrays are generated, each entry of which is one of the following types:
%   RR_uint8,RR_uint16,RR_uint32,RR_uint64,RR_uint128,RR_uint256,RR_uint512,RR_uint1024.
%
% INPUTS: NBITS = max number of nonzero bits (OPTIONAL, default NBITS=64, max NBITS=1024)
%         M,N,P = dimensions of output array (OPTIONAL, default M=N=P=1)
% OUTPUT: X     = scalar, or cell array, of unsigned integers
%
% TEST:   X=RR_rand_RR_uint(24)             % an RR_uint32 integer on [0,2^24-1]
%         Z=RR_rand_uint(120,5,5), Z{1,1}   % 5x5 cell array of RR_uint128 on [0,2^120-1]
%
% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

if nargin==0, NBITS=64; end   % Calculate NBITS and {M,N,P} from input data
if nargin==2 & length(M)>1, N=M(2); if length(M)>2, P=M(3); end, M=M(1); end
if ~exist('M'), M=1; end, if ~exist('N'), N=1; end, if ~exist('P'), P=1; end

Z=RR_rand_uint(NBITS,M,N,P);   % This routine does all the work.  Then convert to RR_uintN form.

if NBITS<9,      for i=1:M, for j=1:N, for k=1:P, X{i,j,k}=RR_uint8(Z(i,j,k));  end, end, end
elseif NBITS<17, for i=1:M, for j=1:N, for k=1:P, X{i,j,k}=RR_uint16(Z(i,j,k)); end, end, end
elseif NBITS<33, for i=1:M, for j=1:N, for k=1:P, X{i,j,k}=RR_uint32(Z(i,j,k)); end, end, end
elseif NBITS<65, for i=1:M, for j=1:N, for k=1:P, X{i,j,k}=RR_uint64(Z(i,j,k)); end, end, end
else X=Z;
end
