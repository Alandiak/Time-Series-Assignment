function std = getStd(data, row, mean)
    % gets the std of a row
    std = 0;
    for i = 1:60
        x = data(row,i)-mean;
        x = x*x;
        std = std + x; 
    end
    std = sqrt(std/60);
end
