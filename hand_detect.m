function  hand  = hand_detect( board )
debug=0;
%BW is 250*375*3 (RGB)
I = rgb2hsv(board);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.903;
channel1Max = 0.091;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.202;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.223;
channel3Max = 1.000;

% Create mask based on chosen histogram thresholds
sliderBW = ( (I(:,:,1) >= channel1Min) | (I(:,:,1) <= channel1Max) ) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;
if debug ==1
figure()
    imshow(BW)
    title('1')
BW=bwareaopen(BW,50);
figure()
    imshow(BW)
    title('2')
BW= medfilt2(BW,[9 9]);
figure()
    imshow(BW)
    title('3')
    figure()
    imshow(BW)
    figure()
    imshow(board)
end
color=0;
rows_in_row=0;
last_row= -1;
hand = 0;
for i=125:250
    fingers=0;
    for j=190:375
        if (BW(i,j)~=color)
            fingers = fingers +1;
            color = 1- color;
        end
    end 
    if(fingers >= 6 && (last_row==-1 || last_row == i-1))
        rows_in_row=rows_in_row +1;
        last_row = i;
        if (rows_in_row == 15)
            hand = 1;
            break;
        end
    else
        last_row = -1;
        rows_in_row = 0;
    end
end 
end

