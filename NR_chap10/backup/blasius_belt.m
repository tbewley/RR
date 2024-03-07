function blasius
clear;  figure(1);  clf;

% Compute boundary layer profiles for 0 <= k <= 8.
x=[100:100:100000];
for i=1:6
   switch i
     case 1 
        k=0;   f0_3=0.4695997;
     case 2
        k=0.5; f0_3=0.4382;
     case 3
        k=1;   f0_3=0.3824;
     case 4
        k=2;   f0_3=0.2883;
     case 5
        k=4;   f0_3=0.1862;
     case 6
        k=8;   f0_3=0.10737;
   end
   k_save(i)=k;  f0_3_save(i)=f0_3;

   eta=0;  f=[0; k*f0_3; f0_3];
   eta_save(1)=eta;   u_save(1,i)=f(2);   h=0.004;  etamax=5;  eta_star=0;
   for n=1:etamax/h    % March over 0 -> etamax with RK4
          f2old=f(2);
          k1=fprime(f);
          k2=fprime(f+(h/2)*k1);
          k3=fprime(f+(h/2)*k2);
          k4=fprime(f+h*k3);
          f=f+(h/6)*k1+(h/3)*(k2+k3)+(h/6)*k4;
          eta_star=eta_star+(1-(f(2)+f2old)/2)*h;
          eta=eta+h; 
          eta_save(n+1)=eta;   u_save(n+1,i)=f(2);
   end
   f1=f(2)
   eta_star_times_sqrt2=eta_star*sqrt(2)
   u_star=u_save(round(eta_star/h),i);
   eta_star_tilde = eta_star/(u_save(etamax/h+1,i)-u_save(1,i));

   figure(1); plot(u_save(:,i),eta_save,'k-'); hold on;
   plot([u_star-0.03 u_star+0.03],[eta_star eta_star],'k-');
   figure(2);
   switch i
     case 1
        plot((u_save(:,i)-u_save(1,i))/(u_save(etamax/h+1,i)-u_save(1,i)), ...
                    (eta_save/eta_star)*(u_save(etamax/h+1,i)-u_save(1,i)),'k-'); hold on;
     case 6
        plot((u_save(:,i)-u_save(1,i))/(u_save(etamax/h+1,i)-u_save(1,i)), ...
                    (eta_save/eta_star)*(u_save(etamax/h+1,i)-u_save(1,i)),'k--'); hold on;
   end
   u_inf=f(2);
   figure(3); plot(x,eta_star_times_sqrt2 .* sqrt(x),'k-'); hold on;
end

figure(1); axis([0 1.1 0 etamax]);  grid; hold off; print -deps profiles.eps
figure(2); axis([0 1.1 0 etamax]);  grid; hold off; print -deps profiles_scaled.eps
figure(3);                                hold off; print -deps deltastargrowth.eps

% Compare shape of k=0 curve and k=8 curve.
% Note that they are slightly different.

u_save_etamax = u_save(etamax/h+1,6)
u_save_1      = u_save(1,6)


figure(4);  clf;
for i=1:6;
  temp=f0_3_save(i)/sqrt(2);
  plot(x,temp./sqrt(x),'k-');  hold on;
end
axis([0 10^5 0 0.005]);  grid; hold off;
print -deps drag_evolving.eps

function [fp] = fprime(f)
fp=[f(2); f(3); -f(1)*f(3)];

