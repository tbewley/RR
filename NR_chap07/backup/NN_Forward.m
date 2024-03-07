function [x] = NN_Forward(y,w,n,lm)
x{1}=y; for l=2:lm, for i=1:n(l), x{l}(i,1)=tanh(w{l-1}(i,:)*x{l-1}(:)); end, end
% end function NN_Forward
