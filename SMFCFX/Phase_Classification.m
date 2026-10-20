clc
clear
format short
%% Load Feature-Extraction Phase Results
load('features_Corona.mat')
    temp = features;
    labels = ones(size(features,1),1);
load('features_Flu.mat')
    temp = [temp;features];
    labels = [labels;2*ones(size(features,1),1)];
load('features_Others.mat')
    temp = [temp;features];
load('labels_Others.mat')
    labels = [labels;labels_Others+2];
%% Feature-Matrix & Label
TEST = [temp,labels];
FINAL = temp;
cls = labels;
cls_name = unique(cls)';
[~, ~, idx_cls] = unique(cls);  
class_counts = histcounts(idx_cls, 1:numel(cls_name)+1);  
class_counts = class_counts';
allClasses = string(unique(cls)); 
classCounts = histcounts(categorical(cls));  
%% Validation & Feature Selection 
selectedData = FINAL(:,1:28);   % variable 1:84  
% selectedData = FINAL(:,71:84);
% selectedData = FINAL(:,1:14:84);
classLabels = unique(cls);  
numClasses = length(classLabels);
numFeatures = size(selectedData, 2);
k = 5;
cv_kfold = cvpartition(cls, 'KFold', k, 'Stratify', true);
%% Classification Decision-Tree
leave_range = 90;    % 31-200
classCounts = histcounts(cls, [classLabels; max(classLabels)+1]); 
invClassFreq = 1 ./ classCounts; 
classWeights = invClassFreq / sum(invClassFreq); 
sampleWeights = zeros(size(cls));
for c = 1:numClasses
    sampleWeights(cls == classLabels(c)) = classWeights(c);
end

trainF1PerClass = zeros(k, numClasses);
testF1PerClass = zeros(k, numClasses);
trainMacroF1 = zeros(k,1);
testMacroF1 = zeros(k,1);
for i = 1:k
    trainIdx = training(cv_kfold, i);  
    testIdx  = test(cv_kfold, i);
    
    trainX = selectedData(trainIdx, :);
    testX  = selectedData(testIdx, :);
    trainY = cls(trainIdx);
    testY  = cls(testIdx);

    sampleWeightsFold = sampleWeights(trainIdx);

    Mdl_DT = fitctree(trainX, trainY, ...
        'Weights', sampleWeightsFold, ...
        'SplitCriterion', 'deviance', ...
        'MaxNumSplits', leave_range);

    Ytrain = predict(Mdl_DT, trainX);
    Ytest = predict(Mdl_DT, testX);

    confTrain = confusionmat(trainY, Ytrain, 'Order', classLabels);
    confTest = confusionmat(testY, Ytest, 'Order', classLabels);

    trainF1PerClass(i, :) = compute_f1_per_class(confTrain);
    testF1PerClass(i, :) = compute_f1_per_class(confTest);

    trainMacroF1(i) = mean(trainF1PerClass(i, :));
    testMacroF1(i) = mean(testF1PerClass(i, :));

    missingTrainClasses = setdiff(classLabels, unique(trainY));
    missingTestClasses = setdiff(classLabels, unique(testY));
end

meanTestF1PerClass = mean(testF1PerClass, 1);  
% Bar chart
figure;
bar(meanTestF1PerClass);
xlabel('Class Index');
ylabel('Average Test F1 Score');
title('Average Per-Class F1 Score (Test Data)');
grid on;
ylim([0.80 1.0]);  
 set(gca,'XTick',1:1:30)
 set(gca,'XTickLabel',{'Corona','Flu','Norwalk','Coxsackie',...
'CrimeanCongo','Cytomegalo','Ebola','Encephalitis',...
'Hepatitis B','Hepatitis C','Varicella','HIV',...
'Lassa','Marburg','Mastadeno','Measles','Metapneumo','Mumps',...                
'Papilloma','Parainfluenza','Polio','Pox Monkey',...
'Respiro','Rhino','Rota','RSV','Rubella','Zika',...
'Yellow fever','Dengue'},...
'fontsize',14,'XTickLabelRotation',90);
%% Feature Importance
% FINAL = trainY;
% cls = Ytrain;

Mdl_final = fitctree(FINAL, cls, ...
        'Weights', sampleWeights, ...
        'SplitCriterion', 'deviance', ...
        'MaxNumSplits', leave_range);
view(Mdl_final, 'Mode', 'graph');

    
importance = predictorImportance(Mdl_final);

figure;
bar(importance);
xlabel('Feature Index');
ylabel('Importance');
title('Feature Importance of Decision Tree on 30-Class Data');

%% ROC
cvFinal = crossval(Mdl_final, 'KFold', 5);
[~, scores] = kfoldPredict(cvFinal);  

figure;
hold on;
numClasses = length(unique(cls));  
for classIdx = 1:numClasses
    [X, Y, ~, AUC(classIdx)] = perfcurve(cls, scores(:, classIdx), classIdx, 'XCrit', 'fpr', 'YCrit', 'tpr');
    plot(X, Y, 'DisplayName', ['Class ' num2str(classIdx) ' (AUC = ' num2str(AUC, '%.2f') ')']);
end
xlabel('False Positive Rate');
ylabel('True Positive Rate');
title('ROC Curve (5-Fold Cross-Validation)');
legend('show');
grid on;
hold off;

classnames = {'Corona','Flu','Norwalk','Coxsackie',...
'CrimeanCongo','Cytomegalo','Ebola','Encephalitis',...
'Hepatitis B','Hepatitis C','Varicella','HIV',...
'Lassa','Marburg','Mastadeno','Measles','Metapneumo','Mumps',...                
'Papilloma','Parainfluenza','Polio','Pox Monkey',...
'Respiro','Rhino','Rota','RSV','Rubella','Zika',...
'Yellow fever','Dengue'};

figure;
bar(AUC);
xlabel('Class','fontsize',24);
ylabel('AUC','fontsize',24);
title('AUC of One-vs-Others by DT','fontsize',30);
grid on;
ylim([0.95 1.0]);  
 set(gca,'XTick',1:1:30)
 set(gca,'XTickLabel',{'Corona','Flu','Norwalk','Coxsackie',...
'CrimeanCongo','Cytomegalo','Ebola','Encephalitis',...
'HepatitisB','HepatitisC','Varicella','HIV',...
'Lassa','Marburg','Mastadeno','Measles','Metapneumo','Mumps',...                
'Papilloma','Parainfluenza','Polio','Pox Monkey',...
'Respiro','Rhino','Rota','RSV','Rubella','Zika',...
'Yellowfever','Dengue'},...
'fontsize',14,'XTickLabelRotation',90);

