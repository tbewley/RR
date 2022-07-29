clear;
xx=[-2:.001:2]; TT9=256*xx.^9-576*xx.^7 +432*xx.^5 -120*xx.^3 +9*xx;

figure(1); plot(xx,TT9); axis([-1.2 1.2 -18 18]); hold on; plot([-1.2 1.2],[0 0],'k--'); plot([0 0],[-18 18],'k--'); print -depsc chebfn1.eps

x=[0:.001:2]; T=128*x.^8-256*x.^6+160*x.^4 - 32*x.^2 +1; for i=1:2001; R(i)=CRF(8,1.011,x(i)); end

figure(2); semilogy(x,(.01*T.^2));       hold on; plot([0 2],[.01 .01],'k--'); axis([0 2 .001 1000]); print -depsc chebfn2.eps

figure(3); semilogy(1./x,1./(.01*T.^2)); hold on; plot([0 3],[100 100],'k--'); axis([0 3 .001 1000]); print -depsc chebfn3.eps

figure(4); semilogy(x,(.01*R.^2));       hold on; plot([0 2],[.01 .01],'k--'); plot([0 2],[100 100],'k--');  axis([0 2 .001 1000]);  print -depsc chebfn4.eps

