function dists = euclidian(series1,matrix)
% Finds the euclidian distances between each time series in the matrix
% against series1
    s = size(matrix);
    dists = zeros(s(1), 1);
    for pos = 1:s(1)
        % Finds the euclidian distance between 2 time series
        dist = 0;
        for time = 1:length(series1)
           dist = dist + (series1(time) - matrix(pos, time))^2; 
        end
        dists(pos) = sqrt(dist);
    end
end

