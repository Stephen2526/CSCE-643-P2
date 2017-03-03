function [ error, errvec ] = calError( H, pts1, pts2, type)
%CALERROR Summary of this function goes here
%   Detailed explanation goes here
% pts1, pts2-2*N
switch type
    case 'alg'
        [ error, errvec ] = algbDist(H,pts1,pts2);
    case 'syt'
        [ error, errvec ] = sytDist(H,pts1,pts2);
    case 'sam'
        [ error, errvec ] = sampErr(H,pts1,pts2);
    otherwise
        disp('unvalid error type');
end
end

function [d2, d2vec] = algbDist(H,pts1,pts2)
%	Project PTS1 to PTS3 using H, then calcultate the distances between
%	PTS2 and PTS3
n = size(pts1,2);
pts3 = H*[pts1;ones(1,n)];
pts3 = pts3(1:2,:)./repmat(pts3(3,:),2,1);
d2vec = sum((pts2-pts3).^2,1);
d2 = sum(d2vec);
end

function [d2, d2vec] = sytDist(H,pts1,pts2)
% Function to evaluate the symmetric transfer error of a homography with
% respect to a set of matched points as needed by RANSAC.
x1 = [pts1;ones(1,size(pts1,2))];
x2 = [pts2;ones(1,size(pts2,2))];
Hx1 = H*x1;
invHx2 = H\x2;

% make homogeneous scale to 1
x1 = hnormalise(x1);
x2 = hnormalise(x2);     
Hx1= hnormalise(Hx1);
invHx2 = hnormalise(invHx2); 
d2vec = sum((x1-invHx2).^2)  + sum((x2-Hx1).^2);   
d2 = sum(d2vec);
end

function [d2, d2vec] = sampErr(H, ptsA, ptsB)
% This is the user-defined function to express the objective function (Sampson error)
%Arguemnt
ptsA = [ptsA;ones(1,size(ptsA,2))];
ptsB = [ptsB;ones(1,size(ptsB,2))];
% denote elements in h
h11 = H(1,1);h12 = H(1,2);h13 = H(1,3);
h21 = H(2,1);h22 = H(2,2);h23 = H(2,3);
h31 = H(3,1);h32 = H(3,2);h33 = H(3,3);

err = zeros(size(ptsA,2),1);
for i = 1:size(ptsA,2)
   eps = [-ptsB(3,i)*(ptsA(1,i)*h21 + ptsA(2,i)*h22 + h23) + ptsB(2,i)*(ptsA(1,i)*h31 + ptsA(2,i)*h32 + h33);
          ptsB(3,i)*(ptsA(1,i)*h11 + ptsA(2,i)*h12 + h13) - ptsB(1,i)*(ptsA(1,i)*h31 + ptsA(2,i)*h32 + h33)];
   J = [-ptsB(3,i)*h21+ptsB(2,i)*h31 , -ptsB(3,i)*h22+ptsB(2,i)*h32 , 0 , ptsA(1,i)*h31+ptsA(2,i)*h32+h33;
        ptsB(3,i)*h11-ptsB(1,i)*h31 , -ptsB(3,i)*h12-ptsB(1,i)*h32 , -ptsA(1,i)*h31-ptsA(2,i)*h32-h33 , 0];
   err(i) = sqrt(eps'*inv(J*J')*eps);
end
% display('err:');
d2vec = err.^2;
d2 = err'*err;
end