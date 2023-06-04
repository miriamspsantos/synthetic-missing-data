function outputX = mcarRahman(inputX, mr, miss_pattern, miss_model)
% mcarRahman performs MCAR generation according to Rahman 2013
% INPUT:
%       inputX = matrix of data (n patterns x p features)
%       mr = missing rate (%) of the whole dataset
%       miss_pattern = String with the missing pattern to be use (simple,
%           medium, complex or blended)
%       miss_model = Is a boolean that identicates which type of missing
%           model to be use if true it will be used a overall model (MV are
%           note necessary equally distributed by atrribute) else it will
%           be used Uniformly Distributed.
%
% OUTPUT:
%       outputX with mr missing values
%
%
% REFERENCES:
% @article{rahman2013missing,
%  title={Missing value imputation using decision trees and decision forests by splitting and merging records: Two novel techniques},
%  author={Rahman, Md Geaur and Islam, Md Zahidul},
%  journal={Knowledge-Based Systems},
%  volume={53},
%  pages={51--65},
%  year={2013},
%  publisher={Elsevier}
% }
%
%
% Copyright: Jastin Soares, 2018

outputX = inputX;

num_rows = size(outputX,1);
num_cols = size(outputX,2);

% Overall model
if miss_model
    total_miss = round(num_rows*num_cols*mr/100);
% Uniformly distributed model
else
    total_miss = ones(1,num_cols)*(num_rows*mr/100);
end

switch lower(miss_pattern)
    case 'simple'
        % verify MR
        if mr >= 100/num_cols
            error("Missing rate is to big for this method: %d is the limit!", 100/num_cols)
        end

        min_feature = 1;
        max_feature = 1;

        % Overall model
        if miss_model
            outputX = overall_model(outputX, total_miss, min_feature, max_feature);
        % Uniformly distributed model
        else
            outputX = uniform_model(outputX, total_miss, min_feature, max_feature);
        end
    case 'medium'
        % verify MR
        if mr >= 200/num_cols
            error("Missing rate is to big for this method: %d is the limit!", 200/num_cols)
        end
        if num_cols < 3
            error("For this medium pattern generation is need more than 2 features!")
        end

        min_feature = 2;
        max_feature = ceil(num_cols/2);

        % Overall model
        if miss_model
            outputX = overall_model(outputX, total_miss, min_feature, max_feature);
        % Uniformly distributed model
        else
            outputX = uniform_model(outputX, total_miss, min_feature, max_feature);
        end
    case 'complex'
        % verify MR
        if mr >= 50
            error("Missing rate is to big for this method: 50 is the limit!")
        end
        if num_cols < 5
            error("For this complex pattern generation is need more than 4 features!")
        end

        min_feature = ceil(num_cols/2);
        max_feature = ceil(4*num_cols/5);

        % Overall model
        if miss_model
            outputX = overall_model(outputX, total_miss, min_feature, max_feature);
        % Uniformly distributed model
        else
            outputX = uniform_model(outputX, total_miss, min_feature, max_feature);
        end
    case 'blended'
        % verify MR
        if mr >= ((50+4*num_cols)/(40*num_cols))*100
            error("Missing rate is to big for this method: 50 is the limit!")
        end
        if num_cols < 5
            error("For this blended pattern generation is need more than 4 features!")
        end
        % divide the dataset randomly in 3 part (25%, 50% and 25%)
        idx_row = 1:num_rows;
        idx_simple = randperm(num_rows, floor(0.25*num_rows));
        idx_row(idx_simple) = [];
        aux = randperm(size(idx_row,2), floor(0.5*num_rows));
        idx_medium = idx_row(aux);
        idx_row(aux) = [];
        idx_complex = idx_row;

        % Overall model
        if miss_model
            min_feature = 1;
            max_feature = 1;
            outputX(idx_simple,:) = overall_model(outputX(idx_simple,:), total_miss*0.25, min_feature, max_feature);
            min_feature = 2;
            max_feature = ceil(num_cols/2);
            outputX(idx_medium,:) = overall_model(outputX(idx_medium,:), total_miss*0.5, min_feature, max_feature);
            min_feature = ceil(num_cols/2);
            max_feature = ceil(4*num_cols/5);
            outputX(idx_complex,:) = overall_model(outputX(idx_complex,:), total_miss*0.25, min_feature, max_feature);
        % Uniformly distributed model
        else
            min_feature = 1;
            max_feature = 1;
            outputX(idx_simple,:) = uniform_model(outputX(idx_simple,:), total_miss*0.25, min_feature, max_feature);
            min_feature = 2;
            max_feature = ceil(num_cols/2);
            outputX(idx_medium,:) = uniform_model(outputX(idx_medium,:), total_miss*0.5, min_feature, max_feature);
            min_feature = ceil(num_cols/2);
            max_feature = ceil(4*num_cols/5);
            outputX(idx_complex,:) = uniform_model(outputX(idx_complex,:), total_miss*0.25, min_feature, max_feature);
        end

    otherwise
        error("Unknown value of miss_pattern!")
end

end




function [outputX] = overall_model(inputX, total_miss, min_feature, max_feature)
% This function generates missing values based on the total number of
% misses wanted and based on the interval of feature need to be use for
% creating a type os missing patter (e.g. simple, medium or complex)

outputX = inputX;

num_rows = size(outputX,1);
num_cols = size(outputX,2);

while total_miss > 0 && total_miss >= min_feature
    if total_miss < max_feature
        max_feature = total_miss;
    end
    row_sel = randi(num_rows);
    col_n = randi([min_feature, max_feature]);
    col_sel = randperm(num_cols, col_n);
    outputX(row_sel, col_sel) = NaN;
    total_miss = total_miss - col_n;
end

end

function [outputX] = uniform_model(inputX, total_miss, min_feature, max_feature)
% This function generates missing values based on the number of avaible
% miss per column and based on the interval of feature need to be use for
% creating a type os missing patter (e.g. simple, medium or complex)
% Note: total_miss is a Vector where each column represent the number of
% misses wanted to be generate.


outputX = inputX;

num_rows = size(outputX,1);

while sum(total_miss) > 0 && sum(total_miss>0) >= min_feature
    if sum(total_miss>0) < max_feature
        max_feature = sum(total_miss>0);
    end

    % just use the columns that have miss to be gen
    idx_cols_available = find(total_miss>0);
    col_n = randi([min_feature, max_feature]);
    row_sel = randi(num_rows);
    col_sel = idx_cols_available(randperm(size(idx_cols_available,2), col_n));
    outputX(row_sel, col_sel) = NaN;
    total_miss(col_sel) = total_miss(col_sel) - 1;
end

end
