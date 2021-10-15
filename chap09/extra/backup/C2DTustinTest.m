% script <a href="matlab:C2DTustinTest">C2DTustinTest</a>
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 17.4.4.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap17">Chapter 17</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.

format long
disp('This routine tests the Tustin conversion on a notch filter with imaginary poles.')
bs=Poly([-1 -1]), as=[1 0 1], h=1, Exact_Mapping_of_Poles=exp(Roots(as)*h), disp(' ')
disp('Tustin conversion without prewarping:')
[bz,az]=C2DTustin(bs,as,h),   bz_roots=Roots(bz), az_roots=Roots(az), mag=abs(az_roots), disp(' ')
disp('Tustin conversion with prewarping about omegacrit=1:')
[bz,az]=C2DTustin(bs,as,h,1), bz_roots=Roots(bz), az_roots=Roots(az), mag=abs(az_roots), disp(' ')

% end script C2DTustinTest