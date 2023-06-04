function [ pdfEst , f, x ] = pdfEstDistName( data, DistName )
% Author: Jastin Pompeu Soares
% Birth Date: 2017-02-06
% Last review Date: 2017-02-15
% This function computes the Probability Density Function and empirical
% Cumulative Density Function of the feature given as an input based on
% the distribution name passed as a parameter.
%
% Inputs:
% data - is a vector (a feature) of a dataset
% DistName - name of the distribution
%      DistName -> {'Normal',...
%                   'Gamma',...
%                   'Weibull',...
%                   'Exponential',...
%                   'Lognormal',...
%                   'Beta',...
%                   'BirnbaumSaunders',...
%                   'ExtremeValue',...
%                   'GeneralizedExtremeValue',...
%                   'GeneralizedPareto',...
%                   'InverseGaussian',...
%                   'Logistic',...
%                   'Loglogistic',...
%                   'Nakagami',...
%                   'Rayleigh',...
%                   'Rician',...
%                   'tLocationScale'}
%
%
% Outputs:
% pdfEst - Estimated Probability Density Function for the given input
% f - is a vector of values of the empirical cdf evaluated at x
% x - is equal to the data input (normally)
%


%Calculate the Empirical cumulative distribution function from the
%original data
[f, x]=ecdf(data);
%compute the best atributes of the distribution DistName for data
warning('off','all');
if(strcmp(DistName,'generalized pareto')||strcmp(DistName,'GeneralizedPareto'))
    vingp={};
    % Special Case for Generalized Pareto
    %Use minimum value for theta, minus small part
    thetahat=min(data(:))-10*eps;
    vingp{end+1}='theta'; vingp{end+1}=thetahat;
    pd = fitdist(data,'generalized pareto',vingp{:});
else
    pd=fitdist(data,DistName);
end
%compute the pdf values for the distribution
pdfEst=pdf(pd,x);
warning('on','all');
end
