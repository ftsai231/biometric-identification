clear
clc
close all

%load the gallery
P = 'F:\University of Florida\first year 2\Biometric identification\HW\HW3\GallerySet';
D = dir(fullfile(P,'*.pgm'));
Cg = cell(size(D));
for k = 1:numel(D)
    Cg{k} = imread(fullfile(P,D(k).name));
end

Tg = zeros(2500,100);

for i =1:100
    matrix=Cg{i};
    Tg(:,i) = matrix(:);
end

Phi_gal = Tg - mean(Tg,2);

[EigenVector,SCORE,EigenValue] = princomp(Phi_gal');

EigenVector = EigenVector(:,1:87);
for i = 1:87
    EigenVector(:,i) = EigenVector(:,i)/norm(EigenVector(:,i));
end

weight_gal = EigenVector'*Phi_gal;

%load probe 1
P = 'F:\University of Florida\first year 2\Biometric identification\HW\HW3\ProbeSet';
D = dir(fullfile(P,'*_img2.pgm'));
Cp1 = cell(size(D));
for k = 1:numel(D)
    Cp1{k} = imread(fullfile(P,D(k).name));
end

for i = 1:100
    for j = 1:100;
        XX1(i,j) = corr2(Cp1{i},Cg{j});
    end
end
%normalize correlation
XX1 = (XX1 - mean(XX1(:)))/std(XX1(:));

%Genuine and imposter
Genuine_correlation = diag(XX1);
E1 = diag(Genuine_correlation);
Imposter_correlation = XX1 - E1;
Imposter_correlation = Imposter_correlation(Imposter_correlation~=0);

%pca
Tp1 = zeros(2500,100);

for i =1:100
    matrix=Cp1{i};
    Tp1(:,i) = matrix(:);
end

Phi_pro1 = Tp1 - mean(Tp1,2);

weight_pro1 = EigenVector'*Phi_pro1;

distance1 = zeros(100,100);

for i = 1:100
    for j = 1:100
    distance1(j,i) = norm(weight_gal(:,i)-weight_pro1(:,j));
    end
end

%transform from distance to similarity
for x = 1:100
    for y = 1:100
        distance1(x,y) = 1 / (distance1(x,y) + 1);
    end
end

%normalize PCA
distance1 = (distance1 - mean(distance1(:)))/std(distance1(:));


Genuine_PCA = diag(distance1);
E1 = diag(Genuine_PCA);
Imposter_PCA = distance1 - E1;
Imposter_PCA = Imposter_PCA(Imposter_PCA~=0);

Gen_overall = (Genuine_PCA + Genuine_correlation)/2;
Im_overall = (Imposter_PCA + Imposter_correlation)/2;

%Distribution
[G1,Z1] = hist(Gen_overall,10);
[X1,Y1] = hist(Im_overall,10);

figure(1)
h1 =  plot(Z1,G1/100)
hold on
h2 = plot(Y1,X1/9900)
set([h1 h2],'LineWidth',2)
xlabel('score')
ylabel('probability')
title('geniue-imposter(multi-algorithms)')
legend({'genuine','imposter'},'Position',[0.6 0.8 0.05 0.05])

%%%ROC
FAR = zeros(100,1);
FRR = zeros(100,1);

for i=1:10000
  FAR(i,1)= numel(Im_overall(Im_overall>(0.01*i-10)))/9900;
  FRR(i,1)= numel(Gen_overall(Gen_overall<(0.01*i-10)))/100;
end

XXX = 0.01:0.01:1;
YYY = 0.01:0.01:1;

figure(2)
h11 = plot(FAR,FRR)
hold on 
h22 = plot(XXX,YYY)
xlabel('FAR')
ylabel('FRR')
title('ROC(multi-algorithms)')
legend('ROC','EER')
set([h11],'LineWidth',2)
axis([0 1 0 1])

%%%CMC%%%%
average_score = (distance1 + XX1)/2;

A = zeros(100);

for i=1:100
A(i,:) = sort(average_score(i,:));
end
 
A=fliplr(A);

C = zeros(1,100);

dia=diag(average_score);

for i=1:100
    for j=1:50
        if A(i,j)==dia(i)
            C(1,i)=j;
        end
    end
end
   
 D = zeros(50,1);

 for j=1:50
     D(j,1)=numel(find(C<=j&C~=0));
 end

figure(3)
j= 1:1:50;
G = D/100;
h1 = plot(j,G)
xlabel('rank(t)')
ylabel('Rank-t identification rate(%)')
title('CMC(multi-algorithms)')
set([h1],'LineWidth',2)
legend({'CMC(multi-algorithms)'},'Position',[0.7 0.5 0.05 0.05])
axis([1 50 0.75 1])



