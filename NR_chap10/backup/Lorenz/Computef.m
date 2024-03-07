function f=Computef(y)
sigma=4; b=1; r=48;  % set the Lorenz parameters here.
f=[sigma*(y(2)-y(1));  -y(2)-y(1)*y(3);  -b*y(3)+y(1)*y(2)-b*r];
end
