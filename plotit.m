%% Plotting
% Detailed description goes here

% Rewards have coordinates equal to their index-pstart
[xdim,ydim,zdim] = size(reward);

% Define grids to plot
points_reward = start - [0, (ydim+1)/2, (zdim+1)/2];
points_grid = [];

% Define intensities associated to above grids
intensity = 0;
intensity_grid = [];

%% Store reward and grid data
for i=1:xdim
    for j =1:ydim
        for k=1:zdim
            if (reward(i,j,k) ~= 0)
                points_reward = [points_reward; [i,j,k]-start];
                intensity = [intensity; reward(i,j,k)];
                %points_grid = [points_grid; [i,j,k]-start];
                %intensity_grid = [intensity_grid; reward(i,j,k)];
            end
            
            if (grid(i,j,k) ~= 0)
                points_grid = [points_grid; [i,j,k]-start];
                intensity_grid = [intensity_grid; grid(i,j,k)];
            end
        end
    end
    
end

%% Normalize intensities
intensity_grid = intensity_grid/max(intensity_grid);

%% Plot initial rewards
figure(1)
% Plot initial reward
scatter3(points_reward(:,1), points_reward(:,2), points_reward(:,3), 100, intensity, 'filled');
title('Surface plot of rewards in 3d');
xlabel('x');
ylabel('y');
zlabel('z');

% plot path
hold on 
path = path - [0, (ydim+1)/2, (zdim+1)/2];
scatter3(path(:,1), path(:,2), path(:,3), 100, zeros(1,length(path(:,1))));

%% Plot Values grid after convergence
figure(2)
scatter3(points_grid(:,1), points_grid(:,2), points_grid(:,3), 100, intensity_grid, 'filled');
title('Surface plot of converged grid in 3d');
xlabel('x');
ylabel('y');
zlabel('z');

%% Plot Convergence rate
figure(3)
plot(1:length(solverinfo.convergence_rate), solverinfo.convergence_rate);
title('Convergence rate value iteration');
xlabel('Iteration');
ylabel('Relative error');