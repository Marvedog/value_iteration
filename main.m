%% Detailed description goes here
% ---------------------------------------------------------------------
% This is the initialization file of the project. Running this file will
% run everything and plot the results.
% ---------------------------------------------------------------------
% Runs value iteration algorithm. The concept is the following:
% --- > A 3d grid is defined representing a environment with obstacles.
% --- > The goal is to avoid obstacles and stop within a hollow cube.
% --- --- > Such an end goal will be represented as the path with the
% --- ---   largest reward.
% ---------------------------------------------------------------------

%clc
clear all 
close all
%% Define parameters for the problem

p_start = [1 0 1];

% Grid
%----------------------------------------------------------
% Fov is defined forward along x-axes
% param row gives fov forward
% param col +- gives fov in y directions
% param h +- gives field of view in z direction
% param l is a discount factor
row = 20; % Global x-axes
col = 6; % Global y-axes
h = 6; % Global z-axes
%----------------------------------------------------------

% Solver params
%----------------------------------------------------------
solverparams.discount = 0.99;
solverparams.maxIt = 500;
solverparams.relativeTolerance = 1e-03;
%----------------------------------------------------------

%% Objects not to be hit
%----------------------------------------------------------

% Box creation
box1.center = [5,0,0];
box1.size = 2;
box1.type = 'box';
box1.reward = -1;

% Hollow box (~cylinder)
cylinder1.center = [15,0,0];
cylinder1.r = 2;
cylinder1.h = 4;
cylinder1.type = 'hollow_sylinder';
cylinder1.reward_edge = -1;
cylinder1.reward_center = 1;

objects = {box1, cylinder1};

%% Define possible actions and probabilities.
%----------------------------------------------------------

% Five possible actions 
% 1. Move up
% 2. Move down
% 3. Move left
% 4. Move right
% 5. Move forwards
% 6. Move backwards
% 7. Stay put

% Define probability if the different actions, given the desired action
% The robot can't move backwards 
p(1,:) = [0.70 , 0.05 , 0.05 , 0.05 , 0.05 , 0.05 , 0.05];
p(2,:) = [0.05 , 0.70 , 0.05 , 0.05 , 0.05 , 0.05 , 0.05];
p(3,:) = [0.05 , 0.05 , 0.70 , 0.05 , 0.05 , 0.05 , 0.05];
p(4,:) = [0.05 , 0.05 , 0.05 , 0.70 , 0.05 , 0.05 , 0.05];
p(5,:) = [0.05 , 0.05 , 0.05 , 0.05 , 0.70 , 0.05 , 0.05];
p(6,:) = [0.05 , 0.05 , 0.05 , 0.05 , 0.05 , 0.70 , 0.05];
p(7,:) = [0.15 , 0.15 , 0.15 , 0.15 , 0.15 , 0.15 , 0.10];


[start, reward, forbidden] = rewards3d(objects, row, col, h, true);
[grid, solverinfo] = valueIteration(reward, forbidden, p, row, col, h, solverparams);
[path] = bestPath(grid, start + p_start);
run('plotit.m');