
clear; % close all;

% Set up test value of parameters (replace with actual values!) for a DC motor plant
% of the form G(s) = k * omega_n^2 / (s^2+2*zeta*omega_n*s + omega_n^2) = b(s)/a(s)

% J=.01; b=.1; K=.01; R=1; L=.5; omega_n=sqrt((b*R+K^2)/J/L); zeta=.9; k=K/(J*L*(omega_n)^2);

k=33; zeta=.35; omega_n=0.9;

% Set up a lead/lag compensator designed for the above system,
% of the form D(s) = k_D * ((s+z_1)/(s+p_1))^n_1 * ((s+z_2)/(s+p_2))^n_2 = y(s)/x(s)

p_2=omega_n*10; z_2=p_2/8;    n_2=2;  % Lead compensation (centered at crossover)
z_1=z_2/3;      p_1=z_1/40;   n_1=2;  % Lag compensation  (well below crossover)
omega_c=sqrt(p_2*z_2)     % Target value for crossover (peak in phase of lead compensator)
k_D=1/abs( k*omega_n^2/((i*omega_c)^2+2*zeta*omega_n*(i*omega_c)+omega_n^2) * ...
           ((i*omega_c+z_1)/(i*omega_c+p_1))^n_1 * ... % This value of k_D gives crossover
           ((i*omega_c+z_2)/(i*omega_c+p_2))^n_2 );    % at the target value of omega_c

% Now build polynomials of the rational expressions G(s)=b(s)/a(s) and D(s)=y(s)/x(s)

bs=k*[omega_n^2];
as=[1 2*zeta*omega_n omega_n^2];
ys=k_D*PolyConv(PolyPower([1 z_1],n_1),PolyPower([1 z_2],n_2));
xs=    PolyConv(PolyPower([1 p_1],n_1),PolyPower([1 p_2],n_2));
numL=PolyConv(ys,bs); denL=PolyConv(xs,as); [numT,denT]=Feedback(numL,denL);

% Now draw Bode plot and step response of system

figure(1); clf; g.omega=logspace(-2,2,500); g.line=1;
g.style='k-'; Bode(numL,denL,g), hold on
g.style='r:'; Bode(bs,as,g)
g.style='b:'; Bode(ys,xs,g)
subplot(2,1,1); title('black=L(s), Red=G(s), Blue=D(s)')

figure(2), g.T=10; g.N=200; g.styleu='r--'; g.styley='b-'; g.styler='k:';
ResponseTF(numT,denT,1,g); title('Step response')

% figure(3), g.line=0; g.omega=logspace(-2,1.2,99); Bode(numT,denT,g);
% title('Closed-loop Bode Plot'); subplot(2,1,1);

h=.01; [bz,az]=C2DTustin(bs,as,h,omega_c)