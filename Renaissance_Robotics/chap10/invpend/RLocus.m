function RLocus(numG,denG,numD,denD,g)               % Numerical Renaissance Codebase 1.0
num=Conv(numG,numD); den=Conv(denG,denD); num=[zeros(1,length(den)-length(num)) num]; clf
G_poles=roots(denG);    plot(real(G_poles),imag(G_poles),'kx','MarkerSize',16), hold on
D_poles=roots(denD);    plot(real(D_poles),imag(D_poles),'bx','MarkerSize',16), axis equal
G_zeros=roots(numG);    plot(real(G_zeros),imag(G_zeros),'ko','MarkerSize',11)
D_zeros=roots(numD);    plot(real(D_zeros),imag(D_zeros),'bo','MarkerSize',11)
H_poles=roots(num+den); plot(real(H_poles),imag(H_poles),'r*','MarkerSize',14)
for j=1:length(g.K)
  H_poles=roots(g.K(j)*num+den); plot(real(H_poles),imag(H_poles),'k.','MarkerSize',8)
end
axis(g.locus), a=axis; plot([a(1) a(2)],[0 0],'k--'), plot([0 0],[a(3) a(4)],'k--')
end % function RLocus.m 