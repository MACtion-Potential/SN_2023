clc;
clear;
clear all;

matFilePath = "C:\Users\macke\OneDrive\Documents\MACKENZIE SCHOOL STUFF\MACtion Potential\EEG2\All_PX_VY_EEG_Ratings.mat";
data = load(matFilePath);
EEG_Ratings = data.All_PX_VY_EEG_Ratings;

%Everything below is for the first subject only
Subj1 = EEG_Ratings{1,1};
Subj1EEG = Subj1(1:8,:);
Subj1EEG = Subj1EEG';
meanSubj1EEG = mean(Subj1EEG);
meanCentSubj1EEG = Subj1EEG - meanSubj1EEG;
[rows, cols] = size(meanCentSubj1EEG);
NumRows80 = round(0.8*rows);
TrainingRowInds = randperm(rows,NumRows80);
Training = meanCentSubj1EEG(TrainingRowInds,:);

[mTraining, nTraining] = size(Training);
beta = nTraining/mTraining;
gamma = 1;
tau = gamma*sqrt(mTraining)*sqrt(2*(beta+1)+((8*beta)/(beta+1+sqrt((beta^2)+14*beta+1))));
[U_MeanCentTraining, S_MeanCentTraining, V_MeanCentTraining] = svd(Training, "econ");

PC_counter = 0;
for i = 1:nTraining
    if S_MeanCentTraining(i,i) >= tau
        PC_counter = PC_counter + 1;
    end
end

% NumPC = 2;
% V1_Training = V_MeanCentTraining(:,1);
% V2_Training = V_MeanCentTraining(:,2);
% 
% 
% t1_Training = MeanCentTraining*V1_Training;
% t2_Training = MeanCentTraining*V2_Training;
% 
% GoodBadTraining = data(TrainingRowInds,cols);
% MeanCentGoodBadTraining = [MeanCentTraining, GoodBadTraining];
% for i = 1:mTraining
%     if MeanCentGoodBadTraining(i,end) == 1
%         GoodTrainingInd(i) = i;
%     else
%         BadTrainingInd(i) = i;
%     end
% end
% 
% GoodTrainingInd = GoodTrainingInd(GoodTrainingInd ~= 0);
% BadTrainingInd = BadTrainingInd(BadTrainingInd ~= 0);
% t1_GoodTraining = t1_Training(GoodTrainingInd);
% t2_GoodTraining = t2_Training(GoodTrainingInd);
% t1_BadTraining = t1_Training(BadTrainingInd);
% t2_BadTraining = t2_Training(BadTrainingInd);
% 
% max_t1_bad = max(t1_BadTraining);
% ind_max_t1_bad = find(t1_BadTraining == max_t1_bad);
% t2_max_t1_bad = t2_BadTraining(ind_max_t1_bad);
% min_t1_bad = min(t1_BadTraining);
% ind_min_t1_bad = find(t1_BadTraining == min_t1_bad);
% t2_min_t1_bad = t2_BadTraining(ind_min_t1_bad);
% max_t2_bad = max(t2_BadTraining);
% ind_max_t2_bad = find(t2_BadTraining == max_t2_bad);
% t1_max_t2_bad = t1_BadTraining(ind_max_t2_bad);
% min_t2_bad = min(t2_BadTraining);
% ind_min_t2_bad = find(t2_BadTraining == min_t2_bad);
% t1_min_t2_bad = t1_BadTraining(ind_min_t2_bad);
% 
% %t1_span = linspace(-4,4);
% % Line between (max_t1_bad, t2_max_t1_bad) and (t1_max_t2_bad, max_t2_bad)
% m1 = (max_t2_bad-t2_max_t1_bad)/(t1_max_t2_bad-max_t1_bad);
% b1 = t2_max_t1_bad - m1*max_t1_bad;
% t1_span1 = linspace(max_t1_bad,t1_max_t2_bad);
% y1 = m1*t1_span1 + b1;
% line1 = @(x) m1*x + b1;
% % Line between (t1_max_t2_bad, max_t2_bad) and (min_t1_bad,t2_min_t1_bad)
% m2 = (t2_min_t1_bad-max_t2_bad)/(min_t1_bad-t1_max_t2_bad);
% b2 = max_t2_bad - m2*t1_max_t2_bad;
% t1_span2 = linspace(t1_max_t2_bad,min_t1_bad);
% y2 = m2*t1_span2 + b2;
% line2 = @(x) m2*x + b2;
% % Line between (min_t1_bad,t2_min_t1_bad) and (t1_min_t2_bad, min_t2_bad)
% m3 = (min_t2_bad-t2_min_t1_bad)/(t1_min_t2_bad-min_t1_bad);
% b3 = t2_min_t1_bad - m3*min_t1_bad;
% t1_span3 = linspace(min_t1_bad,t1_min_t2_bad);
% y3 = m3*t1_span3 + b3;
% line3 = @(x) m3*x + b3;
% % Line between (t1_min_t2_bad, min_t2_bad) and (max_t1_bad, t2_max_t1_bad)
% m4 = (t2_max_t1_bad-min_t2_bad)/(max_t1_bad-t1_min_t2_bad);
% b4 = min_t2_bad - m4*t1_min_t2_bad;
% t1_span4 = linspace(t1_min_t2_bad,max_t1_bad);
% y4 = m4*t1_span4 + b4;
% line4 = @(x) m4*x + b4;
% 
% markersize = 40;
% clf
% hold on
% scatter(t1_GoodTraining,t2_GoodTraining, markersize,'g', 'filled',  'd')
% scatter(t1_BadTraining,t2_BadTraining,markersize, 'r', 'filled')
% plot(t1_span1,y1, '-')
% plot(t1_span2,y2, '-')
% plot(t1_span3,y3, '-')
% plot(t1_span4,y4, '-')
% hold off
% 
% ValidationRowInds = setdiff(1:rows,TrainingRowInds);
% Validation = X(ValidationRowInds,:);
% [mValidation, nValidation] = size(Validation);
% MeanValidation = mean(Validation);
% MeanCentValidation = Validation;
% for i = 1:nValidation
%     MeanCentValidation(:,i) = Validation(:,i) - MeanValidation(i);
% end
% 
% [U_MeanCentValidation, S_MeanCentValidation, V_MeanCentValidation] = svd(MeanCentValidation, "econ");
% V1_Validation = V_MeanCentValidation(:,1);
% V2_Validation = V_MeanCentValidation(:,2);
% t1_Validation = MeanCentValidation*V1_Validation;
% t2_Validation = MeanCentValidation*V2_Validation;
% 
% GoodBadValidation = data(ValidationRowInds,cols);
% MeanCentGoodBadValidation = [MeanCentValidation, GoodBadValidation];
% GoodBadValidationPrediction = inpolygon(t1_Validation, t2_Validation, [t1_max_t2_bad, min_t1_bad, t1_min_t2_bad, max_t1_bad], [max_t2_bad,t2_min_t1_bad,min_t2_bad,t2_max_t1_bad]);
% MeanCentGoodBadValidationPrediction = [MeanCentValidation, GoodBadValidationPrediction];
% for i = 1:mValidation
%     if MeanCentGoodBadValidation(i,end) == 1
%         GoodValidationInd(i) = i;
%     else
%         BadValidationInd(i) = i;
%     end
%     if MeanCentGoodBadValidationPrediction(i,end) == 0
%         GoodValidationPredictionInd(i) = i;
%     else
%         BadValidationPredictionInd(i) = i;
%     end
% end
% 
% GoodValidationInd = GoodValidationInd(GoodValidationInd ~= 0);
% BadValidationInd = BadValidationInd(BadValidationInd ~= 0);
% t1_GoodValidation = t1_Validation(GoodValidationInd);
% t2_GoodValidation = t2_Validation(GoodValidationInd);
% t1_BadValidation = t1_Validation(BadValidationInd);
% t2_BadValidation = t2_Validation(BadValidationInd);
% 
% GoodValidationPredictionInd = GoodValidationPredictionInd(GoodValidationPredictionInd ~= 0);
% BadValidationPredictionInd = BadValidationPredictionInd(BadValidationPredictionInd ~= 0);
% t1_GoodValidationPrediction = t1_Validation(GoodValidationPredictionInd);
% t2_GoodValidationPrediction = t2_Validation(GoodValidationPredictionInd);
% t1_BadValidationPrediction = t1_Validation(BadValidationPredictionInd);
% t2_BadValidationPrediction = t2_Validation(BadValidationPredictionInd);
% 
% 
% clf
% subplot(2,1,1)
% scatter(t1_GoodValidation,t2_GoodValidation, markersize,'g', 'filled',  'd')
% hold on
% scatter(t1_BadValidation,t2_BadValidation,markersize, 'r', 'filled')
% plot(t1_span1,y1, '-')
% plot(t1_span2,y2, '-')
% plot(t1_span3,y3, '-')
% plot(t1_span4,y4, '-')
% hold off
% subplot(2,1,2)
% scatter(t1_GoodValidationPrediction,t2_GoodValidationPrediction, markersize,'g', 'filled',  'd')
% hold on
% scatter(t1_BadValidationPrediction,t2_BadValidationPrediction,markersize, 'r', 'filled')
% plot(t1_span1,y1, '-')
% plot(t1_span2,y2, '-')
% plot(t1_span3,y3, '-')
% plot(t1_span4,y4, '-')
% hold off