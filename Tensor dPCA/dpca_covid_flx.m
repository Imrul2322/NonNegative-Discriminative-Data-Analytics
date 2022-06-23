clear,clc,close all
[~,txtData]  = xlsread('Symptonnames.xlsx','A1:PF1');
x_year = 2019;
if x_year == 2020
    feb_day = 29;
    whole_day = 366;
else 
    feb_day = 28;
    whole_day = 365;
end
[temp]  = readmatrix('2019_country_daily_2019_US_daily_symptoms_dataset.csv');
temp2019 = temp(:,8:end);% whole dataset, 1-365 rows for Us, then each 365 rows for 1 state
[temp]  = readmatrix('2020_country_daily_2020_US_daily_symptoms_dataset.csv');
temp2020 = temp(:,8:end);% whole dataset, 1-365 rows for Us, then each 365 rows for 1 state

temp2019(isnan(temp2019))=0;
temp2020(isnan(temp2020))=0;

chose_month = 7;

chose_day_2019 = chose_days(chose_month, 28);
chose_day_2020 = chose_days(chose_month, 29);

% take flu season data only from all states, 2019 and 2020 December
% 93   Cough
% 142: fever
% 139  Fatigue
% 169: headache

% 21  Anxiety

% 7,  Ageusia loss of taste, covid only
% 20:  Anosmia, oss of smell, Covid only
% 351  Shortness of breath, covid and severe flu, can view it as covid only
% 412 Vomiting
% 101 Diarrhea, covid only
% 268 Nausea; want to vomit
% 76 chills, both, but important for both
feature_set =[7,351,20,412,268,110, 93,142, 139, 169,21];
chose_row_2019 = chose_day_2019;
rand_states = randperm(51);
chose_states = rand_states(1:50);% need sufficient states
for i = chose_states
    chose_row_2019 = [chose_row_2019 , chose_day_2019+i*365];
end
chose_row_2020 = chose_day_2020;
for i = chose_states
    chose_row_2020 = [chose_row_2020 , chose_day_2020+i*whole_day];
end

% % put both 2018 and 2019 as background
% temp2019_save = temp2019;
%  load('temp2019.mat');
% temp2019(isnan(temp2019))=0;
% temp2019=[temp2019;temp2019_save];
% % end 

X = temp2020(chose_row_2020 ,feature_set);
Y = temp2019(chose_row_2019 ,feature_set);
% remove the rows when Anosmia is 0
X=X(find(X(:,1)~=0),:);
Y=Y(find(Y(:,1)~=0),:);

[Vrr, Xr]=dpca(X,Y,1);
[valsort,ind] = sort((Vrr(:,1)),'descend');
ind_dpca=ind;
alpha=0;
Us = cpca_alpha(X, Y, alpha,1);
[~,ind2020] = sort((Us(:,1)),'descend');
alpha=-999999;
Us = cpca_alpha(X, Y, alpha,1);
[~,ind2019] = sort((Us(:,1)),'descend');
alpha=0.9;
Us = cpca_alpha(X, Y, alpha,1);
[~,ind_cpca] = sort((Us(:,1)),'descend');
ind_dpca'
ind_cpca'
ind2020'
ind2019'

% think about before and after covid case peak, 11/1/2020-2/1/2021
% hawii's peak is Summer, others is winter

%  for i = 1:422
%
%  i=i
%  txtData(ind(i))
%  end