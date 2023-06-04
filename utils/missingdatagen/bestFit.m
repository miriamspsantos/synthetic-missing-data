function [ bestValIdx, bestName ] = bestFit( data )
% Author: Jastin Pompeu Soares
% Birth Date: 2016-11-3
% Last review Date: 2016-11-4
%This function return the best distribution that fit the input data
%bestName       <- Name of the best fit distribution
%bestValIdx(1)  <- Goodness of fit value from the best distribution
%bestValIdx(3)  <- the BIC value of this distribution
%bestValIdx(2)  <-1 - Normal (Gaussian) Distribution
%                 2 - Gamma Distribution
%                 3 - Weibull Distribution
%                 4 - Exponencial Distribution
%                 5 - LogNormal Distribution
%                 6 - Beta Distribution
%                 7 - Birnbaum-Saunders
%                 8 - Extreme value
%                 9 - Generalized extreme value
%                10 - Generalized Pareto
%                11 - Inverse Gaussian
%                12 - Logistic
%                13 - Log-logistic
%                14 - Nakagami
%                15 - Rayleigh
%                16 - Rician
%                17 - t location-scale


%Define the distributions to use
distName={  'Normal',...
            'Gamma',...
            'Weibull',...
            'Exponential',...
            'Lognormal',...
            'Beta',...
            'BirnbaumSaunders',...
            'ExtremeValue',...
            'GeneralizedExtremeValue',...
            'GeneralizedPareto',...
            'InverseGaussian',...
            'Logistic',...
            'Loglogistic',...
            'Nakagami',...
            'Rayleigh',...
            'Rician',...
            'tLocationScale',...
            };

%Initialize a vector to save goodness of fit values from each distribution
fitVal=zeros(size(distName,2),2);

%Calculate the Empirical cumulative distribution function
[f, x]=ecdf(data);
warning('off','all'); %Turn off warnings
%Calcule for each fistribuition the best fit to 'data' and save the
%goodness of fit value
for i=1:size(distName,2)
    %if occurs a error it will not stop the process
    try
        %compute the best atributes of the distribution{i} for 'data'
        if(strcmp(distName{i},'generalized pareto')||strcmp(distName{i},'GeneralizedPareto'))
            vingp={};
            % Special Case for Generalized Pareto
            %Use minimum value for theta, minus small part
            thetahat=min(data(:))-10*eps;
            vingp{end+1}='theta'; vingp{end+1}=thetahat;
            pd = fitdist(data,'generalized pareto',vingp{:});
        else
            pd=fitdist(data,distName{i});
        end
        %compute the cdf values for the distribution{i}
        cdfVal=cdf(pd,x);
        %compute the goodness of the fit
        fitVal(i,1)=goodnessOfFit(cdfVal,f,'NRMSE');
        %BIC calcule
            k=numel(pd.Params);
            fitVal(i,2)=(-2*(-pd.NLogL)+k*log(numel(data)));
    catch err %#ok<NASGU>
        fitVal(i)=-Inf;
    end
end
warning('on','all'); %Turn back on warnings
[maxVal,MaxIdx]=max(fitVal(:,1));
bestValIdx=[maxVal,MaxIdx,fitVal(MaxIdx,2)];
bestName=distName{MaxIdx};
end
