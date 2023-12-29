function [Result] = ConstRiskThresh(Data, CompVarNum, BaseVarNum)
% INPUT Matrices: ndataseq01060216 and ndataseq10060216 from crop
%   simulation models with Columns
%  1 = cell30m/Unique Cell ID
%  2 = Replication
%  3 = Wheat Area in Cell (ha)
%  4 = Wheat Yield (kg/ha) for Comparison
%  5 = Wheat Yield (kg/ha) for Base

CompManNum = 1;
if CompVarNum == 5
    CompManNum = 0;
end


BaseManNum = 1;
if BaseVarNum == 4
    BaseManNum = 0;
end


% Outputs
%  1 = cell30m
%  2 = Comparison  ID
%  3 = Base ID
%  4 = Mean Yield for Comp
%  5 = Standard Deviation of Yield for Comp
%  6 = CV of Yield for Comp
%  7 = Maximum Yield for Comp
%  8 = Minimum Yield for Comp
%  9 = Probability of Crop Failure for Comp
% 10 = Min Proportion for Comp to SOSD Base
% 11 = Mean Yield for Base
% 12 = Standard Deviation of Yield for Base
% 13 = CV of Yield for Base
% 14 = Maximum Yield for Base
% 15 = Minimum Yield for Base
% 16 = Probability of Crop Failure for Base
% 17 = Min Proportion for Base to SOSD Comp
% 18 = Difference in mean Comp - Base
% 19 = Difference in standard deviation Comp - Base
% 20 = Difference in CV Comp - Base
% 21 = Difference in Prob of Crop Failure Comp - Base
% 22 = Min Proportion for Comp to SOSD Base divided by average base yield
% 23 = Min Proportion for Base to SOSD Comp divided by average base yield
% 24 = Comp More Risky (-1)/less Risky (1)/ Indeterminant (0) compared to Base
% 25 = Maize Area

% Get list of cell30m
CELLIDS                   = Data;
CELLIDScondy              = CELLIDS(:,2) ~= 1;
CELLIDS(CELLIDScondy,:)   = [];
CELLIDS(:,2:3)           = [];
LEN                       = length(CELLIDS);

Result = ones(LEN, 25);

count = 1;
while count <= LEN

    id    = CELLIDS(count,1);

    Yields             = Data;
    cellcond           = Yields(:,1) ~= id;
    Yields(cellcond,:) = [];

    TEMP                         = SOSDConstBoundsv3(Yields(:,CompVarNum),Yields(:,BaseVarNum));

    Result(count, 1)             = id;
  %  Result(count, 2)             = CompVar;
    Result(count, 2)             = CompManNum;
  %  Result(count, 4)             = BaseVar;
    Result(count, 3)             = BaseManNum;
    Result(count, 4:24)          = TEMP.';
    Result(count, 25)            = Yields(1,3);

    count = count + 1;
end


