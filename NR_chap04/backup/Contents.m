% =============================== CHAPTER 4: LINEAR ALGEBRA ===============================
% Attendant to the text <a href="matlab:web('http://numerical-renaissance.com/')">Numerical Renaissance: simulation, optimization, & control</a>
% Files in NRchap4 of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>:
%   Bidiagonalization          - function [A,U,V] = Bidiagonalization(A,m,n)
%   BidiagonalizationTest      - script BidiagonalizationTest
%   RR_CALE                       - function X=RR_CALE(A,Q)
%   RR_CALEtest                   - script RR_CALEtest
%   RR_CARE                       - function X=RR_CARE(A,S,Q)
%   RR_CAREtest                   - script RR_CAREtest
%   Cholesky                   - function [A] = Cholesky(A,n)
%   CholeskyIncomplete         - function [A] = CholeskyIncomplete(A,n)
%   CholeskyIncompleteTest     - script CholeskyIncompleteTest
%   CholeskyTest               - script CholeskyTest
%   RR_DALE                       - function X=RR_DALE(F,Q,n)
%   RR_DALEtest                   - script RR_DALEtest
%   RR_DARE                       - function X=RR_DARE(F,S,Q,n)
%   RR_DAREdoubling               - function X=RR_DAREdoubling(F,S,Q,n,steps)
%   RR_DAREtest                   - script RR_DAREtest
%   RR_Eig                        - function [lam,S]=RR_Eig(S,type)
%   RR_EigGeneral                 - function [lam] = RR_EigGeneral(A)
%   RR_EigGeneralTest             - script RR_EigGeneralTest
%   RR_EigHermitian               - function [lam] = RR_EigHermitian(A)
%   RR_EigHermitianTest           - script RR_EigHermitianTest
%   RR_EigReal                    - function [lam] = RR_EigReal(A)                            
%   RR_EigRealTest                - script RR_EigRealTest
%   RR_EigTest                    - script RR_EigTest
%   RR_Hessenberg                 - function [A,V] = RR_Hessenberg(A)
%   RR_HessenbergTest             - script RR_HessenbergTest
%   QRcgs                      - function [A,R] = QRcgs(A)
%   QRcgsTest                  - script QRcgsTest
%   RR_QRFastGivensHessenberg     - function [A,Q] = RR_QRFastGivensHessenberg(A) 
%   RR_QRFastGivensHessenbergTest - script RR_QRFastGivensHessenbergTest
%   RR_QRGivensHessenberg         - function [A,Q] = RR_QRGivensHessenberg(A)
%   RR_QRGivensHessenbergTest     - script RR_QRGivensHessenbergTest
%   QRGivensTridiag            - function [b,c,a,cc,ss] = QRGivensTridiag(a,b,c)
%   QRGivensTridiagTest        - script QRGivensTridiagTest
%   QRHouseholder              - function [A,Q,pi,r] = QRHouseholder(A)
%   QRHouseholderTest          - script QRHouseholderTest
%   QRmgs                      - function [A,R,pi,r] = QRmgs(A)
%   QRmgsTest                  - script QRmgsTest
%   RR_RDE                        - function X=RR_RDE(X,F,S,Q,n,steps)
%   RR_RDEtest                    - script RR_RDEtest
%   RR_ReorderSchur               - function [U,T]=RR_ReorderSchur(U,T,type,e)
%   RR_ReorderSchurTest           - script RR_ReorderSchurTest
%   RR_Roots                      - function x = RR_Roots(a)
%   RR_RootsTest                  - script RR_RootsTest
%   RR_Schur                      - function [U,T]=RR_Schur(U,type)
%   RR_SchurTest                  - script RR_SchurTest
%   RR_ShiftedInversePower        - function [S,T] = RR_ShiftedInversePower(A,mu)
%   RR_ShiftedInversePowerTest    - script RR_ShiftedInversePowerTest
%   SVD                        - function [S,U,V,r] = SVD(A)
%   SVDTest                    - script SVDTest
%   RR_Sylvester                  - function X=RR_Sylvester(A,B,C,g,m,n)
%   RR_SylvesterTest              - script RR_SylvesterTest
%   RR_WireTest                   - function RR_WireTest
% <a href="matlab:help RCchap03"><-previous</a> ========== please read the <a href="matlab:help RCcopyleft">copyleft</a>, and please <a href="matlab:help RCsupport">support</a> us! =========== <a href="matlab:help RCchap05">next-></a>
