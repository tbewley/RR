function X=RR_randn(M,N,P,precision)
% function X=RR_randn(M,N,P) or X=RR_randn([M N P]) or X=RR_randn(size(A))
% Generate a scalar, vector (length M), matrix (MxN), or rank-3 (MxNxP) array, each entry
% of which is a REAL number NORMALLY DISTRIBUTED with mean=0 and stddev=1
% INPUTS: M,N,P = dimension(s) of output array (OPTIONAL, default M=N=P=1)
%         precision = {'single','double'} (OPTIONAL, default 'double')
% OUTPUT: X     = scalar, vector, matrix, or rank-3 array of random real numbers
% TEST: X=RR_randn(10,10)                          % 10x10 matrix of real numbers (mean=0, stddev=1)
%       Min=min(min(X)), Max=max(max(X))                   
%       mu=5; sigma=2; Y=mu+sigma*RR_randn(10000); % 10000 real numbers (mean=mu, stddev=sigma)
%       clf, histogram(Y,40,'Normalization','pdf')
%       x=[mu-4*sigma:sigma/40:mu+4*sigma]; y=exp(-(x-mu).^2/(2*sigma^2))/(sigma*sqrt(2*pi));
%       hold on;  plot(x,y,'k-',linewidth=2)
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

% Calculate {M,N,P} from input data
if nargin==1 & length(M)>1, N=M(2); if length(M)>2, P=M(3); end, M=M(1); end
if ~exist('M'), M=1; end, if ~exist('N'), N=1; end, if ~exist('P'), P=1; end
if nargin<4, precision='double'; end

MNP=M*N*P; if mod(MNP,2), MNP=MNP+1; end, x=RR_rand(MNP,1,1,precision);  % draw MNP random real numbers on (0,1)
% Apply Box Muller transform to convert each pair of real numbers on (0,1) to a normal distribution
for i=1:2:MNP-1, a=sqrt(-2*log(x(i))); b=2*pi*x(i+1); X(i)=a*cos(b); X(i+1)=a*sin(b); end
X=reshape(X(1:M*N*P),M,N,P); % Reshape the normally distributed numbers to the right shape matrix

