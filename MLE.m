function [ minH ] = MLE( ptsA, ptsB )
% format shortEng
% format compact
%MLE Summary of this function goes here
%   Detailed explanation goes here
%% Initialization
% normalized DLT using four pairs of points
%colidx = [2,3,12,15];
%colidx = [5,9,15,18];
colidx = [2,5,13,19];
[norPtsA, TA] = normalise2dpts(ptsA(:, colidx));
[norPtsB, TB] = normalise2dpts(ptsB(:, colidx));
norH = DLT(norPtsA, norPtsB);
H = TB\norH*TA;
scale1 = 1/H(3,3);
H0 = H*scale1;
H0
Ht = H';
h0 = Ht(:);
%% Geometric minimization of Sampson error
% % make the third coord 1
% worPtsA(1,:) = ptsA(1,:)./ptsA(3,:);
% worPtsA(2,:) = ptsA(2,:)./ptsA(3,:);
% worPtsB(1,:) = ptsB(1,:)./ptsB(3,:);
% worPtsB(2,:) = ptsB(2,:)./ptsB(3,:);

% % resize the matrix of points to a column vector
% worPtsA = worPtsA(:);
% worPtsB = worPtsB(:);

% mininization process
options = optimoptions('lsqnonlin','FiniteDifferenceType','central','Display','iter-detailed');
%options.StepTolerance = 1.000000e-08;
minh = lsqnonlin(@funSamp,h0,[],[],options, ptsA, ptsB);
minH = [minh(1),minh(2),minh(3);minh(4),minh(5),minh(6);minh(7),minh(8),minh(9)]; 
end

function [ err ] = funSamp(h, ptsA, ptsB)
% This is the user-defined function to express the objective function (Sampson error)
%Arguemnt
% denote elements in h
h11 = h(1);h12 = h(2);h13 = h(3);
h21 = h(4);h22 = h(5);h23 = h(6);
h31 = h(7);h32 = h(8);h33 = h(9);

err = zeros(size(ptsA,2),1);
for i = 1:size(ptsA,2)
   eps = [-ptsB(3,i)*(ptsA(1,i)*h21 + ptsA(2,i)*h22 + h23) + ptsB(2,i)*(ptsA(1,i)*h31 + ptsA(2,i)*h32 + h33);
          ptsB(3,i)*(ptsA(1,i)*h11 + ptsA(2,i)*h12 + h13) - ptsB(1,i)*(ptsA(1,i)*h31 + ptsA(2,i)*h32 + h33)];
   J = [-ptsB(3,i)*h21+ptsB(2,i)*h31 , -ptsB(3,i)*h22+ptsB(2,i)*h32 , 0 , ptsA(1,i)*h31+ptsA(2,i)*h32+h33;
        ptsB(3,i)*h11-ptsB(1,i)*h31 , -ptsB(3,i)*h12-ptsB(1,i)*h32 , -ptsA(1,i)*h31-ptsA(2,i)*h32-h33 , 0];
   err(i) = sqrt(eps'*inv(J*J')*eps);
end
% display('err:');
% err'*err
end