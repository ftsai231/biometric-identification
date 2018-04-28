clear
clc
close all

P = 'F:\University of Florida\first year 2\Biometric identification\HW\HW3\GallerySet';
D = dir(fullfile(P,'*.pgm'));
Cg1 = cell(size(D));
for k = 1:numel(D)
    Cg1{k} = imread(fullfile(P,D(k).name));
end

%%%%%%%%%%probe1%%%%%%%%%%%%%%%%%%%%%
P = 'F:\University of Florida\first year 2\Biometric identification\HW\HW3\ProbeSet';
D = dir(fullfile(P,'*_img2.pgm'));
Cp1= cell(size(D));
for k = 1:numel(D)
    Cp1{k} = imread(fullfile(P,D(k).name));
end

%score of probe1 vs gallery
XX1 = zeros(100,100);

for i = 1:100
    for j = 1:100;
        XX1(i,j) = corr2(Cp1{i},Cg1{j});
    end
end

%%%%%%%%%%probe2%%%%%%%%%%%%%%%%%%%%%
P = 'F:\University of Florida\first year 2\Biometric identification\HW\HW3\ProbeSet';
D = dir(fullfile(P,'*_img3.pgm'));
Cp2 = cell(size(D));
for k = 1:numel(D)
    Cp2{k} = imread(fullfile(P,D(k).name));
end

%score of probe 2 and gallery
XX2 = zeros(100,100);

for i = 1:100
    for j = 1:100;
        XX2(i,j) = corr2(Cp2{i},Cg1{j});
    end
end

average_score = zeros(100,100);

for x = 1:100
    for y = 1:100
        average_score(x,y) = (XX1(x,y)+XX2(x,y))/2;
    end
end

Genuine = diag(average_score);
M = diag(Genuine);
Imposter = average_score - M;
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
title('geniue-imposter(multi-samples)')
legend({'genuine','imposter'},'Position',[0.3 0.8 0.05 0.05])

%%%ROC
FAR = zeros(100,1);
FRR = zeros(100,1);

for i=1:100
  FAR(i,1)= numel(Imposter(Imposter>(0.01*i)))/9900;
  FRR(i,1)= numel(Genuine(Genuine<(0.01*i)))/100;
end

XXX = 0.01:0.01:1;
YYY = 0.01:0.01:1;

figure(2)
h11 = plot(FAR,FRR)
hold on 
h22 = plot(XXX,YYY)
xlabel('FAR')
ylabel('FRR')
title('ROC(multi-samples)')
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
title('CMC(multi-samples)')
set([h1],'LineWidth',2)
legend({'CMC(multi-samples)'},'Position',[0.7 0.5 0.05 0.05])
axis([1 50 0.85 1])














