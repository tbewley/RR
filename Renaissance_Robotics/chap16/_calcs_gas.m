Mgas_H2=2.016/1000;
Mgas_He=4.003/1000;
Mgas_Earth=28.96/1000;
Mgas_Mars=43.34/1000;
Mgas_Titan=28.5/1000;

R_u = 8.3144598;

P_Earth=101300;
P_Mars=600;
P_Titan=146700;
T_Earth=288;
T_Mars=210;
T_Titan=95;
g_Earth=9.80;
g_Mars=3.71;
g_Titan=1.35;

rho_Earth     = P_Earth * Mgas_Earth / (T_Earth * R_u)
rho_Earth_H2  = P_Earth * 1.02 * Mgas_H2 / (T_Earth * R_u)
lift_Earth_H2 = rho_Earth - rho_Earth_H2
rho_Earth_He  = P_Earth * 1.02 * Mgas_He / (T_Earth * R_u)
lift_Earth_He = rho_Earth - rho_Earth_He

rho_Mars     = P_Mars * Mgas_Mars / (T_Mars * R_u)
rho_Mars_H2  = P_Mars * 1.02 * Mgas_H2 / (T_Mars * R_u)
lift_Mars_H2 = rho_Mars - rho_Mars_H2
rho_Mars_He  = P_Mars * 1.02 * Mgas_He / (T_Mars * R_u)
lift_Mars_He = rho_Mars - rho_Mars_He

rho_Titan     = P_Titan * Mgas_Titan / (T_Titan * R_u)
rho_Titan_H2  = P_Titan * 1.02 * Mgas_H2 / (T_Titan * R_u)
lift_Titan_H2 = rho_Titan - rho_Titan_H2
rho_Titan_He  = P_Titan * 1.02 * Mgas_He / (T_Titan * R_u)
lift_Titan_He = rho_Titan - rho_Titan_He
