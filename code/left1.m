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


for i = 1:100
    Cp1{i} = Cp1{i}(:,1:25)
    Cg1{i} = Cg1{i}(:,1:25)
end


XX1 = zeros(100,100);

for i = 1:100
    for j = 1:100;
XX1(i,j) = corr2(Cp1{i},Cg1{j});
    end
end


a1 = diag(XX1);
% [G1,Z1] = hist(a,10);
% % plot(Z,G)
% % 
D1 = diag(XX1);
E1 = diag(D1);
I1 = XX1 - E1;
 
%%%%%%%%%%probe2%%%%%%%%%%%%%%%%%%%%%

P = 'F:\University of Florida\first year 2\Biometric identification\HW\HW3\ProbeSet';
D = dir(fullfile(P,'*_img3.pgm'));
Cp2 = cell(size(D));
for k = 1:numel(D)
    Cp2{k} = imread(fullfile(P,D(k).name));
end

for i = 1:100
    Cp2{i} = Cp2{i}(:,1:25)
    Cg1{i} = Cg1{i}(:,1:25)
end


XX2 = zeros(100,100);

for i = 1:100
    for j = 1:100;
XX2(i,j) = corr2(Cp2{i},Cg1{j});
    end
end



a2 = diag(XX2);

D2 = diag(XX2);
E2 = diag(D2);
I2 = XX2 - E2;
%%%GEN%%%
Gen_all = zeros(100,2);
Gen_all(:,1)=D1;
Gen_all(:,2)=D2;
GEN = Gen_all(:);
%%%

%%%IM%%%
Im_all = zeros(200,100);
Im_all(1:100,:)=I1;
Im_all(101:200,:)=I2;
IM = Im_all(:);
%%%%%


% [Z,G] = hist(Gen_all,10);

[G1,Z1] = hist(GEN,10);
[X1,Y1] = hist(IM,10);
figure(1)

h1 =  plot(Z1,G1/200)

hold on
h2 = plot(Y1,X1/19709)
 
set([h1 h2],'LineWidth',2)
xlabel('score')
ylabel('probability')
title('geniue-imposter(left part)')
legend({'genuine','imposter'},'Position',[0.3 0.8 0.05 0.05])


%%%ROC
FAR = zeros(100,1);
FRR = zeros(100,1);

for i=1:100
  FAR(i,1)= numel(IM(IM>(0.01*i)))/19800;
  FRR(i,1)= numel(GEN(GEN<(0.01*i)))/200;
end

XXX = 0.01:0.01:1;
YYY = 0.01:0.01:1;


figure(2)
h11 = plot(FAR,FRR)
hold on 
h22 = plot(XXX,YYY)
xlabel('FAR')
ylabel('FRR')
title('ROC(left part)')
legend('ROC','EER')
 set([h11],'LineWidth',2)

% threshold = 0.01:0.01:1;
% figure(3)
% h33 = plot(threshold,FAR)
% hold on
% h44 = plot(threshold,FRR)
% xlabel('degree of match threshold')
% ylabel('error-rate')
% title('FAR-FRR(left part)')
% legend('FAR','FRR')
% set([h33 h44],'LineWidth',2)


%%%CMC%%%%
XX_all = zeros(200,100);
XX_all(1:100,:) = XX1;
XX_all(101:200,:) = XX2;



A = zeros(200,100);

for i=1:200
A(i,:) = sort(XX_all(i,:));
end
 
A=fliplr(A);

C = zeros(1,200);

%%%%%%%%dia%%%
dia = zeros(200,1);
dia(1:100,1)=diag(XX_all(1:100,:));
dia(101:200,1)=diag(XX_all(101:200,:));
%%%%%%%%%%%

for i=1:200
    for j=1:60
        if A(i,j)==dia(i)
            C(1,i)=j;
        end
    end
end
   
 DD = zeros(60,1);

 for j=1:60
     DD(j,1)=numel(find(C<=j&C~=0));
 end

jj= 1:1:60;
GG = DD/200;
figure(4)
h1 = plot(jj,GG)
xlabel('rank(t)')
ylabel('Rank-t identification rate(%)')
title('CMC(left part)')
set([h1],'LineWidth',2)
legend({'ROC(left part)'},'Position',[0.7 0.5 0.05 0.05])