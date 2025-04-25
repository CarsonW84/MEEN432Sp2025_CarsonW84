function track_data = generate_track()
%   Define track parameters
track_data.R = 200; % Radius of curved sections [m]
track_data.L = 900; % Length of straight sections [m]
track_data.W = 15; % Track width [m]
data_points_curves = track_data.R * pi;
data_points_straights = track_data.L;

% Define resolution for curves
theta = linspace(-pi/2, pi/2, data_points_curves);

% Define centerline points
x1 = linspace(0, track_data.L, data_points_straights); % First straight section
y1 = zeros(size(x1));
x1 = x1(1:end - 1); % remove last point to prevent duplication
y1 = y1(1:end - 1);

x2 = track_data.L + track_data.R*cos(theta); % First curved section
y2 = track_data.R*(1+sin(theta));
x2 = x2(1:end - 1); % remove last point to prevent duplication
y2 = y2(1:end - 1);

x3 = linspace(track_data.L, 0, data_points_straights); % Second straight section
y3 = 2*track_data.R*ones(size(x3));
x3 = x3(1:end - 1); % remove last point to prevent duplication
y3 = y3(1:end - 1);

x4 = -track_data.R*cos(theta); % Second curved section
y4 = track_data.R*(1-sin(theta));

bankAngle1 = zeros(size(x1));

%right turn bank angles ramping up, holding, and then back down
maxBankAngle = 0.17453; % 10 degrees in radians
rampFraction = 0.2;     % 20% of the points for ramp up and down

% For first curved section:
N2 = length(x2);
rampPts2 = round(rampFraction * N2);
holdPts2 = N2 - 2*rampPts2;
bankAngle2 = [linspace(0, maxBankAngle, rampPts2), ...
              maxBankAngle * ones(1, holdPts2), ...
              linspace(maxBankAngle, 0, rampPts2)];

bankAngle3 = zeros(size(x3));

%left turn bank angles ramping up, holding, and then back down
N4 = length(x4);
rampPts4 = round(rampFraction * N4);
holdPts4 = N4 - 2*rampPts4;
bankAngle4 = [linspace(0, maxBankAngle, rampPts4), ...
              maxBankAngle * ones(1, holdPts4), ...
              linspace(maxBankAngle, 0, rampPts4)];
track_data.bankAngle = [bankAngle1, bankAngle2, bankAngle3, bankAngle4];



% Combine all points
track_data.X = [x1, x2, x3, x4];
track_data.Y = [y1, y2, y3, y4];

% Compute gradients to get 2D tangent vectors along centerline
dx = gradient(track_data.X);
dy = gradient(track_data.Y);
speed = sqrt(dx.^2 + dy.^2);
dx = dx./speed;
dy = dy./speed;

% Create track boundaries
track_data.X_outer = track_data.X + (track_data.W/2) * -dy;
track_data.Y_outer = track_data.Y + (track_data.W/2) * dx;
track_data.X_inner = track_data.X - (track_data.W/2) * -dy;
track_data.Y_inner = track_data.Y - (track_data.W/2) * dx;

%% Plot track (Debugging)
% figure;
% hold on;
% plot(track_data.X, track_data.Y, 'b--');
% plot(track_data.X_outer, track_data.Y_outer, 'r');
% plot(track_data.X_inner, track_data.Y_inner, 'r');
% axis equal;
end