function color = chip_decision( center , r ,last_center, centers,radii ,boardborder, real_table)
%CHIP_DECISION Summary of this function goes here
%   Detailed explanation goes here
    
    [approx, r ]=get_approx_chip(center,last_center,centers,radii);
    [red_app , green_app , blue_app ]= get_chip_colors([approx(1,1) , approx(1,2)] , r , boardborder,real_table);
    [red , green , blue ]= get_chip_colors([center(1,1) , center(1,2)] , r , boardborder,real_table);
    
    %red-green:
    if(red>=0.05 && green>=0.05 && red_app<=0.05 && green_app>=0.05  )
        color=1;
        return
    end
    if(red>=0.05 && green>=0.05 && red_app>=0.05 && green_app<=0.05  )
        color=2;
        return
    end
    
    %red-blue:
    if(red>=0.05 && blue>=0.05 && red_app<=0.05 && blue_app>=0.05  )
        color=1;
        return
    end
    if(red>=0.05 && blue>=0.05 && red_app>=0.05 && blue_app<=0.05  )
        color=3;
        return
    end
    
    %blue-green
    if(blue>=0.05 && green>=0.05 && blue<=0.05 && green_app>=0.05  )
        color=3;
        return
    end
    if(blue>=0.05 && green>=0.05 && blue>=0.05 && green_app<=0.05  )
        color=2;
        return
    end
    
    
    
    color = chip_decision( approx , r ,center, centers,radii,boardborder, real_table);
    
    
    
end

