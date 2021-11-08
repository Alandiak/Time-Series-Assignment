function mean = getMean(data, row)
    % gets the mean value of a row
    mean = 0;
    for i = 1:60
       mean = mean + data(row, i); 
    end
    mean = mean/60;
end

