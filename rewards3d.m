function [p_start, reward, forbidden] = rewards3d(objects, row, col, h, edge_rewards)
%% This function computes a reward grid in 3D with input objects
% It is able to handle two types of objects boxes and hollow sylinders
% Internals of boxes are given negative rewards as well as the walls
% of the sylinders. The center of the sylinder is given a reward 
% as well as the front of the sylinder.

% Make the value grid
reward = zeros(row, 2*col + 1, 2*h + 1);
p_start = [1, col + 1, h + 1];
forbidden = [];

for i = 1:length(objects)
    
    % Add box rewards
    if (strcmp(objects{i}.type, 'box')) 
        center = p_start + objects{i}.center;
        [reward, forbidden] = fillBoxRewards(reward, forbidden, center, objects{i}.size, objects{i}.reward);
    end

    % Add cylinder rewards
    if (strcmp(objects{i}.type,'hollow_sylinder'))
        center = p_start + objects{i}.center;
        [reward, forbidden] = fillHollowSylinderRewards(reward, forbidden, center, objects{i}.r, objects{i}.h, objects{i}.reward_edge, objects{i}.reward_center);
    end
    
    % Label edges as well
    if (edge_rewards)
        [reward] = fillEdgeRewards(reward);
    end
end
end

function [reward_table, forbidden] = fillBoxRewards(reward_table, forbidden, center, size, reward)
    
    % Bottom left corner of box from a map perspective
    blbox = center - [size, size, size];

    for i = 1:(2*size + 1)
        for j = 1:(2*size + 1)
            for k = 1:(2*size + 1)
                reward_table(blbox(1)+(i-2), blbox(2)+(j-1), blbox(3)+(k-1)) = reward;
                   forbidden = [forbidden; [blbox(1)+(i-2), blbox(2)+(j-1), blbox(3)+(k-1)]];
            end
        end
    end
end

function [reward_table, forbidden] = fillHollowSylinderRewards(reward_table, forbidden, center, r, h, reward_edge, reward_center)
   
    for k = 1:h
       
        % Fill vertical
        for i = 1:(2*r+1)
            reward_table(center(1)+(k-1), center(2)+r, center(3)+(i-(r+1))) = reward_edge;
            reward_table(center(1)+(k-1), center(2)-r, center(3)+(i-(r+1))) = reward_edge;
            forbidden = [forbidden; [center(1)+(k-1), center(2)+r, center(3)+(i-(r+1))]];
            forbidden = [forbidden; [center(1)+(k-1), center(2)-r, center(3)+(i-(r+1))]];
        end
        
        % Fill horizontal
        for j = 1:(2*r-1)
            reward_table(center(1)+(k-1), center(2)+(j-r), center(3)+r) = reward_edge;
            reward_table(center(1)+(k-1), center(2)+(j-r), center(3)-r) = reward_edge;
            forbidden = [forbidden; [center(1)+(k-1), center(2)+(j-r), center(3)+r]];
            forbidden = [forbidden; [center(1)+(k-1), center(2)+(j-r), center(3)-r]];
        end
        
        % Fill center
        for i = 1:(2*r-1)
            for j = 1:(2*r-1)
                reward_table(center(1)+(k-1), center(2)+(j-r), center(3)+(i-r)) = reward_center;
            end
        end
    end
end

function [reward_table] = fillEdgeRewards(reward_table)

    reward_table(:,:,1) = -1;
    reward_table(:,:,end) = -1;
    
    reward_table(:,1,:) = -1;
    reward_table(:,end,:) = -1;
    
    reward_table(1,:,:) = -1;
    reward_table(end,:,:) = -1;
    
end