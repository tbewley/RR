
gamma=1.4; M1=[1.01:.01:5];

M2=sqrt(((gamma-1)*M1.^2+2)./(2*gamma*M1.^2-(gamma-1)));

p2_over_p1=(2*gamma*M1.^2-(gamma-1))/(gamma+1);

T2_over_T1=((2*gamma*M1.^2-(gamma-1)).*((gamma-1)*M1.^2+2))./((gamma+1)^2*M1.^2);

rho2_over_rho1=((gamma+1)*M1.^2)./((gamma-1)*M1.^2+2);

s2_minus_s1_over_c_v = log((2*gamma*M1.^2-(gamma-1))/(gamma+1))-gamma*log(((gamma+1)*M1.^2)./((gamma-1)*M1.^2+2));

figure(1); plot(M1,M2); title('M2');
figure(2); plot(M1,p2_over_p1); title('p2 over p1');
figure(3); plot(M1,T2_over_T1); title('T2 over T1');
figure(4); plot(M1,rho2_over_rho1); title('rho2 over rho1');
figure(5); plot(M1,s2_minus_s1_over_c_v); title('s2 minus s1 over cv');
