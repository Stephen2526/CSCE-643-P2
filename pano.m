clc;clear;close all;
%% initialize 20 pairs of points
% Input Images
imgA = imread('a_points.jpg');
imgB = imread('b_points.jpg');
% obtain gray images
igA=im2double(rgb2gray(imgA));
igB=im2double(rgb2gray(imgB));

% load manually picked points
pntsManA = [1992, 2082, 2086, 2090, 2098, 2155, 2254, 2261, 2161, 2280, 2175, 2336, 2446, 2456, 2345, 2351, 2463, 2472, 2484, 2366; 
            654,  636,  815,  941,  1382, 620,  598,  787,  803,  1385, 1385, 582,  558,  756,  773,  910,  896,  1102, 1389, 1388; 
            1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1    ];
pntsManB = [14, 116, 100, 89,  56,   195, 298, 285, 181, 248,  139,  380, 487, 475, 369, 359, 467, 458,  445,  333; 
            620,615, 800, 933, 1395, 610, 605, 794, 797, 1395, 1396, 601, 597, 786, 792, 926, 923, 1120, 1397, 1398; 
            1,  1,   1,   1,   1,    1,   1,   1,   1,   1,    1,    1,   1,   1,   1,   1,   1,   1,    1,    1   ];

% live pick points

%% DLT to calculate H: A->B
% H = DLT(pntsManA, pntsManB);
% % normalize H
% scale1 = 1/H(3,3);
% H = H*scale1;
% H
%% Normalized DLT
% [norPtsA, TA] = normalise2dpts(pntsManA);
% [norPtsB, TB] = normalise2dpts(pntsManB);
% norH = DLT(norPtsA, norPtsB);
% H = TB\norH*TA;
% norH
% TA
% TB
% scale1 = 1/H(3,3);
% H = H*scale1;
% H
%% MLE
H = MLE(pntsManA, pntsManB);
scale1 = 1/H(3,3);
H = H*scale1;
H

%% calculate error
algErr = calError(H,pntsManA(1:2,:),pntsManB(1:2,:),'alg')
sytErr = calError(H,pntsManA(1:2,:),pntsManB(1:2,:),'syt')
samErr = calError(H,pntsManA(1:2,:),pntsManB(1:2,:),'sam')

%% warp image
% % Transpose homography matrix
% H_transposed = transpose(H);
% 
% % Create form for projective 2D transformation
% tform = projective2d(H_transposed);
% 
% % Warp input image
% [recImgA, RrecImgA] = imwarp(imgA, tform);
% % show image
% figure(1), imshow(recImgA,RrecImgA);
% %imwrite(recImgA, 'MLE_recImgA_marked.jpg');
% %% build a panorama
% RimgB = imref2d(size(imgB));
% %RimgB.XWorldLimits = RimgB.XWorldLimits+RrecImgA.XWorldLimits;
% %RimgB.YWorldLimits = RimgB.YWorldLimits+RrecImgA.YWorldLimits;
% [panoImg, Rpano] = stitchPano(recImgA, RrecImgA, imgB, RimgB);
% %[panoImg, Rpano] = imfuse(recImgA, RrecImgA, imgB, RimgB, 'blend','Scaling','none');
% 
% % show image
% figure(2), imshow(panoImg,Rpano);
% %stitch(imgA, imgB, H);
% 
% %imwrite(panoImg, 'MLE_panoImg_marked.jpg');