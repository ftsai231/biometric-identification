clear
clc
load('simMatrix1.txt');
load('simMatrix2.txt');

A = zeros(466);
 
for i=1:466
A(i,:) = sort(simMatrix2(i,:));
end

A=fliplr(A);

C = zeros(1,466);

dia=diag(simMatrix2);

for i=1:466
    for j=1:350
        if A(i,j)==dia(i)
            C(1,i)=j;
        end
    end
end
   
 D = zeros(350,1);

 for j=1:350
     D(j,1)=numel(find(C<=j&C~=0));
 end

 


 t = 0.7
 
 
j= 1:1:350;
G = D/466;
h1 = plot(j,G)
hold on
h2 = plot(j,t*ones(size(j)))
set([h1 h2],'LineWidth',2)
xlabel('rank(t)')
ylabel('Rank-t identification rate(%)')
title('CMC(system2)')
legend({'ROC(system2)'},'Position',[0.7 0.5 0.05 0.05])