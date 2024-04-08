function X=RR_randn(M,N,P)
% function X=RR_randn(M,N,P) or X=RR_randn([M N P]) or X=RR_randn(size(A))
% Pseudorandomly generate a scalar, vector (length M), matrix (size MxN), or rank-3 array (size MxNxP),
% each entry of which is drawn a from the standard normal distribution (mean=0, stddev=1)
% INPUTS: M,N,P = dimension(s) of output array (OPTIONAL, default M=N=P=1)
% OUTPUT: X     = scalar, vector, matrix, or rank-3 array of random real numbers
% TEST: X=RR_randn(10,10)                  % 10x10 array of real numbers (mean=0, stddev=1)
%         Min=min(min(X)), Max=max(max(X))                   
%       Y=3+2*RR_randn(10000);             % vector of 10000 real numbers (mean=3, stddev=2)
%         histogram(Y,40,'Normalization','probability') 
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

% Calculate {M,N,P} from input data
if nargin==1 & length(M)>1, N=M(2); if length(M)>2, P=M(3); end, M=M(1); end
if ~exist('M'), M=1; end, if ~exist('N'), N=1; end, if ~exist('P'), P=1; end

MNP=M*N*P; if mod(MNP,2), MNP=MNP+1; end, x=RR_rand(MNP);  % draw MNP random real numbers on (0,1)
% Apply Box Muller transform to convert each pair of real numbers on (0,1) to a normal distribution
for i=1:2:MNP-1, a=sqrt(-2*log(x(i))); b=2*pi*x(i+1); X(i)=a*cos(b); X(i+1)=a*sin(b); end
X=reshape(X(1:M*N*P),M,N,P); % Reshape the normally distributed numbers to the right shape matrix
