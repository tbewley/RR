function X=RR_rand_RR_int(IMAX,M,N,P)
% function X=RR_rand_RR_int(IMAX,M,N,P) or X=RR_rand_RR_uint(IMAX,[M N P])
%
% Generate a scalar, or a vector (length M), matrix (MxN), or rank-3 (MxNxP) cell array,
% each entry of which is an RR SIGNED or UNSIGNED integer with discrete uniform
% distribution over the specified range, and is one of the following types:
%    RR_int8,RR_int16,RR_int32,RR_int64, RR_uint8,RR_uint16,RR_uint32,RR_uint64
%
% INPUTS: IMAX  = max integer generated (max=2^63-1)
%               Note: IMIN=0 by default (unlike Matlab's randi, min=-2^63, need IMIN<=IMAX).        
%               Replace IMAX with [IMIN,IMAX] to specify a different range of integers. 
%         M,N,P = dimensions of output array (OPTIONAL, default M=N=P=1)
% OUTPUT: X     = scalar, vector, matrix, or rank-3 array of random integers on [IMIN:IMAX]
%               Note: class of RR_int or RR_uint returned is selected to fit the [IMIN:IMAX] range;
%               be certain to convert this after result is returned if you want something else.
%
% TEST:   X=RR_rand_RR_int(4096,5,5), X{1,1}            % 5x5 cell array of RR_uint16 integers on [0:4096]
%         N=50000; Y=RR_rand_RR_int([-10,10],N); Y{1,1} % cell array of 50000 RR_int8 integers on [-10:10]
%         clf, for i=1:N, Yv(i)=Y{i}.v; end
%         histogram(Yv,[-10.5:1:10.5],'Normalization','probability')
%         hold on; plot([-10 10],[1 1]/21,'k-',linewidth=2)
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

if nargin==2 & length(M)>1, N=M(2); if length(M)>2, P=M(3); end, M=M(1); end
if ~exist('M'), M=1; end, if ~exist('N'), N=1; end, if ~exist('P'), P=1; end

Z=RR_rand_int(IMAX,M,N,P);  % This routine does all the work.  Then convert to RR_uintN or RR_intN form.
if     isa(Z(1,1,1),'uint8'),  for i=1:M, for j=1:N, for k=1:P, X{i,j,k}=RR_uint8(Z(i,j,k));  end, end, end
elseif isa(Z(1,1,1),'uint16'), for i=1:M, for j=1:N, for k=1:P, X{i,j,k}=RR_uint16(Z(i,j,k)); end, end, end
elseif isa(Z(1,1,1),'uint32'), for i=1:M, for j=1:N, for k=1:P, X{i,j,k}=RR_uint32(Z(i,j,k)); end, end, end
elseif isa(Z(1,1,1),'uint64'), for i=1:M, for j=1:N, for k=1:P, X{i,j,k}=RR_uint64(Z(i,j,k)); end, end, end
elseif isa(Z(1,1,1),'int8'),   for i=1:M, for j=1:N, for k=1:P, X{i,j,k}=RR_int8(Z(i,j,k));   end, end, end
elseif isa(Z(1,1,1),'int16'),  for i=1:M, for j=1:N, for k=1:P, X{i,j,k}=RR_int16(Z(i,j,k));  end, end, end
elseif isa(Z(1,1,1),'int32'),  for i=1:M, for j=1:N, for k=1:P, X{i,j,k}=RR_int32(Z(i,j,k));  end, end, end
elseif isa(Z(1,1,1),'int64'),  for i=1:M, for j=1:N, for k=1:P, X{i,j,k}=RR_int64(Z(i,j,k));  end, end, end
end
if M*N*P==1, X=X{1,1,1}; end      % Exit cell array mode if returning a scalar.