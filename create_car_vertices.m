function vertices = create_car_vertices(x, y, psi)
% Function to create car vertices
    % Create basic car vertices
    L = 15;
    W = 10;
    base_car = [-L/2, -W/2; L/2, -W/2; L/2, W/2; -L/2, W/2];

    % Rotation matrix
    R = [cos(-psi), -sin(-psi);
        sin(-psi), cos(-psi)];

    % Rotate and translate vertices
    rotated_car = base_car*R;
    vertices = [rotated_car(:,1) + x, rotated_car(:,2) + y];
end