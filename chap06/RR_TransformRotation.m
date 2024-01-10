
syms gamma beta alpha
q3a=[cos(alpha/2); 0; 0; sin(alpha/2)];
q1 =[cos(beta/2);  sin(beta/2);  0; 0];
q3b=[cos(gamma/2); 0; 0; sin(gamma/2)];
R313=QuaternionMultiply(q3a,QuaternionMultiply(q1,q3b))

q3=[cos(alpha/2); 0; 0; sin(alpha/2)];
q2=[cos(beta/2);  0; sin(beta/2); 0];
q1=[cos(gamma/2); sin(gamma/2); 0; 0];
R321=QuaternionMultiply(q3,QuaternionMultiply(q2,q1))

disp(' '); pause   % Transform from R_313 to R_q and back *********************************
q=(rand(4,1)-0.5); q=q/norm(q),

Rq= [q(1)^2+q(2)^2-q(3)^2-q(4)^2, 2*q(2)*q(3) - 2*q(1)*q(4)  , 2*q(2)*q(4) + 2*q(1)*q(3);
     2*q(2)*q(3) + 2*q(1)*q(4)  , q(1)^2-q(2)^2+q(3)^2-q(4)^2, 2*q(3)*q(4) - 2*q(1)*q(2);
     2*q(2)*q(4) - 2*q(1)*q(3)  , 2*q(3)*q(4) + 2*q(1)*q(2)  , q(1)^2-q(2)^2-q(3)^2+q(4)^2]

alpha =  atan2(q(2)*q(4) + q(1)*q(3),-(q(3)*q(4)-q(1)*q(2)))
beta  =  acos(q(1)^2-q(2)^2-q(3)^2+q(4)^2)
gamma =  atan2(q(2)*q(4) - q(1)*q(3),q(3)*q(4) + q(1)*q(2))

c1=cos(alpha);s1=sin(alpha);c2=cos(beta);s2=sin(beta);c3=cos(gamma);s3=sin(gamma)

R313 =[c1*c3 - c2*s1*s3, - c1*s3 - c2*c3*s1, s1*s2;
       c3*s1 + c1*c2*s3, c1*c2*c3 - s1*s3  , -c1*s2;
       s2*s3           , c3*s2             , c2]

q3a=[cos(alpha/2), 0, 0, sin(alpha/2)]
q1=[cos(beta/2), sin(beta/2), 0, 0]
q3b=[cos(gamma/2), 0, 0, sin(gamma/2)]

qt=QuaternionMultiply(q1,q3b);
q=QuaternionMultiply(q3a,qt); q

Rq= [q(1)^2+q(2)^2-q(3)^2-q(4)^2, 2*q(2)*q(3) - 2*q(1)*q(4)  , 2*q(2)*q(4) + 2*q(1)*q(3);
     2*q(2)*q(3) + 2*q(1)*q(4)  , q(1)^2-q(2)^2+q(3)^2-q(4)^2, 2*q(3)*q(4) - 2*q(1)*q(2);
     2*q(2)*q(4) - 2*q(1)*q(3)  , 2*q(3)*q(4) + 2*q(1)*q(2)  , q(1)^2-q(2)^2-q(3)^2+q(4)^2]

qt=[cos(alpha/2)*cos(beta/2)*cos(gamma/2) - cos(beta/2)*sin(alpha/2)*sin(gamma/2);
    sin(alpha/2)*sin(beta/2)*sin(gamma/2) + cos(alpha/2)*cos(gamma/2)*sin(beta/2);
    cos(gamma/2)*sin(alpha/2)*sin(beta/2) - cos(alpha/2)*sin(beta/2)*sin(gamma/2);
    cos(alpha/2)*cos(beta/2)*sin(gamma/2) + cos(beta/2)*cos(gamma/2)*sin(alpha/2)]

disp(' '); pause; % Transform from R_321 to R_q and back *********************************

q=(rand(4,1)-0.5); q=q/norm(q),

Rq= [q(1)^2+q(2)^2-q(3)^2-q(4)^2, 2*q(2)*q(3) - 2*q(1)*q(4)  , 2*q(2)*q(4) + 2*q(1)*q(3);
     2*q(2)*q(3) + 2*q(1)*q(4)  , q(1)^2-q(2)^2+q(3)^2-q(4)^2, 2*q(3)*q(4) - 2*q(1)*q(2);
     2*q(2)*q(4) - 2*q(1)*q(3)  , 2*q(3)*q(4) + 2*q(1)*q(2)  , q(1)^2-q(2)^2-q(3)^2+q(4)^2]

alpha = atan2(2*q(2)*q(3) + 2*q(1)*q(4), q(1)^2+q(2)^2-q(3)^2-q(4)^2)
beta  = -asin(2*q(2)*q(4) - 2*q(1)*q(3))
gamma = atan2(2*q(3)*q(4) + 2*q(1)*q(2), q(1)^2-q(2)^2-q(3)^2+q(4)^2)

c1=cos(alpha);s1=sin(alpha);c2=cos(beta);s2=sin(beta);c3=cos(gamma);s3=sin(gamma)
R321=[c1*c2, c1*s2*s3-c3*s1,   s1*s3+c1*c3*s2;
      c2*s1, c1*c3 + s1*s2*s3, c3*s1*s2 - c1*s3;
        -s2, c2*s3,            c2*c3]

q3=[cos(alpha/2), 0, 0, sin(alpha/2)];
q2=[cos(beta/2),  0, sin(beta/2),  0];
q1=[cos(gamma/2), sin(gamma/2), 0, 0];

qt=QuaternionMultiply(q2,q1);
q=QuaternionMultiply(q3,qt); q

Rq= [q(1)^2+q(2)^2-q(3)^2-q(4)^2, 2*q(2)*q(3) - 2*q(1)*q(4)  , 2*q(2)*q(4) + 2*q(1)*q(3);
     2*q(2)*q(3) + 2*q(1)*q(4)  , q(1)^2-q(2)^2+q(3)^2-q(4)^2, 2*q(3)*q(4) - 2*q(1)*q(2);
     2*q(2)*q(4) - 2*q(1)*q(3)  , 2*q(3)*q(4) + 2*q(1)*q(2)  , q(1)^2-q(2)^2-q(3)^2+q(4)^2]

qt= [sin(alpha/2)*sin(beta/2)*sin(gamma/2) + cos(alpha/2)*cos(beta/2)*cos(gamma/2);
     cos(alpha/2)*cos(beta/2)*sin(gamma/2) - cos(gamma/2)*sin(alpha/2)*sin(beta/2);
     cos(alpha/2)*cos(gamma/2)*sin(beta/2) + cos(beta/2)*sin(alpha/2)*sin(gamma/2);
     cos(beta/2)*cos(gamma/2)*sin(alpha/2) - cos(alpha/2)*sin(beta/2)*sin(gamma/2)]



