
%% 02506 - Advanced Image Analysis F20
% Miniproject - Week 11, 12 and 13
% Probabilistic Chan-Vese 

clear; close all;

% Load Leopard image
img = imread('134052.jpg');
figure, imagesc(img), axis image, title('Leopard Image');

N = 10000;   % Number of samples - Maybe you need more samples  
K = 200;    % Number of clusters
n = 5;      % Patch size 

% Find patches in 3D Volume
M1 = im2col(img(:,:,1),[n,n]);
M2 = im2col(img(:,:,2),[n,n]);
M3 = im2col(img(:,:,3),[n,n]);
B = [M1; M2; M3]';                   % Puts all these patches together

%% Snake Curve 
% We initialize a snake curve 
step = 0.01;    
r = 70;
x0 = 150;
y0 = 150;
t = [0 : step: 2*pi-step]';
x = r * cos(t) + x0;
y = r * sin(t) + y0; 

hold on;
plot(y,x,'r-','Linewidth',2);

%% Find samples
B = double(B);
[n_rows,~] = size(B);

% Pick random samples
rand_samp = randsample(n_rows,N,false); 

extract_patches = B(rand_samp,:);
% Cluster Patches
X = extract_patches;
[IDX, C] = kmeans(X,K);


%% Probability 
% Inside region and outside region 
%{
[r,c] = size(img(:,:,1));
BW_in = poly2mask(x,y,r,c);  % Region inside circle
In_region = double(img).*double(BW_in);
Out_region = double(img).*double(BW_in == 0);

% Find patches inside and outside the region 
IN1 = im2col(In_region(:,:,1),[n,n]);
IN2 = im2col(In_region(:,:,2),[n,n]);
IN3 = im2col(In_region(:,:,3),[n,n]);

IN = [IN1;IN2;IN3]';
mid_point = ceil(5^2/2);
vector = (IN(:,13) ~= 0); % Select those patches which are in the inside region
IN = IN(vector,:);

OUT1 = im2col(Out_region(:,:,1),[n,n]);
OUT2 = im2col(Out_region(:,:,2),[n,n]);
OUT3 = im2col(Out_region(:,:,3),[n,n]);

OUT = [OUT1;OUT2;OUT3]';
vector = (vector ~= 1);
OUT = OUT(vector,:);
%}

[IN,OUT,Omega_in,Omega_out] = patchesInRegions(img,x,y,n);

%% Generate Probability matrix

Prob_matrix = probMatrix(K,C,IN,OUT);

%% Generate probability image 

[r,c] = size(img(:,:,1));
Prob_img = rgb2gray(img);
new_img = img;

Idx_img = knnsearch(C,B);
index = 1;
for i = 3:c-2
    for j = 3:r-2
        if (Prob_matrix(Idx_img(index),1) > Prob_matrix(Idx_img(index),2))
            Prob_img(j,i) = 255;
            new_img(j,i,1) = 255;
            new_img(j,i,2:3) = 0;
        else
            Prob_img(j,i) = 0;
        end
        index = index + 1;
    end
end

figure, imagesc(new_img), axis image, title('Leopard Image');

%% Deform the curve

C_new = [x,y];
tau = 2; % 2
alpha = 2; % 0.2
beta = 10;
lambda = 1; 

for k = 1:300
C_prev = C_new;

if (k > 100)
    tau = 3;
end
    
N_prev = -findNormals(C_prev);

% Use bilinear interpolation to find the image indicies of the points x and
% y
x_round = round(C_prev(:,1));
y_round = round(C_prev(:,2));
indicies = sub2ind([r-4,c-4],y_round -2 ,x_round -2 ); % Subtract offset
cluster_nr = Idx_img(indicies);

% f_ext = Prob_matrix(cluster_nr,1) - Prob_matrix(cluster_nr,2);
% new f_ext
f_ext = log( (Omega_out/Omega_in) * ...
    (Prob_matrix(cluster_nr,1)./Prob_matrix(cluster_nr,2)));


%figure, imagesc(img), axis image, title('Leopard Image');
%hold on;
v = tau * diag(f_ext) * N_prev;
%quiver(C_prev(:,1),C_prev(:,2),v(:,1),v(:,2),'g');
%plot(C_new(:,1),C_new(:,2),'r-','Linewidth',1)

X = (C_prev + tau * diag(f_ext) * N_prev);
C_new = smoothing(X,alpha,beta,lambda);
C_new = remove_intersections(C_new);
C_new = distribute_points(C_new);

%hold on;
%plot(C_new(:,1),C_new(:,2),'b-','Linewidth',1)

[IN,OUT,Omega_in,Omega_out] = patchesInRegions(img,C_new(:,1),C_new(:,2),n);
Prob_matrix = probMatrix(K,C,IN,OUT);

if (k == 20 || k == 40 || k == 60 || k == 90 || k == 120 || k == 140)
    figure, imagesc(img), axis image, title('Leopard Image');
    hold on;
    plot(C_new(:,1),C_new(:,2),'r-','Linewidth',1)
end

end


figure, imagesc(img), axis image, title('Leopard Image');
hold on;
plot(C_new(:,1),C_new(:,2),'r-','Linewidth',1)


































































