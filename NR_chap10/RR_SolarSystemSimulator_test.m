clear; global RR_VERBOSE

Tmax=1.8808; sy=365.256363004; RR_VERBOSE=false; format long
fprintf('Lets do some simulations of our solar system over %g Earth years.\n',Tmax)

for i=1:3 
	switch i, case 1, kmax(i)=round(Tmax*sy/25);
			  case 2, kmax(i)=round(Tmax*sy/5);
			  case 3, kmax(i)=round(Tmax*sy);
	end, h(i)=Tmax*sy/kmax(i);
	fprintf('Do coarse SI4 and RK4 simulations with kmax=%g, and thus h=%0.5g days\n',kmax(i),h(i))
	[q,e]=RC_SolarSystemSimulator('SI4',Tmax,kmax(i)); mars_SI4(:,i)=q(5,:,end)'; energy_SI4(i)=e(end);
	[q,e]=RC_SolarSystemSimulator('RK4',Tmax,kmax(i)); mars_RK4(:,i)=q(5,:,end)'; energy_RK4(i)=e(end);
end

k_truth=round(Tmax*sy*24*60); h_truth=Tmax/k_truth*(sy*24*60);
fprintf('Now, do an truth simulation with kmax=%g, and thus h=%0.6g minute\n',kmax,h_truth)
disp('(Please be patient, this takes a while...)')
[q_truth,energy_truth]=RC_SolarSystemSimulator('RK4',Tmax,k_truth); mars_truth=q_truth(5,:,end)';
energy_begin=energy_truth(1), energy_truth_end=energy_truth(end)

for i=1:3
	mars_SI4_error(i)=norm(mars_SI4(:,i)-mars_truth); energy_SI4_error(i)=norm(energy_SI4(i)-energy_begin);
	mars_RK4_error(i)=norm(mars_RK4(:,i)-mars_truth); energy_RK4_error(i)=norm(energy_RK4(i)-energy_begin);
end
mars_SI4, mars_RK4, mars_SI4_error, mars_RK4_error, energy_SI4_error, energy_RK4_error

figure(1); clf; loglog(h,mars_SI4_error,'b*-.'), hold on
                loglog(h,mars_RK4_error,'ro-'),  grid
SI4_slope=(log(mars_SI4_error(3))-log(mars_SI4_error(1)))/(log(kmax(3))-log(kmax(1)))
RK4_slope=(log(mars_RK4_error(3))-log(mars_RK4_error(1)))/(log(kmax(3))-log(kmax(1)))
figure(2); clf; loglog(h,energy_SI4_error,'b*-.'), hold on
                loglog(h,energy_RK4_error,'ro-'),  grid

