function sol=RR_line_intersection(a1,b1,a2,b2,a3,b3)
% function sol=RR_line_intersection(a1,b1,a2,b2,a3,b3)
% Calculate (or, approximate) the point of intersection of 2 or 3 lines in nD,
% where each line is defined by two distinct points on the line.
% INPUTS: a1,b1 = column vectors on line #1
%         a2,b2 = column vectors on line #2
%         a3,b3 = column vectors on line #3 (OPTIONAL)
% OUTPUT: c     = point of (potentially, approximate) intersection of the lines
% NOTE:   makes some nice plots if you first execute
%             global RR_VERBOSE; RR_VERBOSE=1
%         (rotate the plot around a bit to get perspective on where things lie!)
% TEST:   RR_line_intersection(rand(2,1),rand(2,1),rand(2,1),rand(2,1))
%         RR_line_intersection(rand(3,1),rand(3,1),rand(3,1),rand(3,1))
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Packings)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

if nargin==6
  sol1=RR_line_intersection(a1,b1,a2,b2);
  sol2=RR_line_intersection(a1,b1,a3,b3);
  sol3=RR_line_intersection(a2,b2,a3,b3);
  sol=(sol1+sol2+sol3)/3;
else
  A=[a1-b1, b2-a2]; b=[b2-b1]; x=pinv(A)*b;
  c1=x(1)*a1+(1-x(1))*b1;  % closest point to line 2 on line 1
  c2=x(2)*a2+(1-x(2))*b2;  % closest point to line 1 on line 2
  sol=(c1+c2)/2;           % approximation to intersection
  global RR_VERBOSE
  if RR_VERBOSE>1, figure(3), hold on
    if length(b)==2
      plot([a1(1) b1(1)],[a1(2) b1(2)],'k-');
      plot([a2(1) b2(1)],[a2(2) b2(2)],'r-'); plot(sol(1),sol(2),'b*')
    elseif length(b)==3
      plot3([a1(1) b1(1)],[a1(2) b1(2)],[a1(3) b1(3)],'k-'); plot3(c1(1),c1(2),c1(3),'k*')
      plot3([a2(1) b2(1)],[a2(2) b2(2)],[a2(3) b2(3)],'r-'); plot3(c2(1),c2(2),c2(3),'r*')
      plot3(sol(1),sol(2),sol(3),'b*')
    else, error('Need vectors of length 2 or 3 to plot')
    end, axis equal, axis tight
  end
end