function outputX = mcarNanni(inputX, mr, flag)
% mcarNanni(inputX, mr, flag) performes MCAR generation according to
% what was explained in Nanni12 (see REFERENCES).
%
%
% INPUT:
%   inputX = dataset X
%   mr = missing rate for the whole data
%   flag: corrects the require N in each observation to respect total percentage
%       IF 0 = no correction is done (follows exatcly Nanni's implementation)
%       IF 1 = correction to respect required mr% (made by mrsantos)
%
%
% OUTPUT:
%   outputX = data with missing values
%
%
% REFERENCES:
%
% @article{nanni2012classifier,
%   title={A classifier ensemble approach for the missing feature problem},
%   author={Nanni, Loris and Lumini, Alessandra and Brahnam, Sheryl},
%   journal={Artificial intelligence in medicine},
%   volume={55},
%   number={1},
%   pages={37--50},
%   year={2012},
%   publisher={Elsevier}
% }
%
%
% EXAMPLE:
% X = rand(303,14);
% mr = 10; % will correspond to 424 missing values
% flag = 0;
% flag = 1;
% outputX = mcarNanni(X, mr, flag)
% sum(sum(isnan(outputX),2)) % 303 for flag 0
% sum(sum(isnan(outputX),2)) % 424 for flag 1
%
%
% Copyright: Miriam Santos, 2017


outputX = inputX;
p = size(inputX,2);
n = size(inputX,1);


% Each pattern should have F missing features
F = round(mr/100*p); % mr% in each observation

for i = 1:n
    idx = randperm(p,F);
    outputX(i,idx) = NaN;
end


% Only if 'flag' is 1, apply change
if flag
    val = 1:p;
    % Number of xij elements to be missing
    Nxij = round(n*p*mr/100);

    % Remaining xij values to me missing so that mr% of dataset is respected
    RemXij = Nxij - (F*n);

    % Select RemXij observations random to be missing
    idx_X = randperm(n,RemXij);

    for j=1:length(idx_X)
        nanVals = isnan(outputX(idx_X(j),:));

        % Possible features to choose from
        aux_p = val(nanVals == 0);
        xs = aux_p(randi(numel(aux_p)));
        outputX(idx_X(j), xs) = NaN;
    end
end


end
