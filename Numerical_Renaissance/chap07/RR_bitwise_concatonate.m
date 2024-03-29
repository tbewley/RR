function hash_fn=RR_generate_hash_fn(data,N_bits,N_data)
% INPUTS: 
%    N_bit = Total # of bits per piece of data
%    N_data= Total # of pieces of data
%    data  = integer vector of length N_data, with each integer within the limits
%            defined by an N_bit 2's complement binary representation
% OUTPUT: 
%    hash_fn = a hash function generated by the data.  Defining N_hash = N_bits*N_data,
%              N_hash <= 54 generates hash_fn as a single integer
%              54 < N_hash <= 108 generates hash_fn as a pair of integers
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap01
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 

N_hash=N_bits*N_data;                    % PART A: Calculate total length of hash function.
data_b=num2bin(q_bit,data);              % Convert this data to binary form
data_b                                   % Print data_b to the screen (if you care, comment out if not)

hash=''; for i=1:N_bits, for j=1:N_data  % PART B: Build a hash function that interleaves the bits of
    hash=cat(2,hash,b(j,i));             % the data from Part A. This will likely minimize collisions
end, end                                 % when mapping thousands of hash functions to memory locations.
hash                                     % Print hash to the screen (if you care, comment out if not)

if N_hash<=54
  q_hash=quantizer('fixed',[N_hash 0]);  % PART C: convert hash function of Part B to a single integer 
  hash_fn=bin2num(q_hash,hash);          % <- This is the useful form of the single integer hash function
else
  q_hash2=quantizer('fixed',[N_hash/2 0]); % PART D: convert hash function of Part B to two integers
  half_hash=ceil(N_hash/2);                % (we need to do this when N_hash>54, and Part C fails...)
  hash_fn(1)=bin2num(q_hash2,hash(1:half_hash));     % <- This is the useful form 
  hash_fn(2)=bin2num(q_hash2hash(half_hash+1:end);   % of the two-integer hash function
end

end % function RR_generate_hash_fn