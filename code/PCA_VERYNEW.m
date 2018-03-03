clear
clc

P = 'F:\University of Florida\first year 2\Biometric identification\HW\HW3\GallerySet';
D = dir(fullfile(P,'*.pgm'));
Cg = cell(size(D));
for k = 1:numel(D)
    Cg{k} = imread(fullfile(P,D(k).name));
end

Tg = zeros(2500,100);

for i =1:100
    Tg(:,i) = Cg{i}(:);
end



Phi_gal = Tg - mean(Tg,2);


[EigenVector,SCORE,EigenValue] = princomp(Phi_gal');

for i = 1:87
    EigenVector(:,i) = EigenVector(:,i)/norm(EigenVector(:,i));
end

EigenVector = EigenVector(:,1:87);

B_gal = EigenVector'*(Phi_gal);

weight_gal = EigenVector'*Phi_gal;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P = 'F:\University of Florida\first year 2\Biometric identification\HW\HW3\ProbeSet';
D = dir(fullfile(P,'*_img2.pgm'));
Cp1 = cell(size(D));
for k = 1:numel(D)
    Cp1{k} = imread(fullfile(P,D(k).name));
end

Tp1 = zeros(2500,100);

for i =1:100
    Tp1(:,i) = Cp1{i}(:);
end

Phi_pro1 = Tp1 - mean(Tp1,2);


%B_pro1 = EigenVector'* (Phi_pro1);

weight_pro1 = EigenVector'*Phi_pro1;

distance1 = zeros(100,100);

for i = 1:100
    for j = 1:100
    distance1(i,j) = norm(weight_gal(:,i)-weight_pro1(:,j));
    end
end

Gen1 = diag(distance1);
D1 = diag(distance1);
E1 = diag(D1);
Im1 = distance1 - E1;


%%%%%%%%%%%%%%%%%%%%%%%%%%
P = 'F:\University of Florida\first year 2\Biometric identification\HW\HW3\ProbeSet';
D = dir(fullfile(P,'*_img3.pgm'));
Cp2 = cell(size(D));
for k = 1:numel(D)
    Cp2{k} = imread(fullfile(P,D(k).name));
end

Tp2 = zeros(2500,100);

for i =1:100
    Tp2(:,i) = Cp2{i}(:);
end

Phi_pro2 = Tp2 - mean(Tp2,2);


%B_pro2 = EigenVector'* (Phi_pro1);

weight_pro2 = EigenVector'*Phi_pro2;

distance2 = zeros(100,100);

for i = 1:100
    for j = 1:100
    distance2(i,j) = norm(weight_gal(:,i)-weight_pro2(:,j));
    end
end

Gen2 = diag(distance2);
D2 = diag(distance2);
E2 = diag(D2);
Im2 = distance2 - E2;

%%%%%%%%%%%%%all
%%%GEN%%%
Gen_all = zeros(100,2);
Gen_all(:,1)=Gen1;
Gen_all(:,2)=Gen2;
GEN = Gen_all(:);
%%%

%%%IM%%%
Im_all = zeros(200,100);
Im_all(1:100, :)=Im1;
Im_all(101:200, :)=Im2;
IM = Im_all(Im_all>0);
%%%%%

[G1,Z1] = hist(GEN,10);
[X1,Y1] = hist(IM,10);
figure(1)

h1 =  plot(Z1,G1/200)

hold on
h2 = plot(Y1,X1/19800)
 
set([h1 h2],'LineWidth',2)
xlabel('score')
ylabel('probability')
title('geniue-imposter(PCA-entire face)')
legend('genuine','imposter')

%%%%%%%ROC%%%%%%%%%%%%%%%
FAR = zeros(100,1);
FRR = zeros(100,1);

for i=1:100
  FAR(i,1)= numel(IM(IM<(1000+30*i)))/19800;
  FRR(i,1)= numel(GEN(GEN>(1000+30*i)))/200;
end

XXX = 0.01:0.01:1;
YYY = 0.01:0.01:1;


figure(2)
h11 = plot(FAR,FRR)
hold on 
h22 = plot(XXX,YYY)
xlabel('FAR')
ylabel('FRR')
title('ROC(PCA-entire face)')
legend('ROC','EER')
 set([h11 h22],'LineWidth',2)

threshold = 0.01:0.01:1;
figure(3)
h33 = plot(threshold,FAR)
hold on
h44 = plot(threshold,FRR)
xlabel('degree of match threshold')
ylabel('error-rate')
title('FAR-FRR(PCA-entire face)')
legend('FAR','FRR')
set([h33 h44],'LineWidth',2)

%%%CMC%%%%
XX_all = zeros(200,100);
XX_all(1:100,:) = distance1;
XX_all(101:200,:) = distance2;



A = zeros(200,100);

for i=1:200
A(i,:) = sort(XX_all(i,:));
end
 
%A=fliplr(A);

C = zeros(1,200);

%%%%%%%%dia%%%
dia = zeros(200,1);
dia(1:100,1)=diag(XX_all(1:100,:));
dia(101:200,1)=diag(XX_all(101:200,:));
%%%%%%%%%%%

for i=1:200
    for j=1:99
        if A(i,j)==dia(i)
            C(1,i)=j;
        end
    end
end
   
 DD = zeros(99,1);

 for j=1:99
     DD(j,1)=numel(find(C<=j&C~=0));
 end

jj= 1:1:99;
GG = DD/200;
figure(4)
h1 = plot(jj,GG)
xlabel('rank(t)')
ylabel('Rank-t identification rate(%)')
title('CMC(PCA-entire face)')
set([h1],'LineWidth',2)
legend({'ROC(entire face)'},'Position',[0.7 0.5 0.05 0.05])








