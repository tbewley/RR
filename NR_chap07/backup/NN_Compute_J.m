function [J] = NN_Compute_J(y,z,dm,w,n,lm)
J=0; for d=1:dm; x=NN_Forward(y(:,d),w,n,lm); J=J+0.5*(x{lm}-z(:,d))'*(x{lm}-z(:,d)); end
% end function NN_Compute_J

