clear; format long
a=randn(2)
aa=(a(2,1)+a(1,2))^2+(a(1,1)-a(2,2))^2
bb=-(2*(a(2,1)+a(1,2))*a(1,2)+(a(1,1)-a(2,2))^2)
cc=a(1,2)^2
dd=sqrt(bb^2-4*aa*cc)
c1=(-bb+dd)/(2*aa)
c2=(-bb-dd)/(2*aa)
c=sqrt(c1); s=sqrt(1-abs(c)^2); G=[c conj(s);-s conj(c)]; res1=G'*a*G
c=sqrt(c2); s=sqrt(1-abs(c)^2); G=[c conj(s);-s conj(c)]; res2=G'*a*G
eig(a)