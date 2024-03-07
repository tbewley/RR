function [u]=RR_RFSTinv(uhatS,N)
% function [u]=RR_RFSTinv(uhatS,N)
% Compute the inverse FST via applciation of Fact 5.6.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.11.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RR_RFST.  Verify with: RR_RFSTtest.

u=RR_RFST(uhatS,N)*N/2;     
end % function RR_RFSTinv
