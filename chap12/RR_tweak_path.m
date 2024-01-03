function [node,path]=RR_tweak_path(node,n,path,objective)

% Renaissance Robotics codebase, Chapter 12, https://github.com/tbewley/RR
% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License. 

% initialize logic tables
pair_flips{1}=[0; 1];
pair_order{1}=[1];
pair_flips{2}=[0 0; 0 1; 1 0; 1 1];
pair_order{2}=[1 2; 2 1];
pair_flips{3}=[0 0 0; 0 0 1; 0 1 0; 0 1 1; 1 0 0; 1 0 1; 1 1 0; 1 1 1];
pair_order{3}=[1 2 3; 1 3 2; 2 1 3; 2 3 1; 3 1 2; 3 2 1];

% update enumeration of links connected to each node (based on the path)


% main loop
for current_node=1:n
	num_pipes=node(current_node).num_pipes
	num_pairs=num_pipes/2-1;
	basic_order=[1:num_pipes]
	for flips=




% update enumeration of the path (based on the links connected to each node)

