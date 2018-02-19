clear
clc

load('simMatrix1.txt');
load('simMatrix2.txt');

Gen = diag(simMatrix1);

E = diag(Gen);

Im = simMatrix1 - E;

Im = Im(Im>0);

FAR = zeros(31,1);
FRR = zeros(31,1);

for i=1:31
  FAR(i,1)= numel(Im(Im>(0.19+0.01*i)))/216690;
  FRR(i,1)= numel(Gen(Gen<(0.19+0.01*i)))/466;
end

X = 0:0.01:0.5;
Y = 0:0.01:0.5;


figure(1)
h1 = plot(FAR,FRR)
hold on 
h2 = plot(X,Y)
xlabel('FAR')
ylabel('FRR')
title('ROC(system1)')
legend('ROC','EER')
set([h1 h2],'LineWidth',2)

threshold = 0:0.01:0.3;
figure(2)
h3 = plot(threshold,FAR)
hold on
h4 = plot(threshold,FRR)
xlabel('degree of match threshold')
ylabel('error-rate')
title('FAR-FRR(system1)')
legend('FAR','FRR')
set([h3 h4],'LineWidth',2)



