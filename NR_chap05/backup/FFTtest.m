% test code.                                         % Numerical Renaissance Codebase 1.0

N=16; u=rand(N,1);
u0hat=FFT_CT_recursive(u,N,-1)/N;   u0=FFT_CT_recursive(u0hat,N,+1);
u1hat=FFT_CT_direct(u,N,-1);        u1=FFT_CT_direct(u1hat,N,+1);
u2hat=FFT_CT_nonreordering(u,N,-1); u2=FFT_CT_nonreordering(u2hat,N,+1);
s=log2(N); ind=bin2dec(fliplr(dec2bin([0:N-1]',s))); u2hat_reordered=u2hat(ind+1);
error0=norm(u0-u), error1=norm(u1-u), error2=norm(u2-u)
error_hat10=norm(u1hat-u0hat), error_hat21=norm(u2hat_reordered-u1hat)

N=128; r=100; u0=rand(N);
u=u0; tic, for j=1:r; uhat=FFT_CT_recursive(u,N,-1);     u=FFT_CT_recursive(uhat,N,+1);     end, toc
u=u0; tic, for j=1:r; uhat=FFT_CT_direct(u,N,-1);        u=FFT_CT_direct(uhat,N,+1);        end, toc
u=u0; tic, for j=1:r; uhat=FFT_CT_nonreordering(u,N,-1); u=FFT_CT_nonreordering(uhat,N,+1); end, toc

