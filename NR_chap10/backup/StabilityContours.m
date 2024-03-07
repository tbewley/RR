% StabilityContours.m
% Comute the stability contours for RK4 in the complex plane of lambda*h.
% Other schemes may be analyzed in an analogous manner.
LEFT=-6.05;  RIGHT=2.05;  BOTTOM=-4.05;  TOP=4.05;  Np=101; V=[1.000 1.0000000001];
lambdaR_h=[LEFT:(RIGHT-LEFT)/(Np-1):RIGHT]; 
lambdaI_h=[BOTTOM:(TOP-BOTTOM)/(Np-1):TOP];
for j=1:Np; for i=1:Np;
   lambda_h = lambdaR_h(j) + sqrt(-1) * lambdaI_h(i);
   sigma_RK4(i,j)=abs(1 + lambda_h + lambda_h^2/2 + lambda_h^3/6 + lambda_h^4/24);
end; end
figure(1); contourf(lambdaR_h,lambdaI_h,1./sigma_RK4,V,'k-'); colormap autumn;
axis('square');  title('4th-order Runge-Kutta'); hold on; 
plot([LEFT RIGHT],[0,0],'k-'); plot([0,0],[BOTTOM TOP],'k-');  hold off;
% end StabilityContours.m
