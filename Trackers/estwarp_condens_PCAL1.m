function param = estwarp_condens_PCAL1(frm, tmpl, param, opt)
%% function param = estwarp_condens_PCAL1(frm, tmpl, param, opt)
%%      frm:                 Frame image;
%%      tmpl:                PCA model;
%%        -tmpl.mean:           PCA mean vector
%%        -tmpl.basis:          PCA basis vectors
%%        -tmpl.eigval:         The eigenvalues corresponding to basis vectors
%%        -tmpl.numsample:      The number of samples
%%      param:
%%        -param.est:           The estimation of the affine state of the tracked target 
%%        -param.wimg:          The collected sample for update
%%      opt:                 
%%        -opt.numsample:       The number of sampled candidates
%%        -opt.condenssig:      The variance of the Guassian likelihood function
%%        -opt.ff:              Forgotten factor;
%%        -opt.bacthsize:       The number of collected samples for update
%%        -opt.affsig:          The variance of affine parameters
%%        -opt.tmplsize:        The size of warpped image patch
%%        -opt.maxbasis:        The maximum number of basis vectors
%%        -opt.srParam:         The parameters of L1 minimization
%%        -opt.threshold:       The threshold for model update
%%DUT-IIAU-DongWang-2012-05-10
%%Dong Wang, Huchuan Lu, Minghsuan Yang, Online Object Tracking with Sparse
%%Prototypes, IEEE Transaction On Image Processing
%%http://ice.dlut.edu.cn/lu/index.html
%%wangdong.ice@gmail.com
%%

%%************************1.Candidate Sampling************************%%
%%Sampling Number
n = opt.numsample;
%%Data Dimension
sz = size(tmpl.mean);
N = sz(1)*sz(2);
%%Affine Parameter Sampling
param.param = repmat(affparam2geom(param.est(:)), [1,n]);
randMatrix = randn(6,n);
param.param = param.param + randMatrix.*repmat(opt.affsig(:),[1,n]);
%%Extract or Warp Samples which are related to above affine parameters
wimgs = warpimg(frm, affparam2mat(param.param), sz);
%%************************1.Candidate Sampling************************%%

%%*******************2.Calucate Likelihood Probablity*******************%%
%%Remove the average vector or Centralizing
diff = repmat(tmpl.mean(:),[1,n]) - reshape(wimgs,[N,n]);
%
if  (size(tmpl.basis,2) > 0)
    %%(1)PCA_L1
    if  (size(tmpl.basis,2) == opt.maxbasis)
        %(1.1)Calucate representation coefficients of all candidates
        alpha = zeros(N+opt.maxbasis,n);
        for num = 1:n
            alpha(:,num) = pca_L1(diff(:,num), tmpl.basis, opt.srParam);
        end
        coeff = alpha(1:size(tmpl.basis,2),:);    %%The coefficients of PCA basis vectors
        err = alpha(size(tmpl.basis,2)+1:end,:);  %%The coefficients of trivial templates
        %%(1.2)Calucate observation likelihood via Eq.12
        diff = diff-tmpl.basis*coeff-err;         %%Reconstruction
        diff = diff.*(abs(err)<opt.srParam.L0);                                
        param.conf = exp(-(sum(diff.^2)+opt.srParam.L0*sum(abs(err)>=opt.srParam.L0))./opt.condenssig)';
    %%(2)Traditional PCA
    else
        coef = tmpl.basis'*diff;
        diff = diff - tmpl.basis*coef;
        param.conf = exp(-sum(diff.^2)./opt.condenssig)';
    end
else
    %%(3)Square Error
    param.conf = exp(-sum(diff.^2)./opt.condenssig)';
end
%%*******************2.Calucate Likelihood Probablity*******************%%

%%*****3.Obtain the optimal candidate by MAP (maximum a posteriori)*****%%
param.conf = param.conf ./ sum(param.conf);
[maxprob,maxidx] = max(param.conf);
param.est = affparam2mat(param.param(:,maxidx));
%%*****3.Obtain the optimal candidate by MAP (maximum a posteriori)*****%%

%%************4.Collect samples for model update(Section III.C)***********%%
wimg = wimgs(:,:,maxidx);
if  (size(tmpl.basis,2) == opt.maxbasis)
    err = abs(alpha(size(tmpl.basis,2)+1:end,maxidx));
    %Compute the ratio
    errRatio = sum(err>opt.srParam.L0)/length(err);
    %Full update:
    if  (errRatio < opt.threshold.low)
        param.wimg = wimg;
        return;
    end
    %Partial update:
    if  (errRatio > opt.threshold.high)
        param.wimg = [];
        return;
    end
    %Full update:
    if  ((errRatio>opt.threshold.low) && (errRatio<opt.threshold.high))
        param.wimg = (1-(err>opt.srParam.L0)).*wimg(:) + (err>opt.srParam.L0).*tmpl.mean(:);
        param.wimg = reshape(param.wimg,size(wimg));
        return;
    end  
else
    param.wimg = wimgs(:,:,maxidx);
end
%%************4.Collect samples for model update(Section III.C)***********%%
