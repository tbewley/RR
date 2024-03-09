% test_brack.m
% Tests the bisection, false position, and Newton routines for
% finding the root of a scalar nonlinear function.

% First, compute a bracket of the root.
clear;  [x_lower,x_upper] = find_brack;

% Prepare to make some plots of the function on this interval
xx=[x_lower : (x_upper-x_lower)/100 : x_upper];
for i=1:101, yy(i)=compute_f(xx(i)); end
x1=[x_lower x_upper];  y1=[0 0];

x_tol = 0.0001;           % Set tolerance desired for x.
x_lower_save=x_lower;  x_upper_save=x_upper;

fprintf('\n Now testing the bisection algorithm.\n');
figure(1); clf; plot(xx,yy,'k-',x1,y1,'b-');  hold on; grid;
title('Convergence of the bisection routine')
bisection
evals,  hold off

fprintf(' Now testing the false position algorithm.\n');
figure(2); clf; plot(xx,yy,'k-',x1,y1,'b-');  hold on; grid;
title('Convergence of false position routine')
x_lower=x_lower_save;
x_upper=x_upper_save;
false_pos
evals,  hold off

fprintf(' Now testing the Newton-Raphson algorithm.\n');
figure(3); clf; plot(xx,yy,'k-');  hold on; grid;
title('Convergence of the Newton-Raphson routine')
x=init_x;
newt
% Finally, an extra bit of plotting stuff to show what happens:
x_lower_t=min(x_save);  x_upper_t=max(x_save);
xx=[x_lower_t : (x_upper_t-x_lower_t)/100 : x_upper_t];
for i=1:101, yy(i)=compute_f(xx(i)); end
plot(xx,yy,'k-',x_save(1),f_save(1),'ko'); pause
for i=1:size(x_save)-1
  plot([x_save(i) x_save(i+1)],[f_save(i) 0],'k--', ...
       x_save(i+1),f_save(i+1),'ko')
  pause
end;
evals,  hold off
% end test_brack.m
