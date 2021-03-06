clear,clc,close all
[~,txtData]  = xlsread('Symptonnames.xlsx','A1:PF1');
[temp]  = readmatrix('2018_country_daily_2018_US_daily_symptoms_dataset.csv');
temp2018 = temp(:,8:end);% whole dataset, 1-365 rows for Us, then each 365 rows for 1 state
[temp]  = readmatrix('2019_country_daily_2019_US_daily_symptoms_dataset.csv');
temp2019 = temp(:,8:end);% whole dataset, 1-365 rows for Us, then each 365 rows for 1 state
[temp]  = readmatrix('2020_country_daily_2020_US_daily_symptoms_dataset.csv');
temp2020 = temp(:,8:end);% whole dataset, 1-365 rows for Us, then each 365 rows for 1 state

temp2018(isnan(temp2018))=0;
temp2019(isnan(temp2019))=0;
temp2020(isnan(temp2020))=0;

feature_set =[7,351,20,412,110, 93,142, 139, 169];
sympts = {'Ageusia', 'Shortness of breath', 'Anosmia','Vomiting','Diarrhea','Cough','Fever','Fatigue','Headache'};

X = temp2020(:, feature_set );
Y = temp2019(:, feature_set );
Z = temp2018(:, feature_set );
% remove the rows when Anosmia is 0
X=X(find(X(:,1)~=0),:);
Y=Y(find(Y(:,1)~=0),:);
Z=Z(find(Z(:,1)~=0),:);

%% plot for slides



%% alternatives 
%cpca
alpha=0.1;
Us = cpca_alpha(X, Y, alpha,1);
[valsort,ind] = sort((Us(:,1)),'descend');
sympts_sorted = sympts(ind);
x = categorical(sympts_sorted);
x = reordercats(x,sympts_sorted);
y = valsort;
figure;
subplot(3,2,1);
bar(x,y,'FaceColor',[0.5 0 0]); grid on; title('cPCA (target:2020, background:2019) \alpha=0.1');
ylabel('Sympton coefficients');

alpha=0.1;
Us = cpca_alpha(X, Z, alpha,1);
[valsort,ind] = sort((Us(:,1)),'descend');
sympts_sorted = sympts(ind);
x = categorical(sympts_sorted);
x = reordercats(x,sympts_sorted);
y = valsort;
subplot(3,2,2);
bar(x,y,'FaceColor',[0.5 0 0]); grid on; title('cPCA (target:2020, background:2018) \alpha=0.1');
ylabel('Sympton coefficients');

alpha=0.5;
Us = cpca_alpha(X, Y, alpha,1);
[valsort,ind] = sort((Us(:,1)),'descend');
sympts_sorted = sympts(ind);
x = categorical(sympts_sorted);
x = reordercats(x,sympts_sorted);
y = valsort;
subplot(3,2,3);
bar(x,y,'FaceColor',[0.5 0 0]); grid on; title('cPCA (target:2020, background:2019) \alpha=0.5');
ylabel('Sympton coefficients');

alpha=0.5;
Us = cpca_alpha(X, Z, alpha,1);
[valsort,ind] = sort((Us(:,1)),'descend');
sympts_sorted = sympts(ind);
x = categorical(sympts_sorted);
x = reordercats(x,sympts_sorted);
y = valsort;
subplot(3,2,4);
bar(x,y,'FaceColor',[0.5 0 0]); grid on; title('cPCA (target:2020, background:2018) \alpha=0.5');
ylabel('Sympton coefficients');

alpha=0.9;
Us = cpca_alpha(X, Y, alpha,1);
[valsort,ind] = sort((Us(:,1)),'descend');
sympts_sorted = sympts(ind);
x = categorical(sympts_sorted);
x = reordercats(x,sympts_sorted);
y = valsort;
subplot(3,2,5);
bar(x,y,'FaceColor',[0.5 0 0]); grid on; title('cPCA (target:2020, background:2019) \alpha=0.9');
ylabel('Sympton coefficients');

alpha=0.9;
Us = cpca_alpha(X, Z, alpha,1);
[valsort,ind] = sort((Us(:,1)),'descend');
sympts_sorted = sympts(ind);
x = categorical(sympts_sorted);
x = reordercats(x,sympts_sorted);
y = valsort;
subplot(3,2,6);
bar(x,y,'FaceColor',[0.5 0 0]); grid on; title('cPCA (target:2020, background:2018) \alpha=0.9');
ylabel('Sympton coefficients');

% nnmf on 2020 data
k=1;
[U,W] = nnmf(X' , k);
s = zeros(k,1);
for i = 1:size(U,2)
    s(i) = norm(U(:,i))* norm(W(i,:));
    U(:,i) = U(:,i)/norm(U(:,i));
end
[~, ind0] = sort(s, 'descend');
Vrr = U(:, ind0(1:k));
[valsort,ind] = sort(((Vrr(:,1))),'descend');
sympts_sorted = sympts(ind);
x = categorical(sympts_sorted);
x = reordercats(x,sympts_sorted);
y = valsort;
figure;
subplot(3,2,1);
bar(x,y,'FaceColor',[0.5 0 0]); grid on; title('NNMF using 2020 data');
ylabel('Sympton coefficients');

% nnmf on 2019 data
k=1;
[U,W] = nnmf(Y' , k);
s = zeros(k,1);
for i = 1:size(U,2)
    s(i) = norm(U(:,i))* norm(W(i,:));
    U(:,i) = U(:,i)/norm(U(:,i));
end
[~, ind0] = sort(s, 'descend');
Vrr = U(:, ind0(1:k));
[valsort,ind] = sort(((Vrr(:,1))),'descend');
sympts_sorted = sympts(ind);
x = categorical(sympts_sorted);
x = reordercats(x,sympts_sorted);
y = valsort;
subplot(3,2,3);
bar(x,y,'FaceColor',[0.5 0 0]); grid on; title('NNMF using 2019 data');
ylabel('Sympton coefficients');

% nnmf on 2018 data
k=1;
[U,W] = nnmf(Z' , k);
s = zeros(k,1);
for i = 1:size(U,2)
    s(i) = norm(U(:,i))* norm(W(i,:));
    U(:,i) = U(:,i)/norm(U(:,i));
end
[~, ind0] = sort(s, 'descend');
Vrr = U(:, ind0(1:k));
[valsort,ind] = sort(((Vrr(:,1))),'descend');
sympts_sorted = sympts(ind);
x = categorical(sympts_sorted);
x = reordercats(x,sympts_sorted);
y = valsort;
subplot(3,2,5);
bar(x,y,'FaceColor',[0.5 0 0]); grid on; title('NNMF using 2018 data');
ylabel('Sympton coefficients');

% pca on 2020 data
alpha=0;
Us = cpca_alpha(X, Y, alpha,1);
[valsort,ind] = sort((Us(:,1)),'descend');
sympts_sorted = sympts(ind);
x = categorical(sympts_sorted);
x = reordercats(x,sympts_sorted);
y = valsort;
subplot(3,2,2);
bar(x,y,'FaceColor',[0.5 0 0]); grid on; title('PCA using 2020 data');
ylabel('Sympton coefficients');

% pca on 2019 data
alpha=0;
Us = cpca_alpha(Y, X, alpha,1);
[valsort,ind] = sort((Us(:,1)),'descend');
sympts_sorted = sympts(ind);
x = categorical(sympts_sorted);
x = reordercats(x,sympts_sorted);
y = valsort;
subplot(3,2,4);
bar(x,y,'FaceColor',[0.5 0 0]); grid on; title('PCA using 2019 data');
ylabel('Sympton coefficients');

% pca on 2018 data
alpha=0;
Us = cpca_alpha(Z, Y, alpha,1);
[valsort,ind] = sort((Us(:,1)),'descend');
sympts_sorted = sympts(ind);
x = categorical(sympts_sorted);
x = reordercats(x,sympts_sorted);
y = valsort;
subplot(3,2,6);
bar(x,y,'FaceColor',[0.5 0 0]); grid on; title('PCA using 2018 data');
ylabel('Sympton coefficients');

%% dpca
[Vrr, Xr]=nndpca(X,Y,1);
[valsort,ind] = sort(((Vrr(:,1))),'descend');
sympts_sorted = sympts(ind);
x = categorical(sympts_sorted);
x = reordercats(x,sympts_sorted);
y = valsort;
figure;
subplot(3,2,1);
bar(x,y,'FaceColor',[0 0 0.5]); grid on; title('dPCA (target:2020, background:2019)');
ylabel('Sympton coefficients');

[Vrr, Xr]=nndpca(X,Z,1);
[valsort,ind] = sort(((Vrr(:,1))),'descend');
sympts_sorted = sympts(ind);
x = categorical(sympts_sorted);
x = reordercats(x,sympts_sorted);
y = valsort;
subplot(3,2,2);
bar(x,y,'FaceColor',[0 0 0.5]); grid on; title('DNA (target:2020, background:2018)');
ylabel('Sympton coefficients');

[Vrr, Xr]=nndpca(Y,X,1);
[valsort,ind] = sort(((Vrr(:,1))),'descend');
sympts_sorted = sympts(ind);
x = categorical(sympts_sorted);
x = reordercats(x,sympts_sorted);
y = valsort;
subplot(3,2,3);
bar(x,y,'FaceColor',[0.5 0 0]); grid on; title('DNA (target:2019, background:2020)');
ylabel('Sympton coefficients');

[Vrr, Xr]=nndpca(Z,X,1);
[valsort,ind] = sort(((Vrr(:,1))),'descend');
sympts_sorted = sympts(ind);
x = categorical(sympts_sorted);
x = reordercats(x,sympts_sorted);
y = valsort;
subplot(3,2,4);
bar(x,y,'FaceColor',[0.5 0 0]); grid on; title('DNA (target:2018, background:2020)');
ylabel('Sympton coefficients');


[Vrr, Xr]=nndpca(Y,Z,1);
[valsort,ind] = sort(((Vrr(:,1))),'descend');
sympts_sorted = sympts(ind);
x = categorical(sympts_sorted);
x = reordercats(x,sympts_sorted);
y = valsort;
subplot(3,2,5);
bar(x,y,'FaceColor',[0.5 0 0]); grid on; title('DNA (target:2019, background:2018)');
ylabel('Sympton coefficients');

[Vrr, Xr]=nndpca(Z,Y,1);
[valsort,ind] = sort(((Vrr(:,1))),'descend');
sympts_sorted = sympts(ind);
x = categorical(sympts_sorted);
x = reordercats(x,sympts_sorted);
y = valsort;
subplot(3,2,6);
bar(x,y,'FaceColor',[0.5 0 0]); grid on; title('DNA (target:2018, background:2019)');
ylabel('Sympton coefficients');




