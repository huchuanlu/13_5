function displayComparsion
clc;
clear;
addpath('./Evaluation/');

%%1--Video Name:
%%  Data sets reported in the TIP paper 
fileName = 'Occlusion1';
% fileName = 'Occlusion2';
% fileName = 'Caviar1';
% fileName = 'Caviar2';
% fileName = 'Car4';
% fileName = 'Singer1';
% fileName = 'DavidIndoor';
% fileName = 'Car11';
% fileName = 'Deer';
% fileName = 'Jumping';
% fileName = 'Lemming';
% fileName = 'Cliffbar';
%%  Additional data sets:
% fileName = 'DavidOutdoor';
% fileName = 'Stone';
% fileName = 'Girl';

%%2--Load data
filePath = [ '.\Results\' fileName '\' ];
%%(1)IPCA(IVT) Tracker
load([filePath fileName '_pca_rs.mat']); 
%%(2)L1 Tracker
load([filePath fileName '_l1_rs.mat']);
%%(3)PN Tracker
load([filePath fileName '_pn_rs.mat']);
%%(4)VTD Tracker
load([filePath fileName '_vtd_rs.mat']);
%%(5)MIL Tracker
load([filePath fileName '_mil_rs.mat']);
%%(6)Frag Tracker
load([filePath fileName '_frag_rs.mat']);
%%(7)My Tracker
load([filePath fileName '_srpca_rs.mat']);
%%(8)GT
load([filePath fileName '_gt.mat']);

%%3--Overlap Rate Evaluation
%%(1)IPCA(IVT) Tracker
[ overlapRatePCA ]   = overlapEvaluationQuad(pcaCornersAll, gtCornersAll, frameIndex);
%%(2)L1 Tracker
[ overlapRateL1 ]    = overlapEvaluationQuad(l1CornersAll, gtCornersAll, frameIndex);
%%(3)PN Tracker
[ overlapRatePN ]    = overlapEvaluationQuad(pnCornersAll, gtCornersAll, frameIndex);
%%(4)VTD Tracker
[ overlapRateVTD ]   = overlapEvaluationQuad(vtdCornersAll, gtCornersAll, frameIndex);
%%(5)MIL Tracker
[ overlapRateMIL ]   = overlapEvaluationQuad(milCornersAll, gtCornersAll, frameIndex);
%%(6)Frag Tracker
[ overlapRateFrag ]  = overlapEvaluationQuad(fragCornersAll, gtCornersAll, frameIndex);
%%(7)My Tracker
[ overlapRateSRPCA ] = overlapEvaluationQuad(srpcaCornersAll, gtCornersAll, frameIndex);
ORE = [];   %%Overlap Rate Evaluation
ORE.PCA   = overlapRatePCA;
ORE.L1    = overlapRateL1;
ORE.PN    = overlapRatePN;
ORE.VTD   = overlapRateVTD;
ORE.MIL   = overlapRateMIL;
ORE.Frag  = overlapRateFrag;
ORE.SRPCA = overlapRateSRPCA;
ORE_M = []; %%Overlap Rate Evaluation (Mean)
ORE_M.PCA   = mean(overlapRatePCA);
ORE_M.L1    = mean(overlapRateL1);
ORE_M.PN    = mean(overlapRatePN);
ORE_M.VTD   = mean(overlapRateVTD);
ORE_M.MIL   = mean(overlapRateMIL);
ORE_M.Frag  = mean(overlapRateFrag);
ORE_M.SRPCA = mean(overlapRateSRPCA)
ORE_S = []; %%Overlap Rate Evaluation (Successful Tracking Frames)
ORE_S.PCA   = sum(overlapRatePCA>0.5);
ORE_S.L1    = sum(overlapRateL1>0.5);
ORE_S.PN    = sum(overlapRatePN>0.5);
ORE_S.VTD   = sum(overlapRateVTD>0.5);
ORE_S.MIL   = sum(overlapRateMIL>0.5);
ORE_S.Frag  = sum(overlapRateFrag>0.5);
ORE_S.SRPCA = sum(overlapRateSRPCA>0.5);
save([fileName '_overlapRateEvaluation.mat'], 'ORE', 'ORE_M', 'ORE_S', 'frameIndex');

%%4--Center Error Evaluation
%%(1)IPCA(IVT) Tracker
[ centerErrorPCA ]   = centerErrorEvaluation(pcaCenterAll, gtCenterAll, frameIndex);
%%(2)L1 Tracker
[ centerErrorL1 ]    = centerErrorEvaluation(l1CenterAll, gtCenterAll, frameIndex);
%%(3)PN Tracker
[ centerErrorPN ]    = centerErrorEvaluation(pnCenterAll, gtCenterAll, frameIndex);
%%(4)VTD Tracker
[ centerErrorVTD ]   = centerErrorEvaluation(vtdCenterAll, gtCenterAll, frameIndex);
%%(5)MIL Tracker
[ centerErrorMIL ]   = centerErrorEvaluation(milCenterAll, gtCenterAll, frameIndex);
%%(6)Frag Tracker
[ centerErrorFrag ]  = centerErrorEvaluation(fragCenterAll, gtCenterAll, frameIndex);
%%(7)My Tracker
[ centerErrorSRPCA ] = centerErrorEvaluation(srpcaCenterAll, gtCenterAll, frameIndex);
CEE = [];   %%Center Error Evaluation
CEE.PCA   = centerErrorPCA;
CEE.L1    = centerErrorL1;
CEE.PN    = centerErrorPN;
CEE.VTD   = centerErrorVTD;
CEE.MIL   = centerErrorMIL;
CEE.Frag  = centerErrorFrag;
CEE.SRPCA = centerErrorSRPCA;
CEE_M = []; %%Center Error Evaluation (Mean)
CEE_M.PCA   = mean(centerErrorPCA);
CEE_M.L1    = mean(centerErrorL1);
CEE_M.PN    = mean(centerErrorPN(~isnan(centerErrorPN)));
CEE_M.VTD   = mean(centerErrorVTD);
CEE_M.MIL   = mean(centerErrorMIL);
CEE_M.Frag  = mean(centerErrorFrag);
CEE_M.SRPCA = mean(centerErrorSRPCA)
save([fileName '_centerErrorEvaluation.mat'], 'CEE', 'CEE_M', 'frameIndex');

%%5--Display Overlap Rate Evaluation
figure(1);
hold on;
plot(frameIndex, ORE.PCA,   'B--', 'linewidth', 2.5); 
hold on; 
plot(frameIndex, ORE.L1 ,   'G--', 'linewidth', 2.5); 
hold on;
plot(frameIndex, ORE.PN,    'K--', 'linewidth', 2.5); 
hold on;
plot(frameIndex, ORE.VTD,   'Y--', 'linewidth', 2.5); 
hold on;
plot(frameIndex, ORE.MIL,   'M--', 'linewidth', 2.5); 
hold on;
plot(frameIndex, ORE.Frag,  'C--', 'linewidth', 2.5); 
hold on;
plot(frameIndex, ORE.SRPCA, 'R',   'linewidth', 2.5); 
xlabel('Frame Number','fontsize',18, 'fontweight','bold');
ylabel('Overlap Rate','fontsize',18, 'fontweight','bold');
hold off;
set(gca, 'fontsize', 18, 'fontweight', 'bold', 'box', 'on');

%%6--Display Center Error Evaluation
figure(2);
hold on;
plot(frameIndex, CEE.PCA,   'B--', 'linewidth', 2.5); 
hold on; 
plot(frameIndex, CEE.L1,    'G--', 'linewidth', 2.5); 
hold on;
plot(frameIndex, CEE.PN,    'K--', 'linewidth', 2.5); 
hold on;
plot(frameIndex, CEE.VTD,   'Y--', 'linewidth', 2.5); 
hold on;
plot(frameIndex, CEE.MIL,   'M--', 'linewidth', 2.5); 
hold on;
plot(frameIndex, CEE.Frag,  'C--', 'linewidth', 2.5); 
hold on;
plot(frameIndex, CEE.SRPCA, 'R',   'linewidth', 2.5); 
xlabel('Frame Number','fontsize',18, 'fontweight','bold');
ylabel('Center Error','fontsize',18, 'fontweight','bold');
hold off;
set(gca, 'fontsize', 18, 'fontweight', 'bold', 'box', 'on');