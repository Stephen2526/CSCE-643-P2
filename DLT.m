function [H] = DLT(arrS, arrT)
%DLT Summary of this function goes here
%   Detailed explanation goes here

%construct A matrix
A = [];
for i = 1:size(arrS,2)
    % For each point, build matrix for its two equations
    current = [-arrS(1,i) -arrS(2,i) -1 0 0 0 (arrS(1,i) * arrT(1,i)) (arrS(2,i) * arrT(1,i)) arrT(1,i);
              0 0 0 -arrS(1,i) -arrS(2,i) -1 (arrS(1,i) * arrT(2,i)) (arrS(2,i) * arrT(2,i)) arrT(2,i)];
    
    % Concatenate the equations to one matrix
    A = [A; current];
end

%find null space of A to solve h
[U,S,V] = svd(A);
h = V(:,end);
%display('A*h = '); A*h

% Respape h to 3 by 3 homography matrix
H = reshape(h, 3, 3).';
% make H(3,3) =1
H = H/H(end);
end

