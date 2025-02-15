clear; format compact; format short;
Pham=[0 1 1 1;1 0 1 1;1 1 0 1]; V=[eye(4);Pham], H=[Pham,eye(3)]

P=(zeros(7)); P(7,1)=1; P(6,2)=1; P(1,3)=1; P(5,4)=1; P(2,5)=1; P(3,6)=1; P(4,7)=1;

V=gf(P'*V), H=gf(H*P)

w=V(:,1)+V(:,2); w', (H*w)',

for i=1:7; i, wh=w; wh(i)=w(i)+1; wh',  (H*wh)', end
