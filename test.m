clear
clc

load('simMatrix1.txt');
load('simMatrix2.txt');
a = diag(simMatrix1);
[G,Z] = hist(a,10);
% plot(Z,G)
% 
D = diag(simMatrix1);
E = diag(D);
I = simMatrix1 - E;


b = I(:);
[X,Y] = hist(b,10);
h1 =  plot(Z,G/466)

hold on
h2 = plot(Y,X/217156)
 
set([h1 h2],'LineWidth',2)
xlabel('score')
ylabel('probability')
title('geniue-imposter(system1)')
legend('genuine','imposter')