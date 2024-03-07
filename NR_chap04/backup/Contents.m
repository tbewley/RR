% =============================== CHAPTER 4: LINEAR ALGEBRA ===============================
% Attendant to the text <a href="matlab:web('http://numerical-renaissance.com/')">Numerical Renaissance: simulation, optimization, & control</a>
% Files in NRchap4 of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>:
%   Bidiagonalization          - function [A,U,V] = Bidiagonalization(A,m,n)
%   BidiagonalizationTest      - script BidiagonalizationTest
%   RC_CALE                       - function X=RC_CALE(A,Q)
%   RC_CALEtest                   - script RC_CALEtest
%   RC_CARE                       - function X=RC_CARE(A,S,Q)
%   RC_CAREtest                   - script RC_CAREtest
%   Cholesky                   - function [A] = Cholesky(A,n)
%   CholeskyIncomplete         - function [A] = CholeskyIncomplete(A,n)
%   CholeskyIncompleteTest     - script CholeskyIncompleteTest
%   CholeskyTest               - script CholeskyTest
%   RC_DALE                       - function X=RC_DALE(F,Q,n)
%   RC_DALEtest                   - script RC_DALEtest
%   RC_DARE                       - function X=RC_DARE(F,S,Q,n)
%   RC_DAREdoubling               - function X=RC_DAREdoubling(F,S,Q,n,steps)
%   RC_DAREtest                   - script RC_DAREtest
%   RC_Eig                        - function [lam,S]=RC_Eig(S,type)
%   RC_EigGeneral                 - function [lam] = RC_EigGeneral(A)
%   RC_EigGeneralTest             - script RC_EigGeneralTest
%   RC_EigHermitian               - function [lam] = RC_EigHermitian(A)
%   RC_EigHermitianTest           - script RC_EigHermitianTest
%   RC_EigReal                    - function [lam] = RC_EigReal(A)                            
%   RC_EigRealTest                - script RC_EigRealTest
%   RC_EigTest                    - script RC_EigTest
%   RC_Hessenberg                 - function [A,V] = RC_Hessenberg(A)
%   RC_HessenbergTest             - script RC_HessenbergTest
%   QRcgs                      - function [A,R] = QRcgs(A)
%   QRcgsTest                  - script QRcgsTest
%   RC_QRFastGivensHessenberg     - function [A,Q] = RC_QRFastGivensHessenberg(A) 
%   RC_QRFastGivensHessenbergTest - script RC_QRFastGivensHessenbergTest
%   RC_QRGivensHessenberg         - function [A,Q] = RC_QRGivensHessenberg(A)
%   RC_QRGivensHessenbergTest     - script RC_QRGivensHessenbergTest
%   QRGivensTridiag            - function [b,c,a,cc,ss] = QRGivensTridiag(a,b,c)
%   QRGivensTridiagTest        - script QRGivensTridiagTest
%   QRHouseholder              - function [A,Q,pi,r] = QRHouseholder(A)
%   QRHouseholderTest          - script QRHouseholderTest
%   QRmgs                      - function [A,R,pi,r] = QRmgs(A)
%   QRmgsTest                  - script QRmgsTest
%   RC_RDE                        - function X=RC_RDE(X,F,S,Q,n,steps)
%   RC_RDEtest                    - script RC_RDEtest
%   RC_ReorderSchur               - function [U,T]=RC_ReorderSchur(U,T,type,e)
%   RC_ReorderSchurTest           - script RC_ReorderSchurTest
%   RC_Roots                      - function x = RC_Roots(a)
%   RC_RootsTest                  - script RC_RootsTest
%   RC_Schur                      - function [U,T]=RC_Schur(U,type)
%   RC_SchurTest                  - script RC_SchurTest
%   RC_ShiftedInversePower        - function [S,T] = RC_ShiftedInversePower(A,mu)
%   RC_ShiftedInversePowerTest    - script RC_ShiftedInversePowerTest
%   SVD                        - function [S,U,V,r] = SVD(A)
%   SVDTest                    - script SVDTest
%   RC_Sylvester                  - function X=RC_Sylvester(A,B,C,g,m,n)
%   RC_SylvesterTest              - script RC_SylvesterTest
%   RC_WireTest                   - function RC_WireTest
% <a href="matlab:help RCchap03"><-previous</a> ========== please read the <a href="matlab:help RCcopyleft">copyleft</a>, and please <a href="matlab:help RCsupport">support</a> us! =========== <a href="matlab:help RCchap05">next-></a>
