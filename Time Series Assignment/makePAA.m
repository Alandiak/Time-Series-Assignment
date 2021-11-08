function paa= makePAA(c,data)

% This function creates a PAA with intervals of size c, used to model the data and
% reduce the number samples needed to represent the data.

    % initializes the PAA
    dimension = size(data);
    rows = dimension(1);
    cols = dimension(2)/c;
    cols = ceil(cols); % Number of columns in the PAA
    paa = zeros(rows, cols);

    % Converts each control chart to a PAA
    for row = 1:rows
        pos = 1;
        % For each row there will be cols time segments
        for col = 1:cols
            % Finds the average of the current time segment
            sum = 0.0;
            count = 0;
            while (pos <= col*c && pos <= dimension(2))
                sum = sum + data(row, pos);
                count = count + 1;
                pos = pos + 1;
            end
            paa(row, col) = sum/count;
        end
    end

end

