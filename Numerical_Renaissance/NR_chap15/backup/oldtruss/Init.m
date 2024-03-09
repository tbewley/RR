function [x]=Init
global d
d.N=5; d.NN=(d.N)^2; d.bmc=1; d.tmc=1; d.rega=100; d.regb=100; d.pow=2;
for i=1:d.N; for j=1:d.N; k=i+(j-1)*d.N;
  if k<d.NN, x(k,1)=3+7*((i+j-2)/(2*d.N-2)); x(k+d.NN-1,1)=1*((j-i)/(d.N-1)); end;
end; end
% end function Init
