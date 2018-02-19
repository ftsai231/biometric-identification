clear
clc
load('simMatrix1.txt');
load('simMatrix2.txt');
A = diag(simMatrix2);
 
%geniune
B = [0 0 0 0 0 0 0 ];
for g=1:1:466
    if 0<=A(g)<0.05
        B(1) = B(1)+1;
        
    elseif 0.05<=A(g)<0.1
        B(2) = B(2)+1;
        
    elseif 0.1<=A(g)<0.15
        B(3) = B(3)+1;
        
    elseif 0.15<=A(g)<0.2
        B(4) = B(4)+1;
        
    elseif 0.2<=A(g)<0.25
        B(5) = B(5)+1;
        
    elseif 0.25<=A(g)<0.3
        B(6) = B(6)+1;
        
    elseif 0.3<=A(g)<0.35
        B(7) = B(7)+1;
        
%     elseif 0.35<=A(g)<0.4
%         B(8) = B(8)+1;
        
%     elseif 0.4<=A(g)<0.45
%         B(9) = B(9)+1;
%       
%     else 0.9<=A(g)<=1
%         B(10) = B(10)+1;
    end
end
B = B/466;

%imposter

D = diag(simMatrix2);

E = diag(D);

I = simMatrix2 - E;

Im = [0 0 0 0 0 0 0 ];
for j = 1:1:466
for g=1:1:466
    if 0<I(g,j)<0.05
        Im(1) = Im(1)+1;
        
    elseif 0.05<=I(g,j)<0.1
        Im(2) = Im(2)+1;
        
    elseif 0.1<=I(g,j)<0.15
        Im(3) = Im(3)+1;
        
    elseif 0.15<=I(g,j)<0.2
        Im(4) = Im(4)+1;
        
    elseif 0.2<=I(g,j)<0.25
        Im(5) = Im(5)+1;
        
    elseif 0.25<=I(g,j)<0.3
        Im(6) = Im(6)+1;
        
    elseif 0.3<=I(g,j)<0.35
        Im(7) = Im(7)+1;
        
%     elseif 0.35<=I(g,j)<0.4
%         Im(8) = Im(8)+1;
%         
%     elseif 0.8<=I(g,j)<0.9
%         Im(9) = Im(9)+1;
%       
%     else 0.9<=I(g,j)<=1
%         Im(10) = Im(10)+1;
    end
end
end
Im = Im / (465^2);
C = 0.025:0.05:0.325;

figure


h1 = plot(C,B)
hold on
h2 = plot(C,Im)
set([h1 h2],'LineWidth',2)
xlabel('score')
ylabel('No.')
title('geniue-imposter(system2)')
legend('genuine','imposter')

d = (sqrt(2)*abs(mean(A(:))-mean(I(:))))/sqrt(var(A(:))^2+var(I(:))^2)
