function FuzzyControllerProject(x, y, goal_x, goal_y)
    speed = 0.0;
    facing_angle = 0.0;
    time = 0;
    distance = dist(x, y, goal_x, goal_y);

    % Speed control options
    decrease = -1;
    maintain = 0;
    increase = 2;
    % and the option 'stop' is equal to negitive of speed

    % Angle control options
    left = 0.1;
    right = -0.1;

    % Starting state:
    fprintf("At %i00 ms: (%.4f, %.4f) Speed = %.4f m/s, Angle = %.4f radians and forward force: 0 N\n", time, x, y, speed, facing_angle);
    
    % Until the goal is reached: Update speed then the direction every 100ms.
    % The robot's radius is 5ft, so if distance is less than 5ft, the
    % goal is reached.
    while (distance > 5 || speed > 0.000001)
        % First working on finding acceleration.
        % setting up FIE Matrix
        FIE_Matrix = zeros(3, 3);
        FIE_Matrix(1, 1) = -speed;      % (arrived, stopped)
        FIE_Matrix(1, 2) = -speed;      % (arrived, slow)
        FIE_Matrix(1, 3) = -speed;      % (arrived, fast)
        FIE_Matrix(2, 1) = increase;    % (close, stopped)
        FIE_Matrix(2, 2) = maintain;    % (close, slow)
        FIE_Matrix(2, 3) = decrease;    % (close, fast)
        FIE_Matrix(3, 1) = increase;    % (far, stopped)
        FIE_Matrix(3, 2) = increase;    % (far, slow)
        FIE_Matrix(3, 3) = maintain;    % (far, fast)

        % getting the corresponding u values
        W_Matrix = zeros(3, 3);
        W_Matrix(1, 1) = min(arrived(distance), stopped(speed));
        W_Matrix(2, 1) = min(close(distance), stopped(speed));
        W_Matrix(3, 1) = min(far(distance), stopped(speed));
        W_Matrix(1, 2) = min(arrived(distance), slow(speed));
        W_Matrix(2, 2) = min(close(distance), slow(speed));
        W_Matrix(3, 2) = min(far(distance), slow(speed));
        W_Matrix(1, 3) = min(arrived(distance), fast(speed));
        W_Matrix(2, 3) = min(close(distance), fast(speed));
        W_Matrix(3, 3) = min(far(distance), fast(speed));

        % time to Defuz to get the acceleration
        W_sum = 0.0;
        numerator = 0.0;
        for row = 1:3
            for col = 1:3
                W_sum = W_sum + W_Matrix(row, col);
                numerator = numerator + W_Matrix(row, col) * FIE_Matrix(row, col);
            end
        end

        % update speed
        acceleration = numerator/W_sum;

        % time to update direction of robot
        theta = ang(x, y, goal_x, goal_y, facing_angle);

        % setting up FIE matrix
        FIE_Matrix = [left, right];

        % getting the corresponding u values
        W_Matrix = [0, 0];
        W_Matrix(1) = l(theta);
        W_Matrix(2) = r(theta);

        % time to Defuz to get the angle of rotation
        W_sum = 0.0;
        numerator = 0.0;
        for elem = 1:2
            W_sum = W_sum + W_Matrix(elem);
            numerator = numerator + W_Matrix(elem) * FIE_Matrix(elem);
        end

        rotation = numerator/W_sum;
        force = sqrt(speed*speed - 2*speed*(speed+acceleration)*cos(rotation) + (speed+acceleration)*(speed+acceleration))*10;

        fprintf("At %i00 ms: Weight of membership functions: Arrived=%.2f, Close=%.2f, Far=%.2f, Stopped=%.2f, Slow=%.2f, Fast=%.2f, Left:%.2f, Right:%.2f\n", time+1, arrived(distance), close(distance), far(distance), stopped(speed), slow(speed), fast(speed), l(theta), r(theta))
        % updating pos, time, angles, ect.
        time = time + 1;
        speed = speed + acceleration;
        facing_angle = facing_angle + rotation;
        x = x + speed*cos(facing_angle)/10;
        y = y + speed*sin(facing_angle)/10;
        distance = dist(x, y, goal_x, goal_y);

        fprintf("(%.4f, %.4f) New Speed = %.4f m/s, Angle = %.4f radians and New Forward Force: %.4f N\n", x, y, speed, facing_angle, force);
        
    end

    fprintf("Within 5ft of the goal (%i, %i)", goal_x, goal_y)
    % When the goal is reached the robot must stop
end

% Helper functions
function d = dist(x1, y1, x2, y2) % Finds distance between 2 points
    a = (x1-x2)^2+(y1-y2)^2;
    d = sqrt(a);
end

function a = ang(x1, y1, x2, y2, facing_angle) % Finds the angle difference between facing angle and goal
    if x1 == x2
        a = pi/2.0;
        if y1 > y2
            a = a + pi;
        end
    else
        a = atan((y1-y2)/(x1-x2));
        if (x2 < x1)
            a = a + pi;
        end
    end
    a = a - facing_angle;
    while a < 0
        a = a + 2.0*pi;
    end
end

% Fuzzy functions that dictate if the robot is arrived, close, or far from
% the goal.
function u = arrived(dist)
    if (dist <= 5)
        u = 1;
    else
        u = 0;
    end
end

function u = close(dist)
    if (dist <= 5)
        u = 0;
    else
        u = max(min(1, 6-dist/5), 0);
    end
end

function u = far(dist)
    if (dist <= 25)
        u = 0;
    else
        u = max(min(1, dist/5-5), 0);
    end
end

% Fuzzy functions that dictate if the robot is stopped, slow, or fast.
function u = stopped(speed)
    if (speed == 0)
        u = 1;
    else
        u = 0;
    end
end

function u = slow(speed)
    if (speed > 0)
        u = max(min(1, 1.2-speed/5), 0);
    else
        u = 0;
    end
end

function u = fast(speed)
    if (speed < 1)
        u = 0;
    else
        u = max(min(1, speed/5-0.2), 0);
    end
end

% Fuzzy functions that dictate if the robot is facing left or right of the
% target.
function u = r(theta)
    if (theta > pi)
        u = max(min(1, 2*pi-theta+0.3), 0);
    else
        u = max(0.3-theta, 0);
    end
end

function u = l(theta)
    if (theta <= pi)
        u = max(min(1, theta-0.3), 0);
    else
        u = max(theta-2*pi+0.3, 0);
    end
end