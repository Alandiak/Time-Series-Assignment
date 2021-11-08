data = getData(); %gets data from file into matrix form
N = 5; % size of PAA segments
paa = makePAA(N, data);
sax = makeSAX(N, 6, data);
% this plots the PAA of an increasing class, uncomment to view it
%paaplot(paa, data, N, 202)

% Trains the training data on the eucildian distance
[dataTrain,dataTest,trainLabel,testLabel] = splitData(data);
mdl=fitcknn(dataTrain, trainLabel, 'distance', @(x,y)euclidian(x,y), 'NumNeighbors', 1);
predictClass=predict(mdl,dataTest);

% uncomment the line below to see how the euclidian distance preforms on
% the given data
%c=confusionmat(testLabel,predictClass);
%confusionchart(c)

% Trains the training data on the manhattan distance
[dataTrain,dataTest,trainLabel,testLabel] = splitData(data);
mdl=fitcknn(dataTrain, trainLabel, 'distance', @(x,y)manhattan(x,y), 'NumNeighbors', 1);
predictClass=predict(mdl,dataTest);

% uncomment the lines below to see how the manhattan distance preforms on
% the given data
%c=confusionmat(testLabel,predictClass);
%confusionchart(c)

% Trains the training PAA on the euclidian distance
[dataTrain,dataTest,trainLabel,testLabel] = splitData(paa);
mdl=fitcknn(dataTrain, trainLabel, 'distance', @(x,y)euclidian(x,y), 'NumNeighbors', 1);
predictClass=predict(mdl,dataTest);

%c=confusionmat(testLabel,predictClass);
%confusionchart(c)

% Trains the training PAA on the manhattan distance
[dataTrain,dataTest,trainLabel,testLabel] = splitData(paa);
mdl=fitcknn(dataTrain, trainLabel, 'distance', @(x,y)manhattan(x,y), 'NumNeighbors', 1);
predictClass=predict(mdl,dataTest);

c=confusionmat(testLabel,predictClass);
confusionchart(c)