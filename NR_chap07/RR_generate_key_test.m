% script RC_generate_key_test
% Generates a "key" from some signed integer data, for use in a dictionary (hash) function
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

clear, N_bits=10, N_data=6   % Setup.  Need N_bits*N_data<=64.
lower_limit=-2^(N_bits-1)+1  % The (signed) integer limits within which data must lie.
upper_limit= 2^(N_bits-1)-1   
fac=uint64(2^N_bits);  key=uint64(0);
offset32=int32(fac/2); offset64=int64(offset32)

% Generate some random int64 test data within these limits.
signed_data=randi([lower_limit upper_limit],1,N_data,'int32')
% Shift signed_data to the non_negative integers.
data=uint64(signed_data+offset32);

% The following single line generates the (uint64) key
for i=1:N_data; key=key+data(i)*fac^(i-1); end, key

% Extract data from the (uint64) key
for i=N_data:-1:1,
    data_check(i)=idivide(key,fac^(i-1),'floor');
    key=key-data_check(i)*fac^(i-1);
end
% Shift data_check back to signed integers.
signed_data_check=int64(data_check)-offset64
