% script RR_bode_integral_thm
% Plot ln|S(i*omega)| where S=1/[1+L(s)], and L is of type RR_tf,
% thereby demonstrating Bode's integral theorem, for nr>1
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/Renaissance_Robotics/RR_chap10
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

clear; num=RR_poly(10); den=RR_poly([-1 -10],1);
%%%%%%%% edit above to change input transfer function %%%%%%%% 

L=RR_tf(num,den); nr=L.den.n-L.num.n
if     nr>1,  kappa=0
else   error('invalid input - neet nr>1')
end

% TODO: implement other cases from https://arxiv.org/pdf/1902.11302.pdf

S=1/(1+L); min=0; max=30; omega=[min:(max-min)/200:max];
S_vals = evaluate(S,i*omega); semilogy(omega,abs(S_vals),'b-'), hold on
a=axis; c=-kappa*pi/2, plot([a(1) a(2)],[10^c 10^c],'k-')