function dists = manhattan(series1,matrix)
% Finds the sum of the manhattan distances between each time series in the matrix
% against series1
    s = size(matrix);
    dists = zeros(s(1), 1);
    for pos = 1:s(1)
        % Finds the manhatten distance between 2 time series
        dist = 0;
        for time = 1:length(series1)
           dist = dist + abs(series1(time) - matrix(pos, time)); 
        end
        dists(pos) = dist;
    end
end


