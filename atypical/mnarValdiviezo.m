function outputX = mnarValdiviezo(inputX, mr, type, mode)
% mnarValdiviezo(inputX, mr) MNAR data generation (Valdiviezo 2015)
% generates MNAR data (Missing At Random).
%
%
% INPUT:
%       inputX = matrix of data (n patterns x p features)
%       mr = missing rate (%) of the whole dataset
%       type = type of generation of MCAR data:
%             -- 'all' considers all features
%             -- 'third' considers only one third of features
%       mode = type of generation of MCAR data:
%             -- 'lower' considers the lowest values
%             -- 'upper' considers the highest values
%
% OUTPUT:
%       outputX with mr missing values
%
%
% EXAMPLE:
% X = rand(300,30)
% outputX = mnarValdiviezo(X, 50, 'all', 'lower')
% outputX = mnarValdiviezo(X, 50, 'all', 'upper')
% outputX = mnarValdiviezo(X, 10, 'third', 'lower')
% outputX = mnarValdiviezo(X, 10, 'third', 'upper')
%
% Copyright: Miriam Santos, 2018


if (mr >= 100)
    error('Error: Missing Rate is too high, all the features will be deleted.')
end


if (mr > 100/3) && (strcmp(type,'third'))
    error('Error: Missing Rate is too high for "one third" scheme.')
end


outputX = inputX;
% Determine number of patterns n and number of features p in inputX
n = size(inputX,1);
p = size(inputX,2);



% Get the type of generation:
switch type
    case 'all'
        % Determine how many elements should be missing in each feature
        T = round(n*mr/100);

        switch mode
            case 'lower'
                for i = 1:p
                    [~, xorder] = sort(inputX(:,i));
                    lowestNindex = xorder(1:T);
                    outputX(lowestNindex, i) = NaN;
                end
            case 'upper'
                for i = 1:p
                    [~, xorder] = sort(inputX(:,i));
                    highestNindex = xorder(end:-1:end-(T-1));
                    outputX(highestNindex, i) = NaN;
                end
        end


    case 'third'
        % Adjust missing values accordingly
        T = round(n*3*mr/100);

        % Choose p/3 features at random
        np = round(p/3);
        pidx = randperm(p,np);


        switch mode
            case 'lower'
                for i = 1:np
                    [~, xorder] = sort(inputX(:,pidx(i)));
                    lowestNindex = xorder(1:T);
                    outputX(lowestNindex, pidx(i)) = NaN;
                end

            case 'upper'
                for i = 1:np
                    [~, xorder] = sort(inputX(:,pidx(i)));
                    highestNindex = xorder(end:-1:end-(T-1));
                    outputX(highestNindex, pidx(i)) = NaN;
                end
        end

end


end
