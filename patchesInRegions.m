
%% 02506 - Advanced Image Analysis
% Miniproject - Probabilistic Chan Vese
% This function finds the patches in the inside and outside region

function [patches_in, patches_out, Omega_in, Omega_out] = patchesInRegions(img,x,y,n)

[r,c] = size(img(:,:,1));
BW_in = poly2mask(x,y,r,c);  % Region inside circle
In_region = double(img).*double(BW_in);
Omega_in = sum(sum(double(BW_in)));
Out_region = double(img).*double(BW_in == 0);
Omega_out = sum(sum(double(BW_in == 0)));

% Find patches inside and outside the region 
% Inside region
IN1 = im2col(In_region(:,:,1),[n,n]);
IN2 = im2col(In_region(:,:,2),[n,n]);
IN3 = im2col(In_region(:,:,3),[n,n]);

IN = [IN1;IN2;IN3]';
mid_point = ceil(5^2/2);
vector = (IN(:,13) ~= 0); % Select those patches which are in the inside region
IN = IN(vector,:);

patches_in = IN;

% Outside region
OUT1 = im2col(Out_region(:,:,1),[n,n]);
OUT2 = im2col(Out_region(:,:,2),[n,n]);
OUT3 = im2col(Out_region(:,:,3),[n,n]);

OUT = [OUT1;OUT2;OUT3]';
vector = (vector ~= 1);
OUT = OUT(vector,:);

patches_out = OUT;
end