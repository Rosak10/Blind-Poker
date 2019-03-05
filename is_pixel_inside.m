function inside = is_pixel_inside( x , y , boardsborder)

inside=0;
if( x>boardsborder(1,1) && x<boardsborder(1,1)+boardsborder(1,3) &&...
        y>boardsborder(1,2) && y<boardsborder(1,2)+boardsborder(1,4))
    inside=1;
end
if( x>boardsborder(2,1) && x<boardsborder(2,1)+boardsborder(2,3) &&...
        y>boardsborder(2,2) && y<boardsborder(2,2)+boardsborder(2,4))
    inside=1;
end
if( x>boardsborder(3,1) && x<boardsborder(3,1)+boardsborder(3,3) &&...
        y>boardsborder(3,2) && y<boardsborder(3,2)+boardsborder(3,4))
    inside=1;
end
if( x>boardsborder(4,1) && x<boardsborder(4,1)+boardsborder(4,3) &&...
        y>boardsborder(4,2) && y<boardsborder(4,2)+boardsborder(4,4))
    inside=1;
end
if( x>boardsborder(5,1) && x<boardsborder(5,1)+boardsborder(5,3) &&...
        y>boardsborder(5,2) && y<boardsborder(5,2)+boardsborder(5,4))
    inside=1;
end


end

