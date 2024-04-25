% script RR_pi
% Calculate pi in a balanced fashion using the Ramanujan-Sato formula
% Gets 15 significant figures in N+1=2 steps
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

clear, N=1; p=0; for k=0:N, 
  % The following loop over i calculates f=factorial(6*k)/factorial(3*k)/factorial(k)^3
  % without getting too big too quickly, avoiding the direct calculation of factorial(6*k)
  f=1; for i=3*k+1:6*k, f=f*i/(mod(i-1,k)+1); end  % Note: f is an integer

  % Add the k'th term of the Ramanujan-Sato series, ordered to keep any term from getting big
  p=p+(-1)^k*(f/640320^k)*(545140134*k+13591409)/640320^(2*k+3/2);
end, p=1/(12*p)
