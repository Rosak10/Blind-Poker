function num = card_detect( card )
%CARD_DETECT Summary of this function goes here
%   Detailed explanation goes here
num = 0;
sign = 0;
g=0;
b=0;
y=0;
debug = 0;
%-------------------------------Blue dots--------------------------
I = rgb2hsv(card);

channel1Min = 0.517;
channel1Max = 0.693;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.275;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.438;
channel3Max = 1.000;
% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;
if debug == 1
    figure()
    imshow(BW);
    hold on
end 
stats = regionprops(BW,'BoundingBox');
for k = 1 : length(stats)
      thisBB = stats(k).BoundingBox;
      thisBB= round(thisBB);
      if debug == 1
        rectangle('Position', thisBB, 'EdgeColor','r','LineWidth',2 );
      end
      if( thisBB(3)>=7 && thisBB(3)<20 && thisBB(4)>=7 && thisBB(4)<20 )
          dots(k,:)=thisBB;
          b=b+1;
          blueBB=thisBB;
      end
end
if b==7
    num = 10.1;  
    return;
end
if b==6
    num = 13.1;  
    return;
end
if b==4
    num = 12.1;
    return;
end
if b==3
    num = 14.3;
    return;
end
if b==2
    if blueBB(2) >= size(card,1)/3 && blueBB(2) <= size(card,1)/3
        num = 11.1;
        return;
    else
        sign = 1;
    end
end

%-------------------------------Green dots--------------------------
I = rgb2hsv(card);

channel1Min = 0.291;
channel1Max = 0.442;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.223;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.172;
channel3Max = 1.000;

% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;
if debug == 1
    figure()
    imshow(BW);
    hold on
end 
stats = regionprops(BW,'BoundingBox');
for k = 1 : length(stats)
      thisBB = stats(k).BoundingBox;
      thisBB= round(thisBB);    
      if debug == 1
        rectangle('Position', thisBB, 'EdgeColor','r','LineWidth',2 );
      end
      if( thisBB(3)>=7 && thisBB(3)<20 && thisBB(4)>=7 && thisBB(4)<20 )
          dots(k,:)=thisBB;
          g=g+1;
          greenBB=thisBB;
      end
end
if g==7
    num = 14.4;  
    return;
end
if g==6
    num = 13.4;  
    return;
end
if g==4
    num = 12.4;
    return;
end
if g==3
    num = 13.3;
    return;
end
if g==2
    if greenBB(1) <= size(card,1)/5 && greenBB(1) >= size(card,1)/3
        num = 11.4;
        return;
    elseif greenBB(1) >= size(card,2)/3 && greenBB(1) <= 2*size(card,2)/3 && greenBB(2) >= size(card,1)/5 && greenBB(2) <= 3*size(card,1)/4
        num = 12.3;
        return;
    else
        sign = 4;
    end
end
if g==1
    num = 11.3;
    return;
end
%-------------------------------Yellow dots--------------------------
I = rgb2hsv(card);
% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.111;
channel1Max = 0.198;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.494;
channel2Max = 0.878;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.468;
channel3Max = 1.000;
% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;
if debug == 1
    figure()
    imshow(BW);
    hold on
end 
stats = regionprops(BW,'BoundingBox');
for k = 1 : length(stats)
      thisBB = stats(k).BoundingBox;
      thisBB= round(thisBB); 
      if debug == 1
        rectangle('Position', thisBB, 'EdgeColor','r','LineWidth',2 );
      end 
      if( thisBB(3)>=7 && thisBB(3)<20 && thisBB(4)>=7 && thisBB(4)<20 )
          dots(k,:)=thisBB;
          y=y+1;
          yellowBB=thisBB;
      end
end
if y==6
    num = 13.2;  
    return;
end
if y==4
    num = 12.2;
    return;
end
if y==2   
    if yellowBB(2) >= size(card,1)/3 && yellowBB(2) <= size(card,1)/3
        num = 11.2;
        return;
    else
        sign = 2;
    end
end

if sign == 0
   sign = 3; 
end
%------------------------------Find num------------------------------------
gray = double(rgb2gray(card));
gray = (gray-min(gray(:)))/(max(gray(:))-min(gray(:)));
BW = imbinarize(gray);
if debug == 1
    figure()
    imshow(BW);
end 

edges = edge(BW,'Canny');
%edges = bwconvhull(edges,'objects');
if debug == 1
    figure();
    imshow(edges);
    hold on;
end
stats = regionprops(edges,'BoundingBox');
for k = 1 : length(stats)
  thisBB = stats(k).BoundingBox;
  thisBB= round(thisBB);
  if debug == 1
      rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
      'EdgeColor','r','LineWidth',2 );
  end 
  if (thisBB(1) >= size(card,2)/5 && thisBB(1) <= 2*size(card,2)/3) && (thisBB(2) >= size(card,1)/5 && thisBB(2) <= 3*size(card,1)/4) &&  thisBB(3) < 14 && thisBB(4) < 14
      num = num +1;
  end 
end
if num == 1 
    num = 14 + 0.1*sign;
elseif num == 0 
    num = 0;
else
    num = num + 0.1*sign;
end
end

