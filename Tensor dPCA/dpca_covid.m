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
% load('temp2019.mat')
% load('temp2020.mat')
% temp = size(temp2019);
% temp2019 = temp2019 + zeros(temp);
% temp = size(temp2020);
% temp2020 = temp2020 + zeros(temp);

temp2019(isnan(temp2019))=0;
temp2020(isnan(temp2020))=0;
% chose_day_2019 = 365-60:365;% out of 365 days
% chose_day_2020 = 366-60:366;% out of 366 days
chose_month = 6; % in summer June-October, covid symptons should be more obvious since no flu
if chose_month == 1
    chose_day_2019 = 1:31;
    chose_day_2020 = 1:31;
elseif chose_month == 2
    chose_day_2019 = 31+1 : 31+28;
    chose_day_2020 = 31+1 : 31+feb_day;
elseif chose_month == 3
    chose_day_2019 = 31+28+1 : 31+28+31;
    chose_day_2020 = 31+feb_day+1 : 31+feb_day+31;
elseif chose_month == 4
    chose_day_2019 = 31+28+31+1 : 31+28+31+30;
    chose_day_2020 = 31+feb_day+31+1 : 31+feb_day+31+30;
elseif chose_month == 5
    chose_day_2019 = 31+28+31+30+1 : 31+28+31+30+31;
    chose_day_2020 = 31+feb_day+31+30+1 : 31+feb_day+31+30+31;
elseif chose_month == 6
    chose_day_2019 = 31+28+31+30+31+1 : 31+28+31+30+31+30;
    chose_day_2020 = 31+feb_day+31+30+31+1 : 31+feb_day+31+30+31+30;
elseif chose_month == 7
    chose_day_2019 = 31+28+31+30+31+30+1 : 31+28+31+30+31+30+31;
    chose_day_2020 = 31+feb_day+31+30+31+30+1 : 31+feb_day+31+30+31+30+31;
elseif chose_month == 8
    chose_day_2019 = 31+28+31+30+31+30+31+1 : 31+28+31+30+31+30+31+31;
    chose_day_2020 = 31+feb_day+31+30+31+30+31+1 : 31+feb_day+31+30+31+30+31+31;
elseif chose_month == 9
    chose_day_2019 = 31+28+31+30+31+30+31+31+1 : 31+28+31+30+31+30+31+31+30;
    chose_day_2020 = 31+feb_day+31+30+31+30+31+31+1 : 31+feb_day+31+30+31+30+31+31+30;
elseif chose_month == 10
    chose_day_2019 = 31+28+31+30+31+30+31+31+30+1 : 31+28+31+30+31+30+31+31+30+31;
    chose_day_2020 = 31+feb_day+31+30+31+30+31+31+30+1 : 31+feb_day+31+30+31+30+31+31+30+31;
elseif chose_month == 11
    chose_day_2019 = 31+28+31+30+31+30+31+31+30+31+1 : 31+28+31+30+31+30+31+31+30+31+30;
    chose_day_2020 = 31+feb_day+31+30+31+30+31+31+30+31+1 : 31+feb_day+31+30+31+30+31+31+30+31+30;
elseif chose_month == 12
    chose_day_2019 = 31+28+31+30+31+30+31+31+30+31+30+1 : 31+28+31+30+31+30+31+31+30+31+30+31;
    chose_day_2020 = 31+feb_day+31+30+31+30+31+31+30+31+30+1 : 31+feb_day+31+30+31+30+31+31+30+31+30+31;
end
% chose_day_2019 = 365-30:365;% out of 365 days
% chose_day_2020 = 366-30:366;% out of 366 days
% load('covid2019us.mat')
% load('covid2020us.mat')
% take flu season data only from all states, 2019 and 2020 December
% 93   Cough
% 142: fever
% 139  Fatigue
% 169: headache

% 21  Anxiety
% 268 Nausea
% 7,  Ageusia loss of taste, covid only
% 20:  Anosmia, oss of smell, Covid only
% 351  Shortness of breath, covid and severe flu, can view it as covid only
% 412 Vomiting
% 101 Diarrhea, covid only
feature_set =[7,351,20,412,110, 93,142, 139, 169];
chose_row_2019 = chose_day_2019;
rand_states = randperm(51);
chose_states = rand_states(1:50);
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

% X = temp2020(chose_row_2020 ,feature_set);
% Y = temp2019(chose_row_2019 ,feature_set);
X = temp2020(:, feature_set );
Y = temp2019(:, feature_set );
% remove the rows when Anosmia is 0
X=X(find(X(:,1)~=0),:);
Y=Y(find(Y(:,1)~=0),:);
% X = covid2020us(1:end,feature_set);
% Y = covid2019us(1:end,feature_set);
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
%% plot for slides
sympts = {'Ageusia', 'Shortness of breath', 'Anosmia','Vomiting','Diarrhea','Cough','Fever','Fatigue','Headache'};
% dpca
[Vrr, Xr]=nndpca(X,Y,4);
[valsort,ind] = sort(((Vrr(:,1))),'descend');
sympts_sorted = sympts(ind);
x = categorical(sympts_sorted);
x = reordercats(x,sympts_sorted);
y = valsort;
figure;
subplot(2,2,1);
bar(x,y,'FaceColor',[0.5 0 0]); grid on; title('dPCA');
ylabel('Sympton coefficients');

% cpca
alpha=0.5;
Us = cpca_alpha(X, Y, alpha,4);
[valsort,ind] = sort((Us(:,1)),'descend');
sympts_sorted = sympts(ind);
x = categorical(sympts_sorted);
x = reordercats(x,sympts_sorted);
y = valsort;
subplot(2,2,2);
bar(x,y,'FaceColor',[0.5 0 0]); grid on; title('cPCA');
ylabel('Sympton coefficients');

% pca on 2019 data
alpha=-999999;
Us = cpca_alpha(X, Y, alpha,1);
[valsort,ind] = sort((Us(:,1)),'descend');
sympts_sorted = sympts(ind);
x = categorical(sympts_sorted);
x = reordercats(x,sympts_sorted);
y = valsort;
subplot(2,2,3);
bar(x,y,'FaceColor',[0.5 0 0]); grid on; title('PCA using 2019 data');
ylabel('Sympton coefficients');

% pca on 2020 data
alpha=0;
Us = cpca_alpha(X, Y, alpha,1);
[valsort,ind] = sort((Us(:,1)),'descend');
sympts_sorted = sympts(ind);
x = categorical(sympts_sorted);
x = reordercats(x,sympts_sorted);
y = valsort;
subplot(2,2,4);
bar(x,y,'FaceColor',[0.5 0 0]); grid on; title('PCA using 2020 data');
ylabel('Sympton coefficients');

% think about before and after covid case peak, 11/1/2020-2/1/2021
% hawii's peak is Summer, others is winter

%  for i = 1:422
%
%  i=i
%  txtData(ind(i))
%  end