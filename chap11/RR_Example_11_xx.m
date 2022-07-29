% Example_18_xx

% Motor Parameters
K=0.0525;     % Motor torque constant [measured in N*m/A = V/(rad/s)] for the 50:1 Pololu Motors
R=7.22;       % Motor resistance [measured in ohms]
V_max=7.9;    % Power applied to the motor driver / H-bridge [measured in volts]
eff = 0.9     % Motor/ gearbox efficiency
d1=eff*K^2/R; % {d1,d2} are constants in the motor model  d1*omega(t) + tau(t) = -d2*u(t)
d2=eff*K*V_max/R;   % [see (19.11) in NR, taking tau=torque output, u\in[-1,1]=motor driver input, L=0].
                    % Note that omega(t)=d(phi(t)-theta(t))/dot is the speed of the motor on MIP,
                    % where theta is the angle of the MIP body and phi measures the rotation of the wheels.

% Wheel parameters
m_w=0.0262;       % Total mass of wheels (kg) (that is, twice the mass of a single wheel)
r=0.0352;         % Radius of wheels (m)
I_w=m_w*(r^2)/2;  % Moment of both wheels about their CM, approximated as uniform disks

% Vehicle parameters
m_b=0.249;        % Total mass of body (kg)
   % Configuration A: Battery at top:
   ell=0.065;        % Distance from axis of wheels to the CM of the body (m)
   I_b= 0.000341;    % Moment of inertia of MIP body about its CM (kg*m^2)

   % Configuration B: Battery in middle:
   % ell=0.0586;     % Distance from axis of wheels to the CM of the body (m)
   % I_b= 0.000312;  % Moment of inertia of body about its CM (kg*m^2)

   % Configuration C: Battery on bottom:
   % ell=0.0489;     % Distance from axis of wheels to the CM of the body (m)
   % I_b= 0.000269;  % Moment of inertia of body about its CM (kg*m^2)

g=9.81;           % Acceleration due to gravity

c1=m_b*r*ell;
c2a=I_b+m_b*ell^2;
c2b=m_b*g*ell;
c3=I_w+r^2*(m_b+m_w);
t1=c2a*c3-c1^2;
t2=c1+c3;
t2hat=c1+c2a;

disp('Constants in actual plant:')
k1=d2*(c1+c3)/t1
a2=d1*(2*c1+c2a+c3)/t1
a1=c2b*c3/t1
a0=d1*c2b/t1
k2=(c1+c2a)/t2
z1=sqrt(c2b/(t2*k2))


numG=[1]; denG=PolyConv([1 10],[1 -10]);
numD=380*[1 10]; denD=[1 20];

close all; figure(1); g.K=logspace(-1.5,3,400); g.axes=[-40 40 -40 40];
RLocus(numG,denG,numD,denD,g); print -depsc example_18_14a.eps

numGD=PolyConv(numG,numD); denGD=PolyConv(denG,denD);

figure(2); g.omega=logspace(0,2,400); g.line=0; g.style='b-';  Bode(numGD,denGD,g);

figure(3); [numH,denH]=Feedback(numGD,denGD);                  % Closed-loop System
P=PolyVal(denH,0)/PolyVal(numH,0);
g.T=1.5; g.h=.01; g.styleu='r--'; g.styley='k-'; ResponseTF(P*numH,denH,1,g)

h=.02; % Now transform to discrete time
[numGz,denGz]=C2Dzoh(numG,denG,h);
[numDz,denDz]=C2DTustin(numD,denD,h,13);

g.K=logspace(-1.5,3,400); g.axes=[-1.5 1.5 -1.5 1.5];
figure(4); RLocus(numGz,denGz,numDz,denDz,g); hold on; % zgrid;
r=1; c=0; w=c+r*exp(i*[0:pi/50:2*pi]); plot(real(w),imag(w),'b--') % Draw a simple circle
print -depsc example_18_14b.eps

d=h/2; numDelay=[d^2/12 -d/2 1]; denDelay=[d^2/12 d/2 1];
numGd=PolyConv(numG,numDelay); denGd=PolyConv(denG,denDelay);

figure(5); g.K=logspace(-1.5,4.5,300); g.axes=[-400 400 -400 400];
RLocus(numGd,denGd,numD,denD,g); print -depsc example_18_14c.eps

figure(6); g.K=logspace(-1.5,3,300); g.axes=[-40 40 -40 40];
RLocus(numGd,denGd,numD,denD,g); print -depsc example_18_14d.eps


