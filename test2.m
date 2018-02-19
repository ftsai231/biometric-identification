clear
clc

load('simMatrix1.txt');
load('simMatrix2.txt');
a = diag(simMatrix2);
[G,Z] = hist(a,10);
% plot(Z,G)
% 
D = diag(simMatrix2);
E = diag(D);
I = simMatrix2 - E;

b = I(:);
[X,Y] = hist(b,10);
h1 =  plot(Z,G/466)

hold on
h2 = plot(Y,X/217156)
 
set([h1 h2],'LineWidth',2)
xlabel('score')
ylabel('probability')
title('geniue-imposter(system2)')
legend('genuine','imposter')