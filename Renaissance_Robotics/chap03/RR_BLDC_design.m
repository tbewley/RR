function RR_BLDC_design(ns_min,ns_max,np_min,np_max)
% function RR_BLDC_design(ns_min,ns_max,np_min,np_max)
% Computes tables of parameters relevant to BLDC motor design.
% INPUT:  ns_min,ns_max=range for number of slots (multiples of 3)
%         np_min,np_max=range for number of poles (multiples of 2)
% EXAMPLE CALL: RR_BLDC_design(6,36,4,34)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 3)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

ns=[ns_min:3:ns_max]; np=[np_min:2:np_max];
n_ns=length(ns); n_np=length(np); n=1; sigma=pi/3;
for i=1:n_ns, for j=1:n_np
    q(i,j)=ns(i)/(3*np(j));
    u(i,j)=gcd(ns(i),np(j));
    z(i,j)=ns(i)/(3*u(i,j));
    c(i,j)=lcm(ns(i),np(j));
    gamma(i,j)  =pi/(3*q(i,j));
    epsilon(i,j)=pi-gamma(i,j);
    kp1(i,j)    =cos(n*epsilon(i,j)/2);
    kd1(i,j)    =sin(n*sigma/2)/(z(i,j)*sin(n*sigma/(2*z(i,j))));
    kw1(i,j)    =kp1(i,j)*kd1(i,j);
    uz_out(i,j) =".";
    c_out(i,j)  =".";
    kw1_out(i,j)=".";
    if q(i,j)>=0.25 & q(i,j)<=0.5,
       if     ns(i)==np(j),                   uz_out(i,j)="EQ!";
       elseif u(i,j)==1,                      uz_out(i,j)="SYM!";
       elseif abs(z(i,j)-round(z(i,j)))>0.01, uz_out(i,j)="BAL!";
       else
         uz_out(i,j) =string(int2str(u(i,j)))+","+string(int2str(z(i,j)));
         c_out(i,j)  =string(int2str(c(i,j)));
         kw1_out(i,j)=string(num2str(kw1(i,j)));
       end
    end
end, end
uz_out, c_out, kw1_out
