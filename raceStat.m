function [laps_completed, total_laps, lap_times, total_time, out_of_bounds] = raceStat(X, Y, Time, track_data, SOC)
    % Function to analyze race statistics
    % Inputs:
        % X, Y: Vehicle coordinates over time
        % Time: Simulation time vector
        % track: struct containing track data
    % Outputs:
        % laps_completed: Total number of laps completed
        % total_laps: Number of total laps (including parial laps)
        % lap_times: Total time taken for each lap
        % total_time: Total time from start to end
        % out_of_bounds: Boolean array indicating whether the car is off track

    % Calculate track centerline distance
    track_length = (2 * track_data.L) + (2 * pi * track_data.R);

    % Compute vehicle's distance along track
    s = zeros(size(X));
    for i = 2:length(X)
        s(i) = s(i - 1) + sqrt((X(i) - X(i - 1))^2 + (Y(i) - Y(i - 1))^2);
    end
    
    % Check if the car went out of bounds at any point
    out_of_bounds = false(size(X));
    for i = 1:length(X)
        % Find the nearest point on the track centerline
        distances = sqrt((track_data.X - X(i)).^2 + (track_data.Y - Y(i)).^2);
        [min_dist, ~] = min(distances);

        % Check if the car is outside the track width
        if min_dist > (track_data.W / 2)
            out_of_bounds(i) = true;
        end
    end

    % Count completed and partial laps
    total_laps = s(end) / track_length;
    laps_completed = floor(total_laps);
    partial_lap = total_laps - laps_completed;

    % Store lap times
    lap_times = [];
    lap_start_indices = [1]; % 1st lap starts at time 0

    % Identify lap start indices
    for lap = 1:laps_completed
        lap_start_idx = find(s >= lap * track_length, 1, 'first');
        lap_start_indices = [lap_start_indices; lap_start_idx'];
    end

    % Calculate lap times
    for i = 1:length(lap_start_indices) - 1
        lap_times(i) = Time(lap_start_indices(i+1)) - Time(lap_start_indices(i));
    end

    % If there's a partial lap, add its duration
    if partial_lap > 0
        partial_lap_time = Time(end) - Time(lap_start_indices(end));
        lap_times = [lap_times, partial_lap_time];
    end

    % Calculate total completion time
    total_time = sum(lap_times);

    % Display results
    fprintf('Full Laps Completed: %d\n', laps_completed);
    fprintf('Total Laps (Including Partial): %.2f\n', total_laps);
    
    for i = 1:length(lap_times)
        if i <= laps_completed
            fprintf('Lap %d Completion Time: %.2f seconds\n', i, lap_times(i));
        else
            fprintf('Lap %d (Partial Lap) Completion Time: %.2f seconds\n', i, lap_times(i));
        end
    end
    
    fprintf('Total Completion Time: %.2f seconds\n', total_time);
    
    % Requirements Summary
    fprintf('\n-----Requirements Summary-----\n')
    % Bounds Requirements
    if any(out_of_bounds)
        fprintf('❌ Warning: Vehicle went off track!\n');
    else
        fprintf('✅ Vehicle remained on track.\n');
    end

    % SOC Requirements
    if SOC > 0.95
        fprintf('❌ Warning: Vehicle exceeded max SOC requirement\n')
    elseif SOC < 0.1
        fprintf('❌ Warning: Vehicle dropped below min SOC requirement\n')
    else
        fprintf('✅ Vehicle remainded within SOC limits\n')
    end
end