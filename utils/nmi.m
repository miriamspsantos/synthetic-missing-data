function [scores, order] = nmi(X,T)
% nmi(xi,t) Normalized Mutual Information
% nmi measures the normalized mutual information between xi and the target
% t.
%
% INPUT:
%   X = dataset X (composed by categorical or continuous features)
%   T = target (categorical) (could be N-class problem)
%
% OUTPUT:
%   scores = a value ranging from 0 (no mutual information)
%   to 1 (perfec correlation) to measure for each feature
%
%   order = the features are ordered from minimum information to maximum
%   information
%
%   In this implementation, normalization is performed according to
%   Laencina13, that is, dividing by the sum of all individuai NMIs.
%
% REFERENCES:
% @article{garcia2013classifying,
%   title={Classifying patterns with missing values using Multi-Task Learning perceptrons},
%   author={Garc{\'\i}A-Laencina, Pedro J and Sancho-G{\'o}Mez, Jos{\'e}-Luis and Figueiras-Vidal, An{\'\i}Bal R},
%   journal={Expert Systems with Applications},
%   volume={40},
%   number={4},
%   pages={1333--1341},
%   year={2013},
%   publisher={Elsevier}
% }
%
%
% @article{peng2005feature,
%   title={Feature selection based on mutual information criteria of max-dependency,
%   max-relevance, and min-redundancy},
%   author={Peng, Hanchuan and Long, Fuhui and Ding, Chris},
%   journal={IEEE Transactions on pattern analysis and machine intelligence},
%   volume={27},
%   number={8},
%   pages={1226--1238},
%   year={2005},
%   publisher={IEEE}
% }
%
%
% It requires the mutual information toolbox by Hanchuan Peng:
% (http://www.mathworks.com/matlabcentral/fileexchange/14888-mutual-information-computation)
%
%
% EXAMPLE:
% filename = 'iris.arff';
% [dataOut,DataTab,DataStruct] = arff2double(filename);
% features = dataOut.A(:,1:4);
% target = dataOut.A(:,end);
% scores = nmi(features, target)
%
%
% Copyright: Miriam Santos, 2017


for i = 1:size(X,2)
    minfo(i) = mutualinfo(X(:,i), T);
end

total = sum(minfo);
scores = minfo./total;

% Get the order of scores from min to max
[~, order] = sort(scores);

end
