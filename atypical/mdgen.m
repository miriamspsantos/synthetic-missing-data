function [ DataOut, isRand ] = MissingDataGen( DataIn, Ratio , Type, DataInCat)
% This Function Generates Missing Data based on the Probability Density
%   Function or on the histogram, or Completely Random. The function generates
%   a new Dataset with missing data (DataOut) with a ratio given by a
%   percentage (Ratio) per column from the data input (DataIn).
%
% Inputs:
%
% DataIn - is the matrix data where the function will create missing values
%
% Ration - is the percentage of missing values per column that is wish to
% generate [0,100]
%
% Type (1) - 'distributionExt' uses just the external values (lower PDF)
%   or (2) - 'distributionInt' uses just the internal values (higher PDF)
%   or (3) - 'distributionExtInt' uses both internal and external values
%   or (4) - 'histogramLow' uses the less frequent values (lower Histogram)
%   or (5) - 'histogramHigh' uses the most frequent values(lower Histogram)
%   or (6) - 'histogramLowHigh' uses the most and less freq values(Histogram)
%   or (7) - 'random'
%
% DataInCat - represent a logical vector were each column corresponds a
% feature from DataIn. If it's true (1) then on this column the data is
% categoric.
% Note.:
%       For categoric features the missing generation mechanism used is
%       MCAR.
%
%       The number of missing data per feature is calculated using the
%       Ratio percentage and randomly distributed.
%
%       For Types {(1),(2),(3)}:
%       If possible, its used the best distribution that fits into the
%       data of each numerical column to select the values with higher
%       and/or lower probability (PDF). The values selected are then
%       randomly removed.
%
%       For Types {(4),(5),(6)}:
%       If the values aren't categorical, its used a histogram (with
%       the "sqrt" method to compute the number of bins) to select/extract
%       the less and/or most frequent values on the data column.
%       The values selected are then randomly removed.
%
%       For Types {(3), (6)}:
%       It's granted that 50% of the removed values are from the Ext
%       and the other 50% from the Int (or low and high).
%
% Returns:
%
% DataOut - DataIn Matrix but with missing values (NaN)
%
% isRand - is a logical vector where each element represents if the missing
% values generated on the correspond feature of DataOut was obtained by a
% MCAR (true) or not (histogram/distribuiton)
%
%
% Copyright: Jastin Soares, 2016

%variable inicializaction
isRand=[];
%threshold for the best fit approval
Thres=0.01;

%Verification of input arguments
narginchk(2,5);
%check if Type of distribution is defined
if ~exist('Type','var')
    Type='random';
end
%check if DataInCat of distribution is defined
if ~exist('DataInCat','var')
    DataInCat=zeros(1,size(DataIn,2));
end
%check if bestFitDist is defined and correct size
if ~exist('bestFitDist','var')
    if(strcmp(Type,'distributionExtInt')||...
            strcmp(Type,'distributionExt')||...
            strcmp(Type,'distributionInt'))
        error('ERROR: bestFitDist not exist and is need!');
    end
else
    if(size(DataIn,2)~=length(bestFitDist))
        error(['ERROR: bestFitDist size dont matches with the number of',...
            ' columns of DataIn!']);
    end
end

%Obtain the number of missing data wished
numMiss=round(size(DataIn,1)*(Ratio/100));
numDel=numMiss*ones(size(DataIn,2),1);

%selection of mechanism to use for the removal of values from DataIn
switch Type
    %======================================================================
    %       distribution based random missing data generation
    %      with External and Internal delete number selection
    %======================================================================
    case 'distributionExtInt'
        %Remove from the input data some data
        DataOut=DataIn;
        %determine the size of Data input
        [M,N]=size(DataIn);

        %for each column of DataIn
        for i=1:N
            k=1;% constant

            %obtain the best fit for the current column
            %just if the i-ths column of DataIn has more than 2 different
            %values and this column is numerical and not categorical
            if size(unique(DataIn(:,i)),1)>2 && ~DataInCat(i)
                %Obtain the name of the best distribution for this feature
                [~, bestDistName] = bestFit(DataIn(:,i))
                %Obtain the PDF for this column using the best fit
                [pdfEst,~,x]=pdfEstDistName(DataIn(:,i),bestDistName);
            else
                pdfEst=Inf;
            end

            %if the PDF don't have Infinite
            %values
            if sum(pdfEst==Inf)<1

                %determine the interval that contains
                %External values of the distribution
                [xExt, ~] = deterExt(DataIn(:,i), pdfEst,x,numDel(i),k);

                %determine the interval that contains
                %Internal values of the distribution
                [xInt, ~] = deterInt(DataIn(:,i), pdfEst, x, numDel(i),k);

                %Convert the interval of values obtain to the index of the
                %corresponding values on the data input
                DataDelIdxExt = [find(DataIn(:,i)<=xExt(1));...
                    find(DataIn(:,i)>=xExt(2))];
                DataDelIdxInt = [find(DataIn(:,i)>=xInt(1) & DataIn(:,i)<=xInt(2))];

                %generate random and unique sequence of number to remove
                %form the values that were selected to be removed
                % 50% of the values remove we be Int and the another 50 Ext
                DataDelInt=randperm(size(DataDelIdxInt,1),floor(numDel(i)/2))';
                DataDelExt=randperm(size(DataDelIdxExt,1),floor(numDel(i)/2))';

                %remove values from the current column
                DataOut(DataDelIdxInt(DataDelInt),i)=NaN;
                DataOut(DataDelIdxExt(DataDelExt),i)=NaN;

                %add method used to isRand vector
                isRand=[isRand 0];
            else
                %generate random and unique sequence of number to be removed
                DataDel=randperm(size(DataIn,1),numDel(i))';
                %remove values from the current column
                DataOut(DataDel,i)=NaN;
                %add method used to isRand vector
                isRand=[isRand 1];
            end
        end

        %======================================================================
        %       distribution based random missing data generation
        %           with External  delete number selection
        %======================================================================
    case 'distributionExt'
        %Remove from the input data some data
        DataOut=DataIn;
        %determine the size of Data input
        [M,N]=size(DataIn);

        %for each column of DataIn
        for i=1:N
            k=2;% constant

            %obtain the best fit for the current column
            %just if the i-ths column of DataIn has more than 2 different
            %values and this column is numerical and not categorical
            if size(unique(DataIn(:,i)),1)>2 && ~DataInCat(i)
                %Obtain the name of the best distribution for this feature
                [~, bestDistName] = bestFit(DataIn(:,i))
                %Obtain the PDF for this column using the best fit
                [pdfEst,~,x]=pdfEstDistName(DataIn(:,i),bestDistName);
            else
                pdfEst=Inf;
            end

            %if the best fit is good enough and if the PDF don't have Infinite
            %values
            if sum(pdfEst==Inf)<1

                %determine the interval that contains
                %External values of the distribution
                [xExt, ~] = deterExt(DataIn(:,i), pdfEst,x,numDel(i),k);

                %Convert the interval of values obtain to the index of the
                %corresponding values on the data input
                DataDelIdx = [find(DataIn(:,i)<=xExt(1));...
                    find(DataIn(:,i)>=xExt(2))];

                %generate random and unique sequence of number to remove
                %form the values that were selected to be removed
                DataDel=randperm(size(DataDelIdx,1),numDel(i))';
                %remove values from the current column
                DataOut(DataDelIdx(DataDel),i)=NaN;
                %add method used to isRand vector
                isRand=[isRand 0];
            else
                %generate random and unique sequence of number to be removed
                DataDel=randperm(size(DataIn,1),numDel(i))';
                %remove values from the current column
                DataOut(DataDel,i)=NaN;
                %add method used to isRand vector
                isRand=[isRand 1];
            end
        end

        %======================================================================
        %       distribution based random missing data generation
        %           with Internal delete number selection
        %======================================================================
    case 'distributionInt'
        %Remove from the input data some data
        DataOut=DataIn;
        %determine the size of Data input
        [M,N]=size(DataIn);

        %for each column of DataIn
        for i=1:N
            k=2;% constant

            %obtain the best fit for the current column
            %just if the i-ths column of DataIn has more than 2 different
            %values and this column is numerical and not categorical
            if size(unique(DataIn(:,i)),1)>2 && ~DataInCat(i)
                %Obtain the name of the best distribution for this feature
                [~, bestDistName] = bestFit(DataIn(:,i))
                %Obtain the PDF for this column using the best fit
                [pdfEst,~,x]=pdfEstDistName(DataIn(:,i),bestDistName);
            else
                pdfEst=Inf;
            end

            %if the best fit is good enough and if the PDF don't have Infinite
            %values
            if sum(pdfEst==Inf)<1

                %determine the interval that contains
                %Internal values of the distribution
                [xInt, ~] = deterInt(DataIn(:,i), pdfEst, x, numDel(i),k);

                %Convert the interval of values obtain to the index of the
                %corresponding values on the data input
                DataDelIdx = find(DataIn(:,i)>=xInt(1) ...
                    & DataIn(:,i)<=xInt(2));

                %generate random and unique sequence of number to remove
                %form the values that were selected to be removed
                DataDel=randperm(size(DataDelIdx,1),numDel(i))';
                %remove values from the current column
                DataOut(DataDelIdx(DataDel),i)=NaN;
                %add method used to isRand vector
                isRand=[isRand 0];
            else
                %generate random and unique sequence of number to be removed
                DataDel=randperm(size(DataIn,1),numDel(i))';
                %remove values from the current column
                DataOut(DataDel,i)=NaN;
                %add method used to isRand vector
                isRand=[isRand 1];
            end
        end
        %======================================================================
        %       histogram based random missing data generation
        %           with less frequent values selection
        %======================================================================
    case 'histogramLow'
        %Remove from the input data some data
        DataOut=DataIn;

        %determine the size of Data input
        [M,N]=size(DataIn);

        %for each column of DataIn
        for i=1:N
            k=2;% constant

            %if columns is compose of categorical number
            if(DataInCat(i))
                %remove random values without a pre selection
                %generate random and unique sequence of number to be removed
                DataDel=randperm(size(DataIn,1),numDel(i))';
                %remove values from the current column
                DataOut(DataDel,i)=NaN;
                %add method used to isRand vector
                isRand=[isRand 1];
            else
                %determine the interval that contains the
                %less frequent values
                DataDelIdx = deterLowHist(DataIn(:,i), numDel(i),k);

                %generate random and unique sequence of number to remove
                %form the values that were selected to be removed
                DataDel=randperm(size(DataDelIdx,1),numDel(i))';
                %remove values from the current column
                DataOut(DataDelIdx(DataDel),i)=NaN;
                %add method used to isRand vector
                isRand=[isRand 0];
            end

        end
        %======================================================================
        %       histogram based random missing data generation
        %           with most frequent values selection
        %======================================================================
    case 'histogramHigh'
        %Remove from the input data some data
        DataOut=DataIn;

        %determine the size of Data input
        [M,N]=size(DataIn);

        %for each column of DataIn
        for i=1:N
            k=2;% constant

            %if columns is compose of categorical number
            if(DataInCat(i))
                %remove random values without a pre selection
                %generate random and unique sequence of number to be removed
                DataDel=randperm(size(DataIn,1),numDel(i))';
                %remove values from the current column
                DataOut(DataDel,i)=NaN;
                %add method used to isRand vector
                isRand=[isRand 1];
            else
                %determine the interval that contains the
                %most frequent values
                DataDelIdx = deterHighHist(DataIn(:,i), numDel(i),k);

                %generate random and unique sequence of number to remove
                %form the values that were selected to be removed
                DataDel=randperm(size(DataDelIdx,1),numDel(i))';
                %remove values from the current column
                DataOut(DataDelIdx(DataDel),i)=NaN;
                %add method used to isRand vector
                isRand=[isRand 0];
            end

        end
        %======================================================================
        %       histogram based random missing data generation
        %           with less and most frequent values selection
        %======================================================================
    case 'histogramLowHigh'
        %Remove from the input data some data
        DataOut=DataIn;

        %determine the size of Data input
        [M,N]=size(DataIn);

        %for each column of DataIn
        for i=1:N
            k=1;% constant

            %if columns is compose of categorical number
            if(DataInCat(i))
                %remove random values without a pre selection
                %generate random and unique sequence of number to be removed
                DataDel=randperm(size(DataIn,1),numDel(i))';
                %remove values from the current column
                DataOut(DataDel,i)=NaN;
                %add method used to isRand vector
                isRand=[isRand 1];
            else
                %determine the interval that contains the
                %less and most frequent values
                DataDelIdxLow = deterLowHist(DataIn(:,i), numDel(i),k);
                DataDelIdxHigh =deterHighHist(DataIn(:,i), numDel(i),k);

                %generate random and unique sequence of number to remove
                %form the values that were selected to be removed
                % 50% of the values remove we be High and the another 50 Low
                DataDelLow=randperm(size(DataDelIdxLow,1),floor(numDel(i)/2))';
                DataDelHigh=randperm(size(DataDelIdxHigh,1),floor(numDel(i)/2))';
                %remove values from the current column
                DataOut(DataDelIdxLow(DataDelLow),i)=NaN;
                DataOut(DataDelIdxHigh(DataDelHigh),i)=NaN;
                %add method used to isRand vector
                isRand=[isRand 0];
            end

        end
        %======================================================================
        %       no distribution based random missing data generation
        %       Missing Completely At Random (MCAR) Generation Mechanism
        %======================================================================
    otherwise
        %Remove from the input data some data
        DataOut=DataIn;
        %determine the size of Data input
        [M,N]=size(DataIn);

        for i = 1:N
            idxMiss = randperm(M,numMiss);

            %at the last columns prevent rows to have rows completely fill with NaN
            if(i==N)
                idxNan=findRowNaN(DataOut(:,1:N-1));
                %detect if the remove indexs are on rows filled with NaNs
                idxEq=intersect(idxMiss,idxNan);
                %remove all this indexs found
                while(~isempty(idxEq))
                    %new value generate most be unique
                    newVal=randperm(M,1);
                    while(~isempty(find(idxMiss==newVal)))
                        newVal=randperm(M,1);
                    end
                    %save this new indx
                    idxMiss(find(idxMiss==idxEq(1)))=newVal;
                    idxEq=intersect(idxMiss,idxNan);
                end
            end
            %add method used to isRand vector
            isRand=[isRand 1];
            DataOut(idxMiss,i) = NaN;
        end

end
%convert isRand vector into a logical vector
isRand=logical(isRand);
end
