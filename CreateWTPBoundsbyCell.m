% INPUT Matrices: ndataseq01060216 and ndataseq10060216 from crop
%   simulation models with Columns
%  1 = Unique Cell ID
%  2 = Replication
%  3 = Area
%  4 = Base
%  5 = New

%
%
% OUTPUT Matrix: RA with columns
%  1 = cell30m
%  2 = Comparison ID
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
% 25 = Area

% Compare Q to G
RA_yearseq_01 = ConstRiskThresh(ndataseq01060216, 4, 5);


LEN          = length(RA_yearseq_01);
apones       = ones(LEN,1);

clear apones LEN;


RA = [RA_yearseq_01];

RA=RA(1,:)

