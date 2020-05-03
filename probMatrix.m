
%% 02506 Advanced Image Analysis F20
% Miniproject - Probablistic Chan Vese 
% This function generates the probability matrix with probabilities 
% inside 

function output = probMatrix(K,C,IN,OUT)

% Column 1 is the inside region and Column 2 is the outside region
Prob_matrix = zeros(K,2);
Idx_in = knnsearch(C,IN);
Idx_out = knnsearch(C,OUT);
for i = 1:K
    N_in = sum(Idx_in == i);
    N_out = sum(Idx_out == i);
    
    if (N_in ~= 0 && N_out ~= 0)
        Prob_matrix(i,1) = N_in /(N_in + N_out);
        Prob_matrix(i,2) = N_out / (N_in + N_out);
    else
        Prob_matrix(i,1) = 0;
        Prob_matrix(i,2) = 0;
    end
    
    if (Prob_matrix(i,1) == 1 || Prob_matrix(i,1) == 0)
       if (Prob_matrix(i,1) == 1)
           Prob_matrix(i,1) = 0.95;
           Prob_matrix(i,2) = 0.05;
       else
           Prob_matrix(i,1) = 0.05;
           Prob_matrix(i,2) = 0.95;
       end
    end
    
end
output = Prob_matrix;
end