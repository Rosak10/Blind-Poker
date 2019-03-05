function [ red ,green, blue ] = get_chip_colors(center ,r ,boardborder,real_table)
%GET_CHIP_COLORS Summary of this function goes here
%   Detailed explanation goes here
upper_light=1;
WIDTH=1280;
HEIGHT=720;

%-------------------------------------------------------------------------   
%--------------------------Color threshold--------------------------------    
I = rgb2hsv(real_table);
if upper_light==0
    channel1Min = 0.581;
    channel1Max = 0.658;

    channel2Min = 0.311;
    channel2Max = 1.000;

    channel3Min = 0.257;
    channel3Max = 0.519;
else
% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.566;
channel1Max = 0.705;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.275;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.133;
channel3Max = 1.000;
end

sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW_blue = sliderBW;

if upper_light==0
    channel1Min = 0.388;
    channel1Max = 0.505;

    channel2Min = 0.202;
    channel2Max = 0.880;

    channel3Min = 0.213;
    channel3Max = 0.601;
else
channel1Min = 0.255;
channel1Max = 0.444;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.193;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.133;
channel3Max = 1.000;  
end
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW_green = sliderBW;    

if upper_light==0
    channel1Min = 0.950;
    channel1Max = 0.009;

    channel2Min = 0.377;
    channel2Max = 1.000;

    channel3Min = 0.301;
    channel3Max = 0.727;
else
% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.903;
channel1Max = 0.091;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.202;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.223;
channel3Max = 1.000;
end

sliderBW = ( (I(:,:,1) >= channel1Min) | (I(:,:,1) <= channel1Max) ) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW_red = sliderBW;    
    


%-------------------------------------------------------------------------
red= 0;
green=0;
blue=0;
x= center(1,1);
y= center(1,2);
area=0;
if ( is_pixel_inside(center(1,1),center(1,2),boardborder)==0)
    for n= floor(x-r) : floor(x+r)
        for m= floor(y-r) : floor(y+r) 

                if (n<1 || n> WIDTH || m<1 || m>HEIGHT)
                    continue
                end
                dis= sqrt( power(n-x,2) +power(m-y,2));
                if (dis<=r)
                    red=red + BW_red(m,n);
                    green=green + BW_green(m,n);
                    blue=blue + BW_blue(m,n);
                    area = area + 1;

                end
         end
     end
end
red = red / area;
green = green / area;
blue = blue / area;
end

