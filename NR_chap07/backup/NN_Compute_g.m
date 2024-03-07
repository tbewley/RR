function [g] = NN_Compute_g(y,z,w,n,lm)
g=w*0; for d=1:dm; x=NN_Forward(y(:,d),w,n,lm); g=NN_Backpropogate(z(:,d),x,w,g,n,lm); end
% end function NN_Compute_g
