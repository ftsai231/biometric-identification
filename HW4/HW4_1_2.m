clear
clc

A1 = importdata('FP1.txt');          %image 1
A2 = importdata('FP6.txt');          %image 2

x1 = A1(:,1);                        %x of image 1
y1 = A1(:,2);                        %y of image 1
theta1 = A1(:,3)*11.25;              %theta of image 1
x2 = A2(:,1);
y2 = A2(:,2);
theta2 = A2(:,3)*11.25;

len = length(x1) * length(x2);
A = zeros(len, 3);
Theta = zeros(len, 1);

% delta theta

for i = 1:length(x1)
    for j = 1:length(x2)
        Theta((i-1)*length(x2)+j, 1) = theta1(i) - theta2(j);
    end
end

%range is from -180~180

for x = 1:len
    if Theta(x,1) < -180 
        Theta(x,1) = Theta(x,1) + 360;
    end
    
    if Theta(x,1) > 180
        Theta(x,1) = Theta(x,1) - 360;
    end
end

%delta x and delta y

for i = 1:length(x1)
    for j = 1:length(x2)
        A((i-1)*length(x2)+j,1) = x1(i) - x2(j)*cosd(Theta((i-1)*length(x2)+j, 1)) - y2(j)*sind(Theta((i-1)*length(x2)+j, 1));  %dx
        A((i-1)*length(x2)+j,2) = y1(i) + x2(j)*sind(Theta((i-1)*length(x2)+j, 1)) - y2(j)*cosd(Theta((i-1)*length(x2)+j, 1));  %dy
    end
end

A(:,3) = Theta(:,1);

sort_A = sort(A);
sort_Theta = sort(Theta);

count = zeros(22,22,17);
A_c = cell(22,22,17);
%%%%%%%%%%%%%%%%%%%%%   find the best range of difference
for i = -7:14
    for j = -7:14
        for k = -8:8
            for x = 1:len
                if A(x,1) > 50*(i-1) && A(x,1) <= 50*i && A(x,2) > 50*(j-1) && A(x,2) <= 50*j && A(x,3) > 25*(k-1) && A(x,3) <= 25*k
                    count(i+8,j+8,k+9) = count(i+8,j+8,k+9) + 1;
                    A_c{i+8,j+8,k+9} = [A_c{i+8,j+8,k+9};[A(x,:)]];
                end
            end
        end
    end
end

[max_val, position] = max(count(:));
[ii,jj,kk] = ind2sub(size(count),position);

Xrange = mean(A_c{ii,jj,kk});

x1_ = zeros(size(x1));
y1_ = zeros(size(y1));
theta2_ = theta2 + Xrange(3);

%transformation of image 2

for i = 1:length(x2)
    x2_(i,1) = Xrange(1) + x2(i,1)*cosd(Xrange(3)) + y2(i,1)*sind(Xrange(3));
    y2_(i,1) = Xrange(2) - x2(i,1)*sind(Xrange(3)) + y2(i,1)*cosd(Xrange(3));
end

% pairing

pairing = 0;
list = [];

for i = 1:length(x1_)
    for j = 1:length(x2)
        if sqrt((x1(i,1)-x2_(j,1))^2 + (y1(i,1)-y2_(j,1))^2)<12 && abs(theta1(i,1)-theta2_(j,1))<12
            if sqrt((x1(i,1)-x2_(j,1))^2 + (y1(i,1)-y2_(j,1))^2)<12 && abs(theta1(i,1)-theta2_(j,1))<12
                y2_(j,1) = 0;
                x2_(j,1) = 0;
                theta2_(j,1) = 0;     %once the point in image 1 and 2 matches, remove that point in image 2
            end
            pairing = pairing + 1;
            list=[list;[i,j]];
            
        end
    end
end








