function RR_rlocus_SHORT(b, a, log_K_min, log_K_max, N)
% INPUTS: log_K_min, log_K_max, N   <- these define the K range
%         b, a    <- two RR_poly objects, defined such that L(s)=b(s)/a(s)
% TEST:   clf, b=RR_poly(1), a=RR_poly([5,-15],1), RR_rlocus_SHORT(b,a,1,3,100)

axis equal, hold on, grid
plot(complex(RR_roots(b)),'bo'), plot(complex(RR_roots(a)),'bx')
for log_K = log_K_min : (log_K_max-log_K_min)/N : log_K_max, K=10^log_K;
   plot(complex(RR_roots(a+K*b)),'k.')
end
