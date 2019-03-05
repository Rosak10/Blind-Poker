function Hand = playerhand(fold,cards)
j=1;
for i = 1 : 4 
    if ~fold(1,i)
        Hand (1,j)= cards(i,1);
        Hand (2,j)= cards(i,2);
        j=j+1;
    end
end
end

