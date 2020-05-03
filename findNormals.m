
%% Advanced Image Analysis - Week 6 
% Function that finds snake normals N from points C
% Input:    C - Matrix Nx2 of points 
% Output:   N - A matrix Nx2 of unit normals for each of the points 

function N = findNormals(C)

%{
[n,~] = size(C);
N = zeros(n,2);
N2 = zeros(n,2);

% Method 1 
for i = 2:n-1
    c_i_prev = C(i-1,:);
    c_i_next = C(i+1,:);
    v = c_i_next - c_i_prev;
    length = sqrt(v(1)^2 + v(2)^2);
    v = [-v(2),v(1)]';
    %v = v./norm(v,1);
    v = v./length;
    N(i,:) = v';
end 

% For the first point
c_i_prev = C(end,:);
c_i_next = C(2,:);
v = c_i_next - c_i_prev;
length = sqrt(v(1)^2 + v(2)^2);
v = [-v(2),v(1)]';
%v = v./norm(v,1);
v = v./length;
N(1,:) = v';

% For the last point
c_i_prev = C(end-1,:);
c_i_next = C(1,:);
v = c_i_next - c_i_prev;
length = sqrt(v(1)^2 + v(2)^2);
v = [-v(2),v(1)]';
%v = v./norm(v,1);
v = v./length;
N(end,:) = v';
%}

[n,~] = size(C);
N = zeros(n,2);

% Method 2
for i = 2:n-1
    c_i_prev = C(i-1,:);
    c_i_next = C(i+1,:);
    c_i_current = C(i,:);
    
    % Find vectors 
    v1 = c_i_current - c_i_prev;
    v2 = c_i_current - c_i_next;
    
    % Find tværvektor
    v1 = [-v1(2), v1(1)]';
    v2 = (-1)*[-v2(2), v2(1)]';
    
    % Average vectors
    v = (v1 + v2)./2;
    
    % Normalize
    length = sqrt(v(1)^2 + v(2)^2);
    v = v./length;
    N(i,:) = v';
end 

% For the first point
c_i_prev = C(end,:);
c_i_current = C(1,:);
c_i_next = C(2,:);

% Find vectors 
v1 = c_i_current - c_i_prev;
v2 = c_i_current - c_i_next;
    
% Find tværvektor
v1 = [-v1(2), v1(1)]';
v2 = (-1)*[-v2(2), v2(1)]';
    
% Average vectors
v = (v1 + v2)./2;
    
% Normalize
length = sqrt(v(1)^2 + v(2)^2);
v = v./length;
N(1,:) = v';

% For the last point
c_i_prev = C(end-1,:);
c_i_current = C(end,:);
c_i_next = C(1,:);

% Find vectors 
v1 = c_i_current - c_i_prev;
v2 = c_i_current - c_i_next;
    
% Find tværvektor
v1 = [-v1(2), v1(1)]';
v2 = (-1)*[-v2(2), v2(1)]';
    
% Average vectors
v = (v1 + v2)./2;
    
% Normalize
length = sqrt(v(1)^2 + v(2)^2);
v = v./length;
N(end,:) = v';


end