function [ output_args ] = stitch( Ic1, Ic2, H)
%STITCH Summary of this function goes here
%   Detailed explanation goes here

% obtain gray images
Ig1=im2double(rgb2gray(Ic1));
Ig2=im2double(rgb2gray(Ic2));

% H inverse Ig2->Ig1
Hinv = inv(H);
scale = 1/Hinv(3,3);
Hinv = Hinv*scale;

%% Compute the outer boardary of Image 2 onto Image 1
% size of image
[destinationx ,destinationy]=size(Ig1);
[sourcex ,sourcey]=size(Ig2);

sourceboundaypoints=[1 1 1;1 sourcey 1;sourcex 1 1;sourcex sourcey 1];

destinationboundry=Hinv*sourceboundaypoints';
% normalize points
for i=1:4
    scale=1/destinationboundry(3,i);
    destinationboundry(:,i)=destinationboundry(:,i)*scale;
end
destinationboundry=destinationboundry';
% Plot Corner points on Image 1
subplot(1,2,1)
imshow(Ic1);
subplot(1,2,2)
imshow(Ic2);
% Determine outer boundary of newimage 1
maxboundaryX=max(destinationboundry(:,1));
minboundaryX=min(destinationboundry(:,1));
maxboundaryY=max(destinationboundry(:,2));
minboundaryY=min(destinationboundry(:,2));
%Adjust the axis of image 1 to show the boundary of image 2
Xmin=min([minboundaryX destinationx 1]);
Xmax=max([maxboundaryX destinationx]);
Ymin=min([minboundaryY 1 destinationy]);
Ymax=max([maxboundaryY destinationy]);

subplot(1,2,1)
hold on
axis([Ymin Ymax Xmin Xmax])
scatter(destinationboundry(:,2),destinationboundry(:,1),'*','r');

% %% Warping of Image 2
% [Xsource, Ysource]=meshgrid(floor(Xmin):ceil(Xmax),floor(Ymin):ceil(Ymax));
% Xsourcevec=Xsource(:);
% Ysourcevec=Ysource(:);
% XY=[Xsourcevec Ysourcevec ones(length(Xsourcevec),1)];
% XpYp=H*XY';
% XpYp=XpYp';
% %Normalize Points
% normal=1./XpYp(:,3);
% XpYp(:,1)=normal.*XpYp(:,1);
% XpYp(:,2)=normal.*XpYp(:,2);
% XpYp(:,3)=normal.*XpYp(:,3);
% 
% Xp=reshape(XpYp(:,1),size(Xsource,1),size(Xsource,2))';
% Yp=reshape(XpYp(:,2),size(Xsource,1),size(Xsource,2))';
% 
% [sourcemeshX, sourcemeshY]=meshgrid(1:sourcey, 1:sourcex); %Source Image Initial Mesh (source)
% 
% Ic2r=im2double(Ic2(:,:,1));
% Ic2b=im2double(Ic2(:,:,2));
% Ic2g=im2double(Ic2(:,:,3));
% 
% warpedimagered=interp2(sourcemeshY',sourcemeshX',Ic2r',Xp,Yp); %Warp the Initial Source Mesh to the Transformed Mesh
% warpedimageblue=interp2(sourcemeshY',sourcemeshX',Ic2b',Xp,Yp);
% warpedimagegreen=interp2(sourcemeshY',sourcemeshX',Ic2g',Xp,Yp);
% 
% warpedimage(:,:,1)=warpedimagered;
% warpedimage(:,:,2)=warpedimageblue;
% warpedimage(:,:,3)=warpedimagegreen;
% 
% figure()
% imshow(warpedimage,[]);
% 
% %% Shift Destination Image to Bounding Box
% Ic1r=im2double(Ic1(:,:,1));
% Ic1b=im2double(Ic1(:,:,2));
% Ic1g=im2double(Ic1(:,:,3));
% 
% shift=zeros(abs(ceil(Xmin)),length(Ic1(1,:,:)));
% 
% Ic1r=[shift; Ic1r];
% Ic1b=[shift; Ic1b];
% Ic1g=[shift; Ic1g];
% 
% destinationimage(:,:,1)=Ic1r;
% destinationimage(:,:,2)=Ic1b;
% destinationimage(:,:,3)=Ic1g;
% 
% figure()
% imshow(destinationimage,[]);
% 
% newimage=imfuse(destinationimage,warpedimage,'blend','Scaling','none');
% figure()
% imshow(newimage,[]);
% 
% figure()
% imshow(warpedimage,[]);
% hold on;
% imshow(destinationimage,[]);
end

