% script RR_Subspaces
% Calculates orthogonal bases for the 4 fundamental subspaces of several interesting matrices A
% using QR decompositions of A and A'.  The code scales the columns of these basis vectors in a
% convenient way, so their entries are simple integers (that is, their columns are not normalized).
% The results that this script produces are helpful for understanding the Strang plot.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 7)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

clear, format short
clc, A=[1 2 3;4 5 6;7 8 0], determinant=det(A), r=rank(A), pause
Ainv = inv(A), fac=scale_factor(Ainv),  Ainv_times_fac=Ainv*fac, A*Ainv, pause

clc, A=[2 -2 -4;-1 3 4;1 -2 -3], [C,L,R,N]=test_3_by_3_matrix(A);
disp('here is a surprise! (A is idempotent)');
A, A_times_A=A*A, pause, disp(' ')

clc, A=[2 2 -2;5 1 -3;1 5 -3], [C,L,R,N]=test_3_by_3_matrix(A);
disp('here is a surprise! (A is nilpotent of degree 3)');
A, A_times_A=A*A, A_times_A_times_A=A*A*A, pause

clc, A=[1 2;3 4;0 0], [C,L,R,N]=test_rectangular_matrix(A);
gamma=randi([-10 10]), yL=gamma*L(:,1), Apinv_times_yL=Apinv*yL, pause

clc, A=[1 2 0;3 4 0], [C,L,R,N]=test_rectangular_matrix(A);
delta=randi([-10 10]), xN=delta*N(:,1), A_times_xN=A*xN, pause

disp('Some pretty nifty stuff, eh?')

function [C,L,R,N]=test_3_by_3_matrix(A)
determinant=det(A), r=rank(A), pause, disp(' ')
[C,L]=QRcheck(A,r),  pause, disp(' ')
[R,N]=QRcheck(A',r), pause, disp(' ')
Apinv=pinv(A), fac=scale_factor(Apinv), Apinv_times_fac=Apinv*fac, pause, disp(' ')
disp('here is how A and A^+ act:'); alpha=ran, beta=ran,
xR=alpha*R(:,1)+beta*R(:,2), yC=A*xR, Apinv_times_A_times_xR=Apinv*yC, pause, disp(' ')
delta=ran, xN=delta*N(:,1), A_times_xN=A*xN, pause, disp(' ')
gamma=ran, yL=gamma*L(:,1), Apinv_times_yL=Apinv*yL, pause, disp(' ')
end

function [C,L,R,N]=test_rectangular_matrix(A)
r=rank(A), pause, disp(' ');
[C,L]=QRcheck(A,r),  pause, disp(' ')
[R,N]=QRcheck(A',r), pause, disp(' ')
Apinv=pinv(A), fac=scale_factor(Apinv), Apinv_times_fac=Apinv*fac, pause, disp(' ')
disp('here is how A and A^+ act:'); alpha=ran, beta=ran
xR=alpha*R(:,1)+beta*R(:,2), yC=A*xR, Apinv_times_A_times_xR=Apinv*yC, pause, disp(' ')
end

function [C,L]=QRcheck(A,r)
% compute the QR decomposition of A, and rescale/rename the columns of Q
[Q,R]=qr(A); L=[];
if sign(Q(1,1)) ~= sign(A(1,1)), Q=-Q; end  % select a natural sign for Q(1,1)
for i=1:r           % rescale/rename first r columns of Q
   C(:,i)=Q(:,i);   fac=scale_factor(C(:,i)); C(:,i)=C(:,i)*fac;
end
for i=1:size(Q,2)-r % rescale/rename last r columns of Q
   L(:,i)=Q(:,r+i); fac=scale_factor(L(:,i)); L(:,i)=L(:,i)*fac;                
end
end

function num=ran
% This routine is kinda stupid.  It just finds a random nonzero integer.
num=0; while num==0, num=randi([-10 10]); end
end

function fac=scale_factor(X)
% This routine is kinda stupid.  It just finds a convenient scale factor.
AX=abs(X); AX=AX+100*(~(abs(X)>0.0001)); fac=1/min(AX,[],"all");
end