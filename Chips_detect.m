function [ dealer_pos,sum ] = Chips_detect( real_table,boardborder )
%CHIPS_DETECT will find all the chips and dealer.
%   Detailed explanation goes here
    gray_table = double(rgb2gray(real_table));
    gray_table = (gray_table-min(gray_table(:)))/(max(gray_table(:))-min(gray_table(:)));
    WIDTH=1280;
    HEIGHT=720;
    debug = 1;
    [centers,radii] = imfindcircles(real_table,[18 22],'ObjectPolarity','dark','Sensitivity',0.97,'EdgeThreshold',0.1);
    %[centers1,radii1] = imfindcircles(gray_table,[18 22],'ObjectPolarity','bright','Sensitivity',0.95,'EdgeThreshold',0.1);
    

%-------------------------------------------------------------------------

    figure()
    if debug == 1
        imshow(real_table);
        hold on;
    end
    %viscircles(centers,radii,'EdgeColor','y','LineWidth',1);
    %viscircles(centers1,radii1,'EdgeColor','k','LineWidth',1);
    red_count=0;
    green_count=0;
    blue_count=0;
    fault_chip_detect=0;
    l=size(centers,1);
    for i= 1 : l
       %if (centers(i,1)>800)%%%%%%%
        %if length(centers)
        if  centers(is_pixel_inside(centers(i,1),centers(i,2),boardborder)==0)

            [red , green , blue]= get_chip_colors([centers(i,1) , centers(i,2)],radii(i),boardborder,real_table);

            if (red + green + blue< 0.4 )
                    fault_chip_detect=fault_chip_detect + 1;
            else
                
                %the classic scenarios:
                if (red > 0.4 && green <= 0.25 && blue <= 0.25)
                    if debug == 1
                        viscircles(centers(i,:),radii(i),'EdgeColor','r','LineWidth',1);
                    end
                    red_count= red_count + 1;
                end
                if (green > 0.4 && red <= 0.25 && blue <= 0.25)
                    if debug == 1
                        viscircles(centers(i,:),radii(i),'EdgeColor','g','LineWidth',1);
                    end
                    green_count= green_count + 1;
                end
                if (blue > 0.4 && red <= 0.25 && green <= 0.25)
                    if debug == 1
                        viscircles(centers(i,:),radii(i),'EdgeColor','b','LineWidth',1);
                    end
                        blue_count= blue_count + 1;
                end
                % hofef
                if ( (red >= 0.25 && blue >=0.25) || (green >= 0.25 && blue >=0.25) || (red >= 0.25 && green >=0.25))
                    
                    color=chip_decision( centers(i,:) , radii(i),[0,0], centers,radii,boardborder,real_table);         
                    
                    if (color==1)
                       if debug == 1
                            viscircles(centers(i,:),radii(i),'EdgeColor','r','LineWidth',1);
                       end 
                        red_count= red_count + 1; 
                    end
                    if (color==2)
                       if debug == 1
                            viscircles(centers(i,:),radii(i),'EdgeColor','g','LineWidth',1);
                       end
                            green_count= green_count + 1;
                    end
                    if (color==3)
                        if debug == 1
                            viscircles(centers(i,:),radii(i),'EdgeColor','b','LineWidth',1);
                        end
                        blue_count= blue_count + 1;
                    end
                end
            end
        end
      % end%%%%%%%%
    end
    sum = red_count + green_count*2 + blue_count*3;
    %viscircles(centers1,radii1,'EdgeColor','k','LineWidth',1);

    %------------------------------Dealer-----------------------------------------


    [centersDeal,radiiDeal] = imfindcircles(gray_table,[23 27],'ObjectPolarity','bright','Sensitivity',0.97,'EdgeThreshold',0.10);
    for i= 1 : size(centersDeal,1)
        viscircles(centersDeal(i,:),radiiDeal(i),'EdgeColor','k','LineWidth',1);
    end
    Dealer= [0 0];
    for i= 1 : size(centersDeal,1)
        white=0;
        area=0;
        x= centersDeal(i,1);
        y= centersDeal(i,2);
        r=radiiDeal(i);
        if ( is_pixel_inside(x,y,boardborder)==0)  
            
            for n= floor(x-r) : floor(x+r)
                for m= floor(y-r) : floor(y+r) 

                    if (n<1 || n> WIDTH || m<1 || m>HEIGHT)
                        continue
                    end
                    dis= sqrt( power(n-x,2) +power(m-y,2));
                    if (dis<=r)
                        white= white+gray_table(m,n);
                        area= area+1;
                    end
                end
            end
            white= white/area;
            if (white >= 0.25 && white <= 0.7 )
                Dealer= [x y];
                if debug == 1
                    viscircles(centersDeal(i,:),radiiDeal(i),'EdgeColor','y','LineWidth',1);
                end
            end
        end
    end
    middle_x= boardborder(3,1)+boardborder(3,3)/2;
    middle_y= boardborder(3,2)+boardborder(3,4)/2;
    if (Dealer(1)<= middle_x && Dealer(2)<=middle_y)
        dealer_pos=1;
    end
    if (Dealer(1)>= middle_x && Dealer(2)<=middle_y)
        dealer_pos=4;
    end
    if (Dealer(1)>= middle_x && Dealer(2)>=middle_y)
        dealer_pos=3;
    end
    if (Dealer(1)<= middle_x && Dealer(2)>=middle_y)
        dealer_pos=2;
    end
    if (Dealer(1)==0)
        dealer_pos=0;
    end
    
end