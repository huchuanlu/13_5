%%
%%DUT-IIAU-DongWang-2012-05-10
%%Dong Wang, Huchuan Lu, Minghsuan Yang, Online Object Tracking with Sparse
%%Prototypes, IEEE Transaction On Image Processing
%%http://ice.dlut.edu.cn/lu/index.html
%%wangdong.ice@gmail.com
%%
clear all;
clc;

%%******Change 'title' to choose the sequence you wish to run******%%
%%  Data sets reported in the TIP paper 
title = 'Occlusion1'; 
% title = 'Occlusion2'; 
% title = 'Caviar1';
% title = 'Caviar2';
% title = 'Deer';
% title = 'Jumping';
% title = 'Singer1';
% title = 'DavidIndoor';
% title = 'Lemming';
% title = 'Cliffbar';
% title = 'Car4';
% title = 'Car11';
%%  Additional data sets:
% title = 'DavidOutdoor';
% title = 'Stone';
% title = 'Girl';
%%******Change 'title' to choose the sequence you wish to run******%%


%%***********************1.Initialization****************************%%
addpath(genpath('./Trackers')); 
trackparam;
%%1.1 Initialize variables:
if ~exist('opt','var')        opt = [];  end
if ~isfield(opt,'tmplsize')   opt.tmplsize = [32,32];  end                  
if ~isfield(opt,'numsample')  opt.numsample = 600;  end                     
if ~isfield(opt,'affsig')     opt.affsig = [4,4,.02,.02,.005,.001];  end    
if ~isfield(opt,'condenssig') opt.condenssig = 0.01;  end                   
if ~isfield(opt,'maxbasis')   opt.maxbasis = 16;  end                       
if ~isfield(opt,'batchsize')  opt.batchsize = 5;  end                      
if ~isfield(opt,'ff')         opt.ff = 1.0;  end                          
if ~isfield(opt,'srParam')                      %%Parameters for L1 minimization
    opt.srParam = [];                           
    opt.srParam.lambda = 0.05;                  %-The regularization consant for L1 minimization
    opt.srParam.L0     = opt.srParam.lambda;    %-The regularization consant for our new likeliood function
                                                % (Eq.12 in this paper)
    opt.srParam.maxLoopNum = 20;                %-The maximum number of iterations
    opt.srParam.tol = 1e-3;                     %-The difference of objective values between two steps
end
if  ~isfield(opt,'threshold')                   %%The threshold for model upda
    opt.threshold.high = 0.6;
    opt.threshold.low  = 0.1;
end
%1.2 Load functions and parameters:
param0 = [p(1), p(2), p(3)/32, p(5), p(4)/p(3), 0];      
param0 = affparam2mat(param0);                  %%The affine parameter of 
                                                %%the tracked object in the first frame
rand('state',0);  randn('state',0);
temp = importdata([dataPath 'datainfo.txt']);   %%DataInfo: Width, Height, Frame Number
TotalFrameNum = temp(3);                        %%Total frame number
frame = imread([dataPath '1.jpg']);             %%Load the first frame
if  size(frame,3) == 3
    framegray = double(rgb2gray(frame))/256;    %%For color images
else
    framegray = double(frame)/256;              %%For Gray images
end
%1.3 Load functions and parameters:
tmpl.mean = warpimg(framegray, param0, opt.tmplsize);    
tmpl.basis = [];                                        
tmpl.eigval = [];                                       
tmpl.numsample = 0;                                    
%
param = [];
param.est = param0;                                     
param.wimg = tmpl.mean;                                 
% draw initial track window
drawopt = drawtrackresult([], 0, frame, tmpl, param);
disp('resize the window as necessary, then press any key..'); pause;
%%***********************1.Initialization****************************%%

%%***********************2.Object Tracking***************************%%
wimgs = [];     %%Data buffer
result = [];    %%Tracking results
duration = 0; 
tic;
for num = 1:TotalFrameNum
    %%2.1 Load the (num)-th frame
    frame = imread([dataPath int2str(num) '.jpg']);
    if  size(frame,3) == 3
        framegray = double(rgb2gray(frame))/256;
    else
        framegray = double(frame)/256;
    end
    %%2.2 Do tracking
    param = estwarp_condens_PCAL1(framegray, tmpl, param, opt);
    result = [ result; param.est' ];
    %%2.3 Update model
    wimgs = [wimgs, param.wimg(:)];  
    if  (size(wimgs,2) >= opt.batchsize)     
        %%(1)Incremental PCA
        [tmpl.basis, tmpl.eigval, tmpl.mean, tmpl.numsample] = ...
        sklm(wimgs, tmpl.basis, tmpl.eigval, tmpl.mean, tmpl.numsample, opt.ff);   
        %%(2)Clear data buffer
        wimgs = [];     
        %%(3)Keep (opt.maxbasis) basis vectors
        if  (size(tmpl.basis,2) > opt.maxbasis)          
            tmpl.basis  = tmpl.basis(:,1:opt.maxbasis);   
            tmpl.eigval = tmpl.eigval(1:opt.maxbasis);
        end
    end
    %%2.4 Draw tracking results
    drawopt = drawtrackresult(drawopt, num, frame, tmpl, param);   
end
duration = duration + toc;      
fprintf('%d frames took %.3f seconds : %.3fps\n',num, duration, num/duration);
fps = num/duration;
%%***********************2.Object Tracking***************************%%

%%*************************3.STD Results*****************************%%
srpcaCenterAll  = cell(1,TotalFrameNum);      
srpcaCornersAll = cell(1,TotalFrameNum);
for num = 1:TotalFrameNum
    if  num <= size(result,1)
        est = result(num,:);
        [ center corners ] = p_to_box([32 32], est);
    end
    srpcaCenterAll{num}  = center;      
    srpcaCornersAll{num} = corners;
end
save([ title '_srpca_rs.mat'], 'srpcaCenterAll', 'srpcaCornersAll', 'fps');
%%*************************3.STD Results*****************************%%