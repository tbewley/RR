% ------------------------------ CHAPTER 20: LINEAR SYSTEMS -------------------------------
% Attendant to the text  <a href="matlab:web('http://numerical-renaissance.com/')">Numerical Renaissance: simulation, optimization, & control</a>
% Files in NRchap20 of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>:
%   RC_ShowSys               - function RC_ShowSys(A,B,C,[D])
%   RC_ShowSysTest           - script <a href="matlab:RC_ShowSysTest">RC_ShowSysTest</a>
%   RC_SSTransform           - function [A,B,C]=RC_SSTransform(A,B,C,R)
%   RC_SSTransformTest       - script <a href="matlab:RC_SSTransformTest">RC_SSTransformTest</a>
%   RC_MatrixExponential     - function [Phi]=RC_MatrixExponential(A,t)
%   RC_MatrixExponentialTest - script <a href="matlab:RC_MatrixExponentialTest">RC_MatrixExponentialTest</a>
%   RC_SS2TF                 - function [b,a]=RC_SS2TF(A,B,C,[D])
%   RC_SS2TFTest             - script <a href="matlab:RC_SS2TFTest">RC_SS2TFTest</a>
%   RC_MaxEnergyGrowth       - function [thetamax,x0]=RC_MaxEnergyGrowth(A,Q,tau,[MODE])
%   RC_MaxEnergyGrowthTest   - script <a href="matlab:RC_MaxEnergyGrowthTest">RC_MaxEnergyGrowthTest</a>
%   RC_TFnorm                - function x=RC_TFnorm(A,B,C,[p],[MODE])
%   RC_TFnormTest            - script <a href="matlab:RC_TFnormTest">RC_TFnormTest</a>
%   RC_TF2Markov             - function [m]=RC_TF2Markov(b,a)
%   RC_TF2MarkovTest         - script <a href="matlab:RC_TF2MarkovTest">RC_TF2MarkovTest</a>
%   RC_SS2Markov             - function [m]=RC_SS2Markov(A,B,C,D,p)
%   RC_SS2MarkovTest         - script <a href="matlab:RC_SS2MarkovTest">RC_SS2MarkovTest</a>
%   RC_TF2SS                 - function [A,B,C,D]=RC_TF2SS(b,a,[FORM])
%   RC_TF2SSTest             - script <a href="matlab:RC_TF2SSTest">RC_TF2SSTest</a>
%   RC_CtrbMatrix            - function [CM,r] = RC_CtrbMatrix(A,B)
%   RC_CtrbMatrixTest        - script <a href="matlab:RC_CtrbMatrixTest">RC_CtrbMatrixTest</a>
%   RC_CtrbGrammian          - function [P,r] = RC_CtrbGrammian(A,B,[MODE])
%   RC_CtrbGrammianTest      - script <a href="matlab:RC_CtrbGrammianTest">RC_CtrbGrammianTest</a>
%   RC_ObsvMatrix            - function [OM,r] = RC_ObsvMatrix(A,C)
%   RC_ObsvMatrixTest        - script <a href="matlab:RC_ObsvMatrixTest">RC_ObsvMatrixTest</a>
%   RC_ObsvGrammian          - function [Q,r] = RC_ObsvGrammian(A,C,[MODE])
%   RC_ObsvGrammianTest      - script <a href="matlab:RC_ObsvGrammianTest">RC_ObsvGrammianTest</a>
%   RC_SS2CanonicalForm      - function [A,B,C,r1,r2,r3,r4]=RC_SS2CanonicalForm(A,B,C,FORM)
%   RC_SS2CanonicalFormTest  - script <a href="matlab:RC_SS2CanonicalFormTest">RC_SS2CanonicalFormTest</a>
%   RC_BalancedForm          - function [A,B,C,HankelSingValues]=RC_BalancedForm(A,B,C,[MODE])
%   RC_BalancedFormTest      - script <a href="matlab:RC_BalancedFormTest">RC_BalancedFormTest</a>
% <a href="matlab:help RCchap19"><-previous</a> ---------- please read the <a href="matlab:help RCcopyleft">copyleft</a>, and please <a href="matlab:help RCsupport">support</a> us! ----------- <a href="matlab:help RCchap21">next-></a>
