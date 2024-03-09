function [bxnew,fbnew] = brent(AX,BX,CX,FA,FB,FC,TOL,ITMAX,xx,pp)
% Adapted from brent.f in Numerical Recipes by Press et al.
% Matlab conversion by Thomas R. Bewley.

% INPUT: {AX,BX,CX} a bracketing triplet of points from Bracket,
%   with {FA,FB,FC} as function values.
%   TOL*BX is the accuracy of the final answer.
%   ITMAX is maximum number of iterations.
% OUTPUT: FB is the minimum value of FUNC, at the minimum point BX.

      CGOLD=.3819660;  ZEPS=1.E-30;   D=0;
      FW=min(FA,FC);
      if FW == FA
         W =AX;
         V =CX;
         FV=FC;
      else
         W =CX;
         V =AX;
         FV=FA;
      end
      X =BX;
      FX=FB;
      A =min(AX,CX);
      B =max(AX,CX);
      FLAG3 = 0;
      for ITER=1:ITMAX,
        if ITER <= 2
	      E=2.*(B-A);
        end
	    XM=0.5*(A+B);
        TOL1=TOL*abs(X)+ZEPS;
        TOL2=2.*TOL1;
        if abs(X-XM)<=(TOL2-.5*(B-A))
           FLAG3=1;
           break;
        end
        FLAG2 = 0;
        if abs(E) > TOL1 | ITER <= 2
          R=(X-W)*(FX-FV);
          Q=(X-V)*(FX-FW);
          P=(X-V)*Q-(X-W)*R;
          Q=2.*(Q-R);
          if Q > 0.
             P=-P;
          end
          Q=abs(Q);
          ETEMP=E;
          E=D;
          if ~(abs(P) >= abs(0.5*Q*ETEMP) | P <= Q*(A-X) | P >= Q*(B-X))
             D=P/Q;
             U=X+D;
             if U-A < TOL2 | B-U < TOL2
                D=abs(TOL1)*sign(XM-X);
             end
             FLAG2 = 1;
          end
        end
        if FLAG2 == 0
           if X >= XM
             E=A-X;
           else
             E=B-X;
           end
           D=CGOLD*E;
        end
        if abs(D) >= TOL1 
           U=X+D;
        else
           U=X+abs(TOL1)*sign(D);
        end
        FU=ComputeJ(xx+U*pp);
        if FU <= FX 
          if U >= X
            A=X;
          else
            B=X;
          end
          V=W;
          FV=FW;
          W=X;
          FW=FX;
          X=U;
          FX=FU;
        else
          if U < X
            A=U;
          else
            B=U;
          end
          if FU <= FW | W == X
            V=W;
            FV=FW;
            W=U;
            FW=FU;
          elseif FU <= FV | V == X | V == W
            V=U;
            FV=FU;
          end
        end
      end
      if FLAG3==0
         disp('Line minimization did not converge to prescribed tolerance.')
      end
      bxnew=X;
      fbnew=FX;
% end function Brent.m
