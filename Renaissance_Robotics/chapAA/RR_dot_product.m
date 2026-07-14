function [p]=RR_dot_product(u,v)
p=0; for i=1:length(u), p=p+u(i)*v(i); end
end
