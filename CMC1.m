clear
clc
load('simMatrix1.txt');
load('simMatrix2.txt');

A = zeros(466);

for i=1:466
A(i,:) = sort(simMatrix1(i,:));
end
 
A=fliplr(A);

C = zeros(1,466);

dia=diag(simMatrix1);

for i=1:466
    for j=1:170
        if A(i,j)==dia(i)
            C(1,i)=j;
        end
    end
end
   
 D = zeros(170,1);

 for j=1:170
     D(j,1)=numel(find(C<=j&C~=0));
 end

j= 1:1:170;
G = D/466;
h1 = plot(j,G)
xlabel('rank(t)')
ylabel('Rank-t identification rate(%)')
title('CMC(system1)')
set([h1],'LineWidth',2)
legend({'ROC(system1)'},'Position',[0.7 0.5 0.05 0.05])

