function [roots]=RR_roots(p)
% Compute (dirctly!) the roots of a real or complex (!) polynomial p up to order 4.
% TEST: clear, for n=2:5
%         r=randn(1,n),              RR_roots(r), sort(roots(r),'ComparisonMethod','real')
%         c=randn(1,n)+i*randn(1,n), RR_roots(c), sort(roots(c),'ComparisonMethod','real')
p=p/p(1);                                     % simplify by first making p monic
switch length(p)
    case 1, roots=[];                         % trivial case
    case 2, roots=-p(2);                      % trivial case
    case 3, b=p(2); c=p(3); d=sqrt(b^2-4*c); roots=[(-b+d)/2; (-b-d)/2]; % quadratic formula (with a=1)
    % algorithm below from: https://math.stackexchange.com/questions/15865/why-not-write-the-solutions-of-a-cubic-this-way/18873#18873
    % which is simplified a bit here by first converting to depressed cubic form
    case 4, P=p(2); Q=p(3); R=p(4); q=Q-P^2/3; r=R+2*P^3/27-P*Q/3;
            A=((-27*r+3*sqrt(3*(4*q^3+27*r^2)))/2)^(1/3)/3;
            B=q/(3*A); s=sqrt(3)/2; t1=-0.5-i*s; t2=-0.5+i*s;
            roots=-P/3+[A-B; t1*A-t2*B; t2*A-t1*B]
    % algorithm below from: https://en.wikipedia.org/wiki/Quartic_equation#Summary_of_Ferrari's_method
    case 5, B=p(2); C=p(3); D=p(4); E=p(5);    % Note: A=1 because we made p monic above.
            if B==0, alpha=C; beta=D; gamma=E; % first convert to depressed quartic form
            else,    alpha=-3*B^2/8+C; beta=B^3/8-B*C/2+D; gamma=-3*B^4/256+C*B^2/16-B*D/4+E; end
            if beta==0
                d=sqrt(alpha^2-4*gamma); ep=sqrt((-alpha+d)/2); em=sqrt((-alpha-d)/2);
                roots=-B/4+[ep; -ep; em; -em];
            else
                P=-alpha^2/12-gamma;
                Q=-alpha^3/108+alpha*gamma/3-beta^2/8;
                R=-Q/2+sqrt(Q^2/4+P^3/27); U=R^(1/3);
                if U==0, y=-5*alpha/6-Q^(1/3);
                else,    y=-5*alpha/6+U-P/(3*U); end
                W=sqrt(alpha+2*y)/2; t=-(3*alpha+2*y)/4; s=-beta/(W*4);
                roots=-B/4+[W+sqrt(t+s); W-sqrt(t+s); -W+sqrt(t-s); -W-sqrt(t-s)];
            end
    otherwise, error('quintic or higher needs to be done iteratively!')
end
% roots=sort(roots,'ComparisonMethod','real');