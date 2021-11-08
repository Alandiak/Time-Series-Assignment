function [dataTrain,dataTest,trainLabel,testLabel] = splitData(data)
% the first 90% of each class in the data becomes part of the training set, while the last 10% becomes
% part of the testing set.
    s = size(data);
    dataTrain = zeros(540, s(2));
    dataTrain(1:90,:) = data(1:90,:);
    dataTrain(91:180,:) = data(101:190,:);
    dataTrain(181:270,:) = data(201:290,:);
    dataTrain(271:360,:) = data(301:390,:);
    dataTrain(361:450,:) = data(401:490,:);
    dataTrain(451:540,:) = data(501:590,:);
    
    dataTest = zeros(60, s(2));
    dataTest(1:10,:) = data(91:100,:);
    dataTest(11:20,:) = data(191:200,:);
    dataTest(21:30,:) = data(291:300,:);
    dataTest(31:40,:) = data(391:400,:);
    dataTest(41:50,:) = data(491:500,:);
    dataTest(51:60,:) = data(591:600,:);
    trainLabel = zeros(540, 1);
    testLabel = zeros(60, 1);
    
    trainpos = 1;
    testpos = 1;
    for pos = 0:599
        if rem(pos, 100) < 90 %puts labels for the training set
            trainLabel(trainpos) = floor(pos/100)+1;
            trainpos = trainpos + 1;
        else %puts labels for the testing set
            testLabel(testpos) = floor(pos/100)+1;
            testpos = testpos + 1;
        end
    end
end

