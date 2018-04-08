clc
close all

Genuine = diag(hd_a);   %vector
D = diag(Genuine);
Imposter = hd_a - D;   %matrix
Imposter_ = Imposter(Imposter>0);

Genuine_mean = mean(Genuine);
Imposter_mean = mean(Imposter_);

Genuine_std = std(Genuine);
Imposter_std = std(Imposter_);

% figure(1)
% hist(Genuine, 50)
% hold on
% hist(Imposter, 50)

X = linspace(0,0.6,100);
% y_gen = gaussmf(X,[std(Genuine) mean(Genuine)]);         
% y_imp = gaussmf(X,[std(Imposter) mean(Imposter)]); 

y_gen = normpdf(X,mean(Genuine),std(Genuine));         
y_imp = normpdf(X,mean(Imposter_),std(Imposter_)); 

figure(2)
h = plot(X, y_gen,'r')
hold on
k = plot(X, y_imp,'b')

hold on 
histogram(Genuine,50,'Normalization','pdf')
hold on
histogram(Imposter_,50,'Normalization','pdf')

set(h,'linewidth',2);
set(k,'linewidth',2);
xlabel('Hamming distance')
ylabel('counts')
title('geniue-imposter(Guassian distribution)')

legend({'genuine','imposter'},'Position',[0.3 0.7 0.05 0.05])


%[row, col] = find(ismember(Imposter, max(Imposter(:))))










