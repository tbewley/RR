function [g] = NN_Backpropogate(z,x,w,g,n,lm)
x{lm}(:)=x{lm}(:)-z(:);
for l=lm-1:-1:1
  x{l+1}(:)=x{l+1}(:).*(sech(w{l}(:,:)*x{l}(:))).^2; end 
  for i=1:n(l), g{l}(i,:)=x{l+1}(i)*x{l}(:);  x{l}(i,1)=(w{l}(:,1))'*x{l+1}(:,1);  end
end
% end function NN_Backpropogate
