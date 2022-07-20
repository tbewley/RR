% script <a href="matlab:PartialFractionExpansionTest">PartialFractionExpansionTest</a>
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section B.6.3.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchapAB">Appendix B</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.

[p,d,k,n]=NR_PartialFractionExpansion([1 3 4],NR_PolyConv([1 2],[1 2],[1 3]))

% end script PartialFractionExpansionTest
