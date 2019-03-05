function everybodycalls = collectivecall(playerbet,fold)
everybodycalls=1;
    tempfold=1-fold;
    temp=tempfold.*playerbet;
    maxtemp= max(temp);
    for i=1:4
        if temp(i)~=0 && temp(i)~=maxtemp
            everybodycalls=0;
            return;
        end
    end
end
