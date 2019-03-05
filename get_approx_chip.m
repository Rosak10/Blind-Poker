function [approx, r ] = get_approx_chip( center,last_center,centers,radii)
%GET_APPROX_CHIP Summary of this function goes here
%   Detailed explanation goes here
    x=center(1);
    y=center(2);
    min_dis=700;
    approx=[ 0,0];
    for i=1 : size(centers,1)
        if (centers(i,1)~=last_center(1,1) && centers(i,2)~=last_center(1,2) )
            dis= sqrt( power(centers(i,1)-x,2) +power(centers(i,2)-y,2));
            if (dis < min_dis && dis~=0)
                min_dis=dis;
                approx= centers(i,:);
                r=radii(i);
            end
        end
    end
    
end

