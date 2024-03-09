function FS_RCCSD                                    % Numerical Renaissance Codebase 1.0
figure(1); clf; axis([0 1 0 6]); hold on; format compact;
ep=1e-14; epim=ep*sqrt(-1);  f3=0.0035;
m=[-.09042 -.0892 -.086 -.08 -.07 -.058 -.04 -.02 0 .035 .075 .13 .225 .39 .67 1.15 2.4]';
for j=1:size(m,1);       % Loop over several interesting values of m;
  disp(sprintf('\nFalkner Skan profile for m = %0.5g',m(j)))
  f3=f3*1.125                   % This heuristic provides a good initial guess for f''(0)
  for i=1:15                    % Iteratively refine guess for f''(0)
    x=f3+epim; y=FS_March(x,0,m(j));     % Use complex-step method to determine derivative
    f3old=f3; f3=f3-real(y)*ep/imag(y)   % Update f''(0) using Newton-Raphson
    if abs(f3-f3old)<6e-16, break; end;  % Break out of loop if converged
  end
  disp(sprintf('Error in terminal condition = %0.5g',FS_March(f3,1,m(j)))); pause(0.001);
end
end % function FS_RCCSD.m
