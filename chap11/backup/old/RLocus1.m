function RLocus(num,den,K,K1)                        % Numerical Renaissance Codebase 1.0
clf;     ol_poles=roots(den); plot(real(ol_poles),imag(ol_poles),'kx','MarkerSize',15);
hold on; ol_zeros=roots(num); plot(real(ol_zeros),imag(ol_zeros),'ko','MarkerSize',10);
for j=1:size(K)
  cl_poles=roots(K(j)*num+den); plot(real(cl_poles),imag(cl_poles),'k.','MarkerSize',12);
end
% cl_poles=roots(K1*num+den); plot(real(cl_poles),imag(cl_poles),'b^','MarkerSize',20);
axis equal; axis([-2.2 0.2 -1.2 1.2]); % axis([-3 1 -2 2]); 
a=axis; plot([a(1) a(2)],[0 0],'k--'); plot([0 0],[a(3) a(4)],'k--');
% plot([-.2 .1 .1 -.2 -.2],[-.15 -.15 .15 .15 -.15],'k--');
end % function RLocus.m