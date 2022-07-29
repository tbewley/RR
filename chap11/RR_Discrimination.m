clear; xim=logspace(-4,2,800); xi=xim+1;
for i=1:length(xi); r2(i)=CRF(2,xi(i),xi(i)); r4(i)=CRF(4,xi(i),xi(i)); r8(i)=CRF(8,xi(i),xi(i)); r16(i)=CRF(16,xi(i),xi(i)); end
figure(1); loglog(xi-1,r2,'b-.',xi-1,r4,'b--',xi-1,r8,'b-'); axis([.0001 100 1 100000])
