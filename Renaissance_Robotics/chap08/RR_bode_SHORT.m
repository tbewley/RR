function RR_bode_SHORT(D, log_omega_min, log_omega_max, N)
% INPUTS: log_omega_min, log_omega_min, N   <- these define the omega range
%         b, a    <- two RR_poly objects, defined such that D(s)=b(s)/a(s)
% TEST:   clf, D=RR_tf([-10],[-100],1), RR_bode_SHORT(D,0,3,100)

for log_omega = log_omega_min : (log_omega_max-log_omega_min)/N : log_omega_max
   omega=10^log_omega, f=RR_evaluate(D,i*omega)
   subplot(2,1,1), loglog(omega,abs(f),'k.'), hold on
   subplot(2,1,2), semilogx(omega,angle(f),'k.'), hold on
end
