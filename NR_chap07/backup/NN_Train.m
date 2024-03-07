function [w] = NN_Train(alpha,iterm,y,z,dm,w,n,lm)
for iter=1:iterm, for data=1:dm
  x=NN_Forward(y(:,data),w,n,lm);
  for l=1:lm-1; g{l}=w{l}*0; end;
  g=NN_Backpropogate(z(:,data),x,w,g,n,lm);
  for l=1:lm-1; w{l}=w{l}-alpha*g{l}; end;
end, Jsave(iter,1)=NN_Compute_J(y,z,dm,w,n,lm); end
Jsave(iter,1)
plot(Jsave)
% end function NN_Train
