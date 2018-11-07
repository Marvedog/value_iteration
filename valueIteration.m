function [grid, solverinfo] = valueIteration(reward, forbidden, p, row, col, h, solverparams)
%% Value iteration
% Detailed descripttion goes here

%% Output data to be stored
solverinfo.convergence_rate = [];
solverinfo.iterations = solverparams.maxIt;

%% Initialize empty grid, update using value iteration
grid = zeros(row, 2*col + 1, 2*h + 1);


%% Iteration Algorithm
counter = 1;
while(counter <= solverparams.maxIt)
  
    V_diff = 0;
    for x = 2:(row-1)
        for y = 2:(2*col)
            for z = 2:(2*h)
                if (~ismember([x, y, z], forbidden, 'rows'))
                    % Get V
                    Vmax = getMaximumValue(grid, reward, p, x, y, z, solverparams.discount);
                    
                    %Convergence rate
                    V_diff = V_diff + abs(Vmax - grid(x,y,z));
                    
                    % Store data
                    grid(x,y,z) = Vmax;
                end
            end % z-axis
        end % y-axis
    end % x-axis
    solverinfo.convergence_rate = [solverinfo.convergence_rate; V_diff];
    if (counter > 1)
        if (abs(solverinfo.convergence_rate(counter) - solverinfo.convergence_rate(counter-1)) < solverparams.relativeTolerance)
            fprintf('---------------------------------------------\n');
            fprintf('Convergence reached with tolerance: %f\n', solverparams.relativeTolerance);
            fprintf('Number of iterations required: %d\n', counter + 1);
            fprintf('--------------------------------------------\n');
            solverinfo.iterations = counter + 1;
            break;
        end
    end
    counter = counter + 1;
end
end

%% Get best value.
function Vmax = getMaximumValue(grid,reward,p,x,y,z,l)
rewards = [reward(x,y,z+1), reward(x,y,z-1), reward(x,y+1,z), reward(x,y-1,z), reward(x+1,y,z), reward(x-1,y,z), reward(x,y,z)];
prev_val= [grid(x,y,z+1), grid(x,y,z-1), grid(x,y+1,z), grid(x,y-1,z), grid(x+1,y,z), grid(x-1,y,z), grid(x,y,z)];
Q = mtimes(p , (rewards + l*prev_val)');
Vmax = max(Q);
end