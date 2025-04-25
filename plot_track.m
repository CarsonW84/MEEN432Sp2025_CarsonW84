% Plot the track centerline
figure('Units', 'normalized', 'OuterPosition', [0 0 1 1]);
plot(track_data.X, track_data.Y, 'r--', 'LineWidth', 2); 
axis equal;
xlabel('X Position [m]');
ylabel('Y Position [m]');
title('Race Track');
grid on;
hold on;

time_step = 0.2;
set_param('Project_4_Model','SolverType', 'Fixed-step');
set_param('Project_4_Model', 'FixedStep', 'time_step');
set_param('Project_4_Model', 'Solver', 'ode4');

simOut = sim('Project_4_Model.slx');
car.X_data = simOut.X.Data;
car.Y_data = simOut.Y.Data;
car.vx_data = simOut.vx.Data;
car.vy_data = simOut.vy.Data;
car.psi_data = simOut.psi.Data;
car.delta_f = simOut.delta_f.Data;
car.SOC = simOut.SOC.Data;
Time = simOut.tout;

    for i = 1:length(car.X_data)
    % Create car shape
    car.verts = create_car_vertices(car.X_data(i), car.Y_data(i), car.psi_data(i));
    car.shape = polyshape(car.verts(:,1), car.verts(:,2));

    % Clear previous car and plot new one
    cla;  % Clears previous frame but keeps the track
    
    % Plot track boundaries and car
    plot(track_data.X, track_data.Y, 'r--', 'LineWidth', 2); % Re-draw track
    plot(track_data.X_outer, track_data.Y_outer, 'k-', 'LineWidth', 1.5);
    plot(track_data.X_inner, track_data.Y_inner, 'k-', 'LineWidth', 1.5);
    plot(car.shape, 'FaceColor', 'blue', 'FaceAlpha', 0.7, 'Edgecolor', 'black');
    
    % Pause to simulate real-time movement
    pause(0.001);
    end 

% Banking
rampRate = 0.0005;
if (car.X_data > 900)
    if car.Y_data < 100
        car.bankAngle = min(car.bankAngle + rampRate, .17453);
    else
        car.bankAngle = max(car.bankAngle - rampRate, 0);
    end

elseif (car.X_data < 0)
    if car.Y_data > 100
        car.bankAngle = min(car.bankAngle + rampRate, .17453);
    else
        car.bankAngle = max(car.bankAngle - rampRate, 0);
    end

else
    banking_angle_deg = 0;
end