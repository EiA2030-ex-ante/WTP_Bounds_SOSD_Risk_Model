
# RA column names
# %  1 = cellID
# %  2 = Comparison Technology ID
# %  3 = Base Technology ID
# %  4 = Mean Yield for Comp
# %  5 = Standard Deviation of Yield for Comp
# %  6 = CV of Yield for Comp
# %  7 = Maximum Yield for Comp
# %  8 = Minimum Yield for Comp
# %  9 = Probability of Crop Failure for Comp
# % 10 = Min Proportion for Comp to SOSD Base
# % 11 = Mean Yield for Base
# % 12 = Standard Deviation of Yield for Base
# % 13 = CV of Yield for Base
# % 14 = Maximum Yield for Base
# % 15 = Minimum Yield for Base
# % 16 = Probability of Crop Failure for Base
# % 17 = Min Proportion for Base to SOSD Comp
# % 18 = Difference in mean Comp - Base
# % 19 = Difference in standard deviation Comp - Base
# % 20 = Difference in CV Comp - Base
# % 21 = Difference in Prob of Crop Failure Comp - Base
# % 22 = Min Proportion for Comp to SOSD Base divided by average base yield
# % 23 = Min Proportion for Base to SOSD Comp divided by average base yield
# % 24 = Comp More Risky (-1)/less Risky (1)/ Indeterminant (0) compared to Base
# % 25 = Wheat Area

% Creates CELL30MIDMAP where
%  1 = cell30M
%  2 = Cell Agricultural Acreage
%  3 = RC_01_01
% 17 = PX_RC_01_01

RC_01_01  = RA;
cond = ~(RA(:,2) == 1 & RA(:,3) == 1);
RC_01_01(cond,:) = [];
RC_01_01 = sortrows([RC_01_01(:, 1),RC_01_01(:, 25), RC_01_01(:, 24)],1);
CELL30MIDMAP = [RC_01_01];
clear cond;
clear RC_01_01;


% Create Price Adjusted Technology Use Maps
%{
NinUrea    = 0.46;     % of Nitrogen in Urea
PMaizekg   = 0.25;     % Price of Maize per kg
PUrea      = 350/1000; % Price for kg of Urea
PkgN       = PUrea / NinUrea;
N40kg      = PkgN * 40 / PMaizekg;
%}

Ptech         =100;
Pyield        =1;
P_tech_yield  =Ptech/Pyield ;

LEN  = size(CELL30MIDMAP,1);

RC_01_01  = RA;
cond = ~(RA(:,2) == 1 & RA(:,3) == 1);
RC_01_01(cond,:) = [];
clear cond;
RC_01_01 = sortrows(RC_01_01,2);

CELL30MIDMAP = [CELL30MIDMAP, -1* ones(LEN,1)];
COLS = size(CELL30MIDMAP,2);
CELL30MIDMAP(:,COLS) = 0;
CELL30MIDMAP(:,COLS) =  -1*(-RC_01_01(:,10) < (P_tech_yield) & -RC_01_01(:,17) < (P_tech_yield)) ...
+ (-RC_01_01(:,10) > (P_tech_yield) & -RC_01_01(:,17) > (P_tech_yield));

% Creates price sensitivity
% 1=Multiple of base weeding cost
% 2= Percentage green
% 3= Percentage red
PriceSensitivity = -3 * ones(21,3);

Area = CELL30MIDMAP(:, 2);
TotalArea = sum(Area);

for mult = 0:20
PriceSensitivity(mult + 1, 1) = mult;

condgreen = -RC_01_01(:,10) > (mult * P_tech_yield) & -RC_01_01(:,17) > (mult * P_tech_yield);
condred   = -RC_01_01(:,10) < (mult * P_tech_yield) & -RC_01_01(:,17) < (mult * P_tech_yield);
PriceSensitivity(mult + 1, 2) = sum(condgreen .* Area) / TotalArea;
PriceSensitivity(mult + 1, 3) = sum(condred   .* Area) / TotalArea;
clear condgreen condred;
end

