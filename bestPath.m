function path = bestPath(grid, p_start)
%% bestPath
% Given a starting position, the best with most confidence will be
% computed.
% params grid is the converged grid after value iteration
% params start is the start point

%% Compute best path
path = p_start;
p = p_start;
moved = true;

% While the next step is not equal to the current (local optimum)
while (moved)
   
    % Store reward in all directions
    local_rewards = [ grid(p(1)+1,p(2),p(3));  % forward
                      grid(p(1)-1,p(2),p(3));  % backward
                      grid(p(1),p(2)+1,p(3));  % left
                      grid(p(1),p(2)-1,p(3));  % rifht
                      grid(p(1),p(2),p(3)+1);  % up
                      grid(p(1),p(2),p(3)-1)]; % down 
    [~, index] =  max(local_rewards);
    
    if (index == 1)
        p_tmp = [p(1)+1 p(2) p(3)];
    
    elseif (index == 2)
        p_tmp = [p(1)-1 p(2) p(3)];
        
    elseif (index == 3)
        p_tmp = [p(1) p(2)+1 p(3)];
        
    elseif (index == 4)
        p_tmp = [p(1) p(2)-1 p(3)];
        
    elseif (index == 5)
        p_tmp = [p(1) p(2) p(3)+1];
        
    elseif (index == 6)
        p_tmp = [p(1) p(2) p(3)-1];
    end
    
    if (ismember(p, p_tmp, 'rows')) 
        fprintf('-------------------------------------\n');
        fprintf('Local optimum reached!\n');
        fprintf('-------------------------------------\n');
        moved = false; 
    elseif (ismember(p_tmp, path, 'rows'))
        fprintf('-------------------------------------\n');
        fprintf('Cycle detected!\n');
        fprintf('-------------------------------------\n');
        moved = false;
    else
        path = [path ; p_tmp];
        p = p_tmp;
    end
end
end