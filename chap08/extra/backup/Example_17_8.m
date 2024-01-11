% script <a href="matlab:Example_17_8">Example_17_8</a>
% Compute the ODE coefficients in the horizontal dynamics of a three-story building.
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Exampe 17.8.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap17">Chapter 17</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.

clear; clf; format compact;
m=1000; p1=15407; p3=10507; p5=5607; d1=1000; d3=1000; d5=1000; ell=5;
syms L1 L2 L3 L4 L5 L6 L7 L8 c k D
kbar1=vpa(k-2*p1/ell+sqrt(2)*d1/ell) 
kbar2=vpa(k-2*p3/ell+sqrt(2)*d3/ell)
kbar3=vpa(k-2*p5/ell+sqrt(2)*d5/ell)
L1=m*D^2+2*c*D+(kbar1+kbar2);
L2=c*D+kbar1;
L3=c*D+kbar2;
L4=m*D^2+2*c*D+(kbar2+kbar3);
L5=c*D+kbar2;
L6=c*D+kbar3;
L7=m*D^2+c*D+kbar3;
L8=c*D+kbar3;
a   =coeffs(expand(L1*L4*L7-L5*L3*L7-L8*L1*L6)/m^3,D); a   =a   (end:-1:1);
b   =coeffs(expand(L1*L4-L5*L3)/m^3,D);                b   =b   (end:-1:1);
bbar=coeffs(expand(L8*L5*L2)/m^3,D);                   bbar=bbar(end:-1:1); disp(' ')

% Substitute in numerical values for k & c, and plot the impulse response of the structure
for w=1:3
  disp(sprintf('case %d:',w)); 
  switch w
    case 1, k=10000, c=10,   T=500; disp('This case is highly oscillatory.')
    case 2, k=10000, c=1000, T=25;  disp('This case is still oscillatory, but not as bad.')
    case 3, k=1000,  c=10,   T=10;  disp('This case is unstable!')
  end
  a_num=double(eval(a)), b_num=double(eval(b)), bbar_num=double(eval(bbar)),
  p=roots((a_num))
  for i=1:6
    d(i)=bbar_num(4)*p(i)^3+bbar_num(3)*p(i)^2+bbar_num(2)*p(i)+bbar_num(1);
    for j=1:6, if (j~=i), d(i)=d(i)/(p(i)-p(j)); end, end
  end
  d, h=T/5000; t=[0:h:T];
  f=(d(1)*exp(p(1)*t)+d(2)*exp(p(2)*t)+d(3)*exp(p(3)*t)+d(4)*exp(p(4)*t)+d(5)*exp(p(5)*t)+d(6)*exp(p(6)*t));
  plot(t,real(f)), print('-depsc',sprintf('mae143a_hw2_plot%d.eps',w))
  disp(' '), if w<3, pause, end
end

% end script Example_17_8

