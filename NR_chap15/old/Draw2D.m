function Draw2D(A,b,res_save,x_save)
figure(2); clf;
plot(x_save(1,:),x_save(2,:),'k-x'); hold on; z=A\b; plot(z(1),z(2),'ro'); axis equal;
a=axis; ah=(a(2)-a(1))/10; av=(a(4)-a(3))/10; a=[a(1)-ah a(2)+ah a(3)-av a(4)+av];
axis(a); [X,Y] = meshgrid(a(1):(a(2)-a(1))/100:a(2), a(3):(a(4)-a(3))/100:a(4));
J=(1/2)*(X.^2*A(1,1)+X.*Y*(A(1,2)+A(2,1))+Y.^2*A(2,2))-(b(1)*X+b(2)*Y);
contour(X,Y,J,30);
% end function Draw2D