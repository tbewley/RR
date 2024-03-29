% script <a href="matlab:RR_RFSTtest">RR_RFSTtest</a>
% Test <a href="matlab:help RR_RFST">RR_RFST</a> and <a href="matlab:help RR_RFSTinv">RR_RFSTinv</a> with random u.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.11.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RR_RFFTtest, RR_RFCTtest.

disp('Now testing RFST and RFSTinv on a random real vector')
N=8; u=randn(N-1,1); uhats=RR_RFST(u,N); u1=RR_RFSTinv(uhats,N);
original_u=u.', transformed=uhats.', transformed_back=u1.'
mean_square_of_u        =norm(u)^2/N
sum_of_squares_of_uhats =norm(uhats)^2/2
transform_error = norm(u-u1)
parseval_error  = (mean_square_of_u-sum_of_squares_of_uhats)^2                                                      

% end script RR_RFFTtest
