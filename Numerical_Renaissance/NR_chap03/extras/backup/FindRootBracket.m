function [x1,x2] = FindRootBracket(x1,x2)
while Computef(x1)*Computef(x2)>0, int=x2-x1;  x1=x1-0.5*int;  x2=x2+0.5*int;  end
% end function FindRootBracket.m

