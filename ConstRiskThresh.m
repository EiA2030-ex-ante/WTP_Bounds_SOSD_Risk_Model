function [Result] = ConstRiskThresh(Data, CompVarNum, BaseVarNum)
% INPUT Matrices: ndataseq01060216 and ndataseq10060216 from crop
%   simulation models with Columns
%  1 = cell30m/Unique Cell ID
%  2 = Replication
%  3 = Simulation Year
%  4 = Maize Area in Cell (ha)
%  5 = Maize Yield (kg/ha) for CM1510 with   40 kg N / yldCM1040
%  6 = Maize Yield (kg/ha) for CM1510 with    0 kg N / yldCM1000
%  7 = Maize Yield (kg/ha) for CM1509 with   40 kg N / yldCM0940
%  8 = Maize Yield (kg/ha) for CM1509 with    0 kg N / yldCM0900
%  9 = Maize Yield (kg/ha) for Improved with 40 kg N / yldimp40
% 10 = Maize Yield (kg/ha) for Improved with  0 kg N / yldimp00

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
%  # = Comparison Cultivar ID (CM1510 = 10, CM1509 = 9, Improved = 0)
%  2 = Comparison Nitrogen ID
%  # = Base Cultivar ID (CM1510 = 10, CM1509 = 9, Improved = 0)
%  3 = Base Nitrogen Management ID

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
%while count <= LEN

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

%   count = count + 1;
%end


