clc
close all
clear

addpath(genpath('F:\University of Florida\first year 2\Biometric identification\HW\HW3\GallerySet'));
addpath(genpath('F:\University of Florida\first year 2\Biometric identification\HW\HW3\ProbeSet'));

%
gallery_set = cell(100,1);
Cg1 = cell(100,1);
for i = 1:100
    matFilename = sprintf('subject%d_img1.PGM',i);
    Cg1{i,1} = imread(matFilename);
    gallery_set{i} = matFilename;
end

%%%%%%%%%%probe1%%%%%%%%%%%%%%%%%%%%%
Cp1 = cell(100,1);
for i = 1:100
    matFilename = sprintf('subject%d_img2.PGM',i);
    Cp1{i,1} = imread(matFilename);
 
end

%get only the buttom part
for i = 1:100
    Cp1{i} = Cp1{i}(26:50,:);
    Cg1{i} = Cg1{i}(26:50,:);
end

%score of probe1 vs gallery
score_face = zeros(100,100);

for i = 1:100
    for j = 1:100;
        score_face(i,j) = corr2(Cp1{i},Cg1{j});
    end
end

%normalization for face
score_face = (score_face - mean(score_face(:)))/std(score_face(:));

%score for iris (filtered)
m = matfile('iris_filter')
hd_a_filter =  m.hd_a;

%transform hd_a_filter
for x = 1:100
    for y = 1:100
        hd_a_filter(x,y) = 1 / (hd_a_filter(x,y) + 1);
    end
end

%normalized iris
hd_a_filter = (hd_a_filter - mean(hd_a_filter(:)))/std(hd_a_filter(:));

%average two template
average_score = (score_face + hd_a_filter) / 2;

%G I scores
Genuine = diag(average_score);
E1 = diag(Genuine);
Imposter = average_score - E1;
Imposter = Imposter(Imposter~=0);

%plot the distribution
[G1,Z1] = hist(Genuine,10);
[X1,Y1] = hist(Imposter,10);
figure(1)
h1 =  plot(Z1,G1/100)
hold on
h2 = plot(Y1,X1/9900)
 
set([h1 h2],'LineWidth',2)
xlabel('score')
ylabel('probability')
title('geniue-imposter(multi-models(filteriris&buttomface))')
legend({'genuine','imposter'},'Position',[0.5 0.8 0.05 0.05])

%%%ROC
FAR = zeros(100,1);
FRR = zeros(100,1);

for i=1:10000
  FAR(i,1)= numel(Imposter(Imposter>(0.01*i-10)))/9900;
  FRR(i,1)= numel(Genuine(Genuine<(0.01*i-10)))/100;
end

XXX = 0.01:0.01:1;
YYY = 0.01:0.01:1;

figure(2)
h11 = plot(FAR,FRR)
hold on 
h22 = plot(XXX,YYY)
xlabel('FAR')
ylabel('FRR')
title('ROC(multi-models(filteriris&buttomface))')
legend('ROC','EER')
set([h11],'LineWidth',2)
axis([0 1 0 1])

%%%CMC%%%%
A = zeros(100);

for i=1:100
A(i,:) = sort(average_score(i,:));
end
 
A=fliplr(A);

C = zeros(1,100);

dia=diag(average_score);

for i=1:100
    for j=1:70
        if A(i,j)==dia(i)
            C(1,i)=j;
        end
    end
end
   
 D = zeros(70,1);

 for j=1:70
     D(j,1)=numel(find(C<=j&C~=0));
 end

figure(3)
j= 1:1:70;
G = D/100;
h1 = plot(j,G)
xlabel('rank(t)')
ylabel('Rank-t identification rate(%)')
title('CMC(multi-models(filteriris&buttomface))')
set([h1],'LineWidth',2)
legend({'CMC(filteriris&buttomface)'},'Position',[0.7 0.5 0.05 0.05])
axis([1 70 0.93 1])








