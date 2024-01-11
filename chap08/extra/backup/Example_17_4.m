% Computes the sixth-order ODE coefficients in the structure defined Example 17.4 of NR.
clear; format compact; m=1000; p1=15407; p3=10507; p5=5607; d1=1000; d3=1000; d5=1000; ell=5;
syms L1 L2 L3 L4 L5 L6 L7 L8 c k D
kbar1=vpa(k-2*p1/ell+sqrt(2)*d1/ell), 
kbar2=vpa(k-2*p3/ell+sqrt(2)*d3/ell), 
kbar3=vpa(k-2*p5/ell+sqrt(2)*d5/ell), 
L1=m*D^2+2*c*D+(kbar1+kbar2)
L2=c*D+kbar1
L3=c*D+kbar2
L4=m*D^2+2*c*D+(kbar2+kbar3)
L5=c*D+kbar2
L6=c*D+kbar3
L7=m*D^2+c*D+kbar3
L8=c*D+kbar3
alpha=coeffs(expand(L1*L4*L7-L5*L3*L7-L8*L1*L6)/m^3,D); alpha=alpha(end:-1:1)
beta=coeffs(expand(L1*L4-L5*L3)/m^3,D);                 beta =beta (end:-1:1)
gamma=coeffs(expand(L8*L5*L2)/m^3,D);                   gamma=gamma(end:-1:1)

% Now plot the impulse response of the same structure
disp(' '); disp('Now substituting in numerical values for k and c');
for w=1:3
  disp(sprintf('case %d:',w)); 
  switch w
    case 1, k=10000, c=10,    T=500;
    case 2, k=10000, c=1000,  T=25;
    case 3, k=1000,  c=10,    T=10;
  end
  alpha_num=(vpa(eval(alpha))); 
  beta_num=(vpa(eval(beta)));   
  gamma_num=(vpa(eval(gamma)))
  p=roots(eval(alpha_num))
  for i=1:6
    d(i)=gamma_num(4)*p(i)^3+gamma_num(3)*p(i)^2+gamma_num(2)*p(i)+gamma_num(1);
    for j=1:6, if (j~=i), d(i)=d(i)/(p(i)-p(j)); end, end
  end
  d
  h=T/5000; t=[0:h:T];
  f=(d(1)*exp(p(1)*t)+d(2)*exp(p(2)*t)+d(3)*exp(p(3)*t)+d(4)*exp(p(4)*t)+d(5)*exp(p(5)*t)+d(6)*exp(p(6)*t));
  plot(t,real(f)), print('-depsc',sprintf('mae143a_hw2_plot%d.eps',w)), if w<3, pause, end
end
