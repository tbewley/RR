function Draw(x)
global d
x(d.NN+1:2*d.NN-1,1)=x(d.NN+1:2*d.NN-1,1); x(d.NN,1)=10; x(2*d.NN,1)=0;
figure(1); clf; hold on; axis equal; axis([0 10 -3 3]);
for i=1:d.N; k=1+(i-1)*d.N;
  plot([0 x(i)],[-1 x(i+d.NN)],'b-'); plot([0 x(k)],[1 x(k+d.NN)],'r-'); end
for i=1:d.N; for j=2:d.N; k=i+(j-1)*d.N;
  t=i  +(j-2)*d.N; plot([x(t) x(k)],[x(t+d.NN) x(k+d.NN)],'b-'); end; end
for i=2:d.N; for j=1:d.N; k=i+(j-1)*d.N;
  t=i-1+(j-1)*d.N; plot([x(t) x(k)],[x(t+d.NN) x(k+d.NN)],'r-'); end; end
hold off;
% end function Draw