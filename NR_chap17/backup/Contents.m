% ------------------------------ CHAPTER 20: LINEAR SYSTEMS -------------------------------
% Attendant to the text  <a href="matlab:web('http://numerical-renaissance.com/')">Numerical Renaissance: simulation, optimization, & control</a>
% Files in NRchap20 of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>:
%   RR_ShowSys               - function RR_ShowSys(A,B,C,[D])
%   RR_ShowSysTest           - script <a href="matlab:RR_ShowSysTest">RR_ShowSysTest</a>
%   RR_SSTransform           - function [A,B,C]=RR_SSTransform(A,B,C,R)
%   RR_SSTransformTest       - script <a href="matlab:RR_SSTransformTest">RR_SSTransformTest</a>
%   RR_MatrixExponential     - function [Phi]=RR_MatrixExponential(A,t)
%   RR_MatrixExponentialTest - script <a href="matlab:RR_MatrixExponentialTest">RR_MatrixExponentialTest</a>
%   RR_SS2TF                 - function [b,a]=RR_SS2TF(A,B,C,[D])
%   RR_SS2TFTest             - script <a href="matlab:RR_SS2TFTest">RR_SS2TFTest</a>
%   RR_MaxEnergyGrowth       - function [thetamax,x0]=RR_MaxEnergyGrowth(A,Q,tau,[MODE])
%   RR_MaxEnergyGrowthTest   - script <a href="matlab:RR_MaxEnergyGrowthTest">RR_MaxEnergyGrowthTest</a>
%   RR_TFnorm                - function x=RR_TFnorm(A,B,C,[p],[MODE])
%   RR_TFnormTest            - script <a href="matlab:RR_TFnormTest">RR_TFnormTest</a>
%   RR_TF2Markov             - function [m]=RR_TF2Markov(b,a)
%   RR_TF2MarkovTest         - script <a href="matlab:RR_TF2MarkovTest">RR_TF2MarkovTest</a>
%   RR_SS2Markov             - function [m]=RR_SS2Markov(A,B,C,D,p)
%   RR_SS2MarkovTest         - script <a href="matlab:RR_SS2MarkovTest">RR_SS2MarkovTest</a>
%   RR_TF2SS                 - function [A,B,C,D]=RR_TF2SS(b,a,[FORM])
%   RR_TF2SSTest             - script <a href="matlab:RR_TF2SSTest">RR_TF2SSTest</a>
%   RR_CtrbMatrix            - function [CM,r] = RR_CtrbMatrix(A,B)
%   RR_CtrbMatrixTest        - script <a href="matlab:RR_CtrbMatrixTest">RR_CtrbMatrixTest</a>
%   RR_CtrbGrammian          - function [P,r] = RR_CtrbGrammian(A,B,[MODE])
%   RR_CtrbGrammianTest      - script <a href="matlab:RR_CtrbGrammianTest">RR_CtrbGrammianTest</a>
%   RR_ObsvMatrix            - function [OM,r] = RR_ObsvMatrix(A,C)
%   RR_ObsvMatrixTest        - script <a href="matlab:RR_ObsvMatrixTest">RR_ObsvMatrixTest</a>
%   RR_ObsvGrammian          - function [Q,r] = RR_ObsvGrammian(A,C,[MODE])
%   RR_ObsvGrammianTest      - script <a href="matlab:RR_ObsvGrammianTest">RR_ObsvGrammianTest</a>
%   RR_SS2CanonicalForm      - function [A,B,C,r1,r2,r3,r4]=RR_SS2CanonicalForm(A,B,C,FORM)
%   RR_SS2CanonicalFormTest  - script <a href="matlab:RR_SS2CanonicalFormTest">RR_SS2CanonicalFormTest</a>
%   RR_BalancedForm          - function [A,B,C,HankelSingValues]=RR_BalancedForm(A,B,C,[MODE])
%   RR_BalancedFormTest      - script <a href="matlab:RR_BalancedFormTest">RR_BalancedFormTest</a>
% <a href="matlab:help RCchap19"><-previous</a> ---------- please read the <a href="matlab:help RCcopyleft">copyleft</a>, and please <a href="matlab:help RCsupport">support</a> us! ----------- <a href="matlab:help RCchap21">next-></a>
