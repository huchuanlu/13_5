function alpha = pca_L1(data, W, srParam)
%%  function alpha = pca_L1(data, W, srParam)
%%  Object representation via sparse prototypes 
%%                                   (PCA basis vectors +trivial templates)
%%  Input:  
%%          data:       A normalized data vector
%%          W:          PCA basis vectors
%%          srParam:    Parameters for L1 minimization
%%              -srParam.lambda
%%              -srParam.maxLoopNum
%%              -srParam.tol
%%  Output:
%%          alpha:      The representation coefficient
%%
%%DUT-IIAU-DongWang-2012-05-10
%%Dong Wang, Huchuan Lu, Minghsuan Yang, Online Object Tracking with Sparse
%%Prototypes, IEEE Transaction On Image Processing
%%http://ice.dlut.edu.cn/lu/index.html
%%wangdong.ice@gmail.com
%%

%%1.Initialization:
coeff = zeros(size(W,2),1);             %%The coefficients of PCA basis vectors
err   = zeros(size(data));              %%The coefficients of trivial templates
objValue = zeros(1,srParam.maxLoopNum); %%The values of objective functions
%%2.Iterative solution: 
for num = 1:srParam.maxLoopNum
    %(2.1)Fix 'err', slove 'coeff'--(Lemma 1 in Section III; Step 3 in Table I)
    coeff = W'*(data-err);
    %(2.1)Fix 'coeff', slove 'err'--(Lemma 2 in Section III; Step 4 in Table I)
    y = data-W*coeff;
    err = max(abs(y)-srParam.lambda, 0).*sign(y);
    %
    if num == 1
       alpha = [coeff; err]; 
       continue;
    end
    %
    objValue(num) = (y-err)'*(y-err) + srParam.lambda*sum(abs(err));
    if abs(objValue(num)-objValue(num-1)) < srParam.tol
       break;
    else
       alpha = [coeff; err];
    end
end