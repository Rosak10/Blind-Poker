function updatechancesgui(fold,data,chances)
j=1;
for i=1:4
    if ~fold(1,i)
        playerchance(i,chances(j,1),data);
        j=j+1;
    else
        playerchance(i,0,data);
    end               
end
end

