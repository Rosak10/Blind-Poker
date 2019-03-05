function [ WinProb ] = CardAnalyze( Hand, Table, nPlayers, nIter )
%% Licence Information
%  
%  Author    : Oliver Rice
%  Employer  : University College London
%  Title     : PhD Candidate Financial Computing
%  Date      : May 5, 2012

%  Licence   : Free for academic use only

%% Instructions/Explanation/Example
%
% This function estimates the probability of each player winning
% a Round of Texas Holdem
% Hand     = Matrix of Known Cards (KnownPlayers X 2)
% Table    = An Array of Cards Presently on the Table
% nPlayers = Total Number of Players Sitting at the Table
% nIter    = Number of Monte Carlo Iters to Estimate Probabilities

% Each Card is designated by the whole number (e.g. 5.2 = 5)
% The suit of each card is represented by the decimal (e.g. 8.1 = .1)

% When size(Hand,2)==nPlayers the function assumes perfect information
%   meaning true probabilities are estimated
%
% To estimate the probability of an individual winning under normal
%   circumstances, 'Hand' is a 2 x 1 matrix of the individual's cards
%
% To estimate probability of an individual winning when nCollude players
% are colluding, 'Hand' is a 2 x nCollude matrix of the colluder's cards
%
% Example Inputs
% Hand     = [2.3, 14.3, 11.4, 9.3; 11.1, 10.1, 13.1, 10.2];
% Table    = [9.1, 6.3, 5.2];
% nPlayers = 6;
% nIter    = 8000;
%
% Yields P(Win) for each player when 3 players' cards are known
% (i.e. colluding) against an additional 3 unknown players with 3 cards on
% the table.

%%--------------PRE-PROCESSING-------------------------------------------
%% Calculate Which Cards Have Not Been Used
% Create a Deck of Cards
%   Whole number = Card Number
%   Decimal      = Card Suit
Cards = 2:.1:15;
Cards(mod(Cards,1)>.41 | mod(Cards,1)<.09)=[];

% Find Used Cards
UsedCards = horzcat(reshape(Hand,1,size(Hand,1)*size(Hand,2)), Table);

% Calculate Remaining Cards by Removing Used Cards from Full Deck
Remaining = Cards;
Remaining(ismember(Remaining,UsedCards))=[];
clear UsedCards Cards

%% Generate Samples from Remaining Cards to Estimate Probabilities
%Create Function to Randomly Sample from Remaining Cards
% Randomly Select Pocket Cards For Unknown Players & Table Cards for All
PermutRemain = zeros(nIter,(5)+2*(nPlayers-size(Hand,2)));
parfor i = 1:nIter
    PermutRemain(i,:) = randsample(Remaining,(5)+2*(nPlayers-size(Hand,2)));
end
clear SampleRandomly Remaining
%% Generate Cards Available to Known Players for Each Iteration
% Pre-allocate size for efficiency
PlayerHands = zeros(nPlayers,nIter,7);
for i = 1:size(Hand,2)
    PlayerHands(i,1:nIter,1:2)=repmat(transpose(Hand(:,i)),nIter,1);
    PlayerHands(i,1:nIter,3:7)=reshape(PermutRemain(:,end-4:end),...
        1,nIter,5);
    if ~isempty(Table)
        PlayerHands(i,1:nIter,3:3+length(Table)-1)=...
            repmat(Table,nIter,1);
    end
end

%% Generate Cards Available to Unknown Players for Each Iteration
% Pre-allocate size for efficiency
UnknownPlayerHands = zeros(nPlayers-size(Hand,2),nIter,7);
if size(Hand,2)<nPlayers
    for i = 1:nPlayers-size(Hand,2)
        UnknownPlayerHands(i,1:nIter,1:2) = ...
            reshape(PermutRemain(:,i*2-1:i*2),1,nIter,2);
        UnknownPlayerHands(i,1:nIter,3:7) = ...
            reshape(PermutRemain(:,end-4:end),1,nIter,5);
        if ~isempty(Table)
            UnknownPlayerHands(i,1:nIter,3:3+length(Table)-1)=...
                repmat(Table,nIter,1);
        end
    end
end

%% Concatenate Known and Unknown Player's Cards to Single Matrix
PlayerHands(size(Hand,2)+1:nPlayers,:,:)=...
    UnknownPlayerHands(:,:,:);
clear UnknownPlayerHands PermutRemain
%----------END-PRE-PROCESSING-------------------------------------------

%----------HAND-EVALUATION-LOGIC----------------------------------------

% Used Later to Calcualte Straights
Straight = horzcat(11:14, 2:14);

for i = 1:size(PlayerHands,1)
    
    % Create Matrix to Hold Best Possible Hand
    BestHand = zeros(nIter, 6); 
    
    % Reduce Dimension of Player Hands for Ease of Use
    CurrentPlayerHand=reshape(PlayerHands(i,:,:),nIter,7);   
        
    % Find Any Multiples of A Card Number
    FreqMatrix = histc(CurrentPlayerHand,.5:1:15,2);
    
    % Logical Matrix for Each Frequency
    oKind4 = FreqMatrix==4;
    oKind3 = FreqMatrix==3;
    oKind2 = FreqMatrix==2; 
    oKind1 = FreqMatrix==1;
    
    % Since the Max Function Returns the First Value of a Given Max Freq
    % The FreqMatrix is flipped left to right to make sure the highest
    % Card value for the given max frequency is returned
    
    % Calculate High Card
    Index = sum(oKind1>0,2)==7;
    if sum(Index)>=1
        [~,Loc]=max(fliplr(FreqMatrix(Index,:)==1),[],2); % Find 2ofK
        Loc = size(FreqMatrix,2)-Loc+1; % Get Card Number 
        BestHand(Index,1)=1; % High Card Index
        BestHand(Index,2)=Loc; % Card Number
        FreqMatrixW=FreqMatrix(Index,:); % Working Copy
        for j = 1:length(Loc) % Cant figure out how to get rid of this
            FreqMatrixW(j,Loc(j))=0;
        end
        clear Loc
        [~,Loc] = max(fliplr(FreqMatrixW==1),[],2);
        Loc = size(FreqMatrix,2)-Loc+1; % Get Card Number
        BestHand(Index,3)=Loc; % Card Num of 2nd Highest Remaining Card 
        for j = 1:length(Loc) % Cant figure out how to get rid of this
            FreqMatrixW(j,Loc(j))=0;
        end
        clear Loc
        [~,Loc] = max(fliplr(FreqMatrixW==1),[],2);
        Loc = size(FreqMatrix,2)-Loc+1; % Get Card Number
        BestHand(Index,4)=Loc; % Card Num of 2nd Highest Remaining Card
        for j = 1:length(Loc) % Cant figure out how to get rid of this
            FreqMatrixW(j,Loc(j))=0;
        end
        clear Loc
        [~,Loc] = max(fliplr(FreqMatrixW==1),[],2);
        Loc = size(FreqMatrix,2)-Loc+1; % Get Card Number
        BestHand(Index,5)=Loc; % Card Num of 2nd Highest Remaining Card
        for j = 1:length(Loc) % Cant figure out how to get rid of this
            FreqMatrixW(j,Loc(j))=0;
        end
        clear Loc
        [~,Loc] = max(fliplr(FreqMatrixW==1),[],2);
        Loc = size(FreqMatrix,2)-Loc+1; % Get Card Number
        BestHand(Index,6)=Loc; % Card Num of 2nd Highest Remaining Card
        clear Loc FreqMatrixW
    end
    clear Index  
    
    % Calculate Pair
    Index = sum(oKind2>0,2)==1 & sum(oKind3>0,2)==0 & sum(oKind4>0,2)==0;
    if sum(Index)>=1
        [~,Loc]=max(fliplr(FreqMatrix(Index,:)==2),[],2); % Find 2ofK
        Loc = size(FreqMatrix,2)-Loc+1; % Get Card Number 
        BestHand(Index,1)=2; % Pair Index
        BestHand(Index,2)=Loc; % Card Number
        clear Loc
        FreqMatrixW=FreqMatrix(Index,:); % Working Copy
        [~,Loc] = max(fliplr(FreqMatrixW==1),[],2);
        Loc = size(FreqMatrix,2)-Loc+1; % Get Card Number
        BestHand(Index,3)=Loc; % Card Num of Highest Remaining Card
        for j = 1:length(Loc) % Cant figure out how to get rid of this
            FreqMatrixW(j,Loc(j))=0;
        end
        clear Loc
        [~,Loc] = max(fliplr(FreqMatrixW==1),[],2);
        Loc = size(FreqMatrix,2)-Loc+1; % Get Card Number
        BestHand(Index,4)=Loc; % Card Num of 2nd Highest Remaining Card
        for j = 1:length(Loc) % Cant figure out how to get rid of this
            FreqMatrixW(j,Loc(j))=0;
        end
        clear Loc
        [~,Loc] = max(fliplr(FreqMatrixW==1),[],2);
        Loc = size(FreqMatrix,2)-Loc+1; % Get Card Number
        BestHand(Index,4)=Loc; % Card Num of Last Remaining Card
        BestHand(Index,5:6)=0;
        clear Loc FreqMatrixW
    end
    clear Index
    
    
    
    % Calculate 2 Pair
    Index = sum(oKind2>0,2)>=2 & sum(oKind3>0,2)==0 & sum(oKind4>0,2)==0;
    if sum(Index)>=1
        [~,Loc]=max(fliplr(FreqMatrix(Index,:)==2),[],2); % Find Best 2ofK
        Loc = size(FreqMatrix,2)-Loc+1; % Get Card Number 
        BestHand(Index,1)=3; % 2 Pair Index
        BestHand(Index,2)=Loc; % Card Number
        FreqMatrixW=FreqMatrix(Index,:); % Working Copy
        FreqMatrixW(FreqMatrixW==3)=0; % Ensure Max Card Isn't 2oK Card
        for j = 1:length(Loc) % Cant figure out how to get rid of this
            FreqMatrixW(j,Loc(j))=0;
        end
        clear Loc
        [~,Loc] = max(fliplr(FreqMatrixW==2),[],2);
        Loc = size(FreqMatrix,2)-Loc+1; % Get Card Number
        BestHand(Index,3)=Loc; % Card Num 2nd Highest Pair
        clear Loc
        [~,Loc] = max(fliplr(FreqMatrixW==1),[],2);
        Loc = size(FreqMatrix,2)-Loc+1; % Get Card Number
        BestHand(Index,4)=Loc; % Card Num of Remaining Card
        BestHand(Index,5:6)=0;
        clear Loc FreqMatrixW
    end
    clear Index
    
    % Calculate Straights
    for j = 1:13
        Index = sum(FreqMatrix(:,Straight(j:j+4))>0,2)==5;
        if sum(Index)>=1
            BestHand(Index,1)= 5; % Straight Index
            BestHand(Index,2)= Straight(j+4); % Highest Card In Straight
            BestHand(Index,3:6)=0;
        end
        clear Index
    end    
    clear j
    
    % Calculate Flush
    SuitFreq = histc(mod(CurrentPlayerHand,1),...
        .05:.1:.45,2); % Find Frequencies of Each Suit
    for j = 1:4
        Index = sum(SuitFreq(:,j),2)>=5;
        if sum(Index)>=1
            CPH = CurrentPlayerHand; % Working Copy
            CPH(round(mod(CPH,1)*10)~=j)=0; % Ignore Other Suits
            FreqMatrixBySuit = histc(CPH,.5:1:15,2); % New FreqMat by Suit
                        
            BestHand(Index,1)= 6; % Flush Index
            [~,Loc]=max(fliplr(FreqMatrixBySuit(Index,:)>0),[],2);
            Loc = size(FreqMatrix,2)-Loc+1; % Get Card Number
            BestHand(Index,2)=Loc; % Card Num Highest
            for k = 1:length(Loc) % Cant figure out how to get rid of this
                FreqMatrixBySuit(k,Loc(k))=0;
            end
            clear Loc
            [~,Loc]=max(fliplr(FreqMatrixBySuit(Index,:)>0),[],2);
            Loc = size(FreqMatrix,2)-Loc+1; % Get Card Number
            BestHand(Index,3)=Loc; % Card Num Highest
            for k = 1:length(Loc) % Cant figure out how to get rid of this
                FreqMatrixBySuit(k,Loc(k))=0;
            end
            clear Loc            
            [~,Loc]=max(fliplr(FreqMatrixBySuit(Index,:)>0),[],2);
            Loc = size(FreqMatrix,2)-Loc+1; % Get Card Number
            BestHand(Index,4)=Loc; % Card Num Highest
            for k = 1:length(Loc) % Cant figure out how to get rid of this
                FreqMatrixBySuit(k,Loc(k))=0;
            end
            clear Loc    
            [~,Loc]=max(fliplr(FreqMatrixBySuit(Index,:)>0),[],2);
            Loc = size(FreqMatrix,2)-Loc+1; % Get Card Number
            BestHand(Index,5)=Loc; % Card Num Highest
            for k = 1:length(Loc) % Cant figure out how to get rid of this
                FreqMatrixBySuit(k,Loc(k))=0;
            end
            clear Loc
            [~,Loc]=max(fliplr(FreqMatrixBySuit(Index,:)>0),[],2);
            Loc = size(FreqMatrix,2)-Loc+1; % Get Card Number
            BestHand(Index,6)=Loc; % Card Num Highest
            for k = 1:length(Loc) % Cant figure out how to get rid of this
                FreqMatrixBySuit(k,Loc(k))=0;
            end
            clear Loc FreqMatrixBySuit CPH
        end
        clear Index
    end

    % Calculate 3 of a Kind
    Index = sum(oKind3>0,2)==1 & sum(oKind2>0,2)==0 & sum(oKind4>0,2)==0;
    if sum(Index)>=1        
        [~,Loc]=max(fliplr(FreqMatrix(Index,:)==3),[],2); % Find Best 3ofK
        Loc = size(FreqMatrix,2)-Loc+1; % Get Card Number 
        BestHand(Index,1)=4; % 3 of a Kind Index
        BestHand(Index,2)=Loc; % Card Number
        clear Loc
        FreqMatrixW=FreqMatrix(Index,:); % Working Copy
        FreqMatrixW(FreqMatrixW==3)=0; % Ensure Max Card Isn't 3oK Card
        [~,Loc] = max(fliplr(FreqMatrixW>0),[],2);
        Loc = size(FreqMatrix,2)-Loc+1; % Get Card Number
        BestHand(Index,3)=Loc; % Card Num Highest Remainder
        for j = 1:length(Loc) % Cant figure out how to get rid of this
            FreqMatrixW(j,Loc(j))=0;
        end
        clear Loc
        [~,Loc] = max(fliplr(FreqMatrixW>0),[],2);
        Loc = size(FreqMatrix,2)-Loc+1; % Get Card Number
        BestHand(Index,4)=Loc; % Card Num 2nd Highest Remainder
        BestHand(Index,5:6)=0;
        clear Loc Index FreqMatrixW
    end
    clear Index
    
    % Calculate Full House
    Index = sum(oKind3,2)==2 | (sum(oKind3,2)==1 & sum(oKind2,2)>0);
    if sum(Index)>=1
        BestHand(Index,1)=7; % Full House Index   
        [~,Loc]=max(fliplr(FreqMatrix(Index,:)==3),[],2); % Find Best 3oK
        Loc = size(FreqMatrix,2)-Loc+1; % Get Card Number
        BestHand(Index,2)= Loc; %Save Card Num     
        FreqMatrixW = FreqMatrix(Index,:);
        for j = 1:length(Loc) % Cant figure out how to get rid of this
            FreqMatrixW(j,Loc(j))=0;
        end
        clear Loc
        [~,Loc]=max(fliplr(FreqMatrixW(:,:)>=2),[],2); % Find Best 2oKind    
        Loc = size(FreqMatrix,2)-Loc+1; % Get Card Number
        BestHand(Index,3)= Loc; %Save Card Num
        clear Loc
    end
    clear Index
        
    % Calculate 4 of a Kind
    Index = sum(oKind4,2)>0;
    if sum(Index)>=1
        [~,Loc]=max(fliplr(FreqMatrix(Index,:)==4)...
            ,[],2); % Find Best 4 of A Kind
        Loc = size(FreqMatrix,2)-Loc+1; % Get Card Number
        BestHand(Index,1)=8; % 4 of a Kind Index
        BestHand(Index,2)=Loc; % Card Number    
        clear Loc
        FreqMatrixW=FreqMatrix(Index,:); % Working Copy
        FreqMatrixW(FreqMatrixW==4)=0; % Ensure Max Card Isn't 4oK Card
        
        [~,Loc] = max(fliplr(FreqMatrixW>0),[],2);
        Loc = size(FreqMatrix,2)-Loc+1; % Get Card Number
        BestHand(Index,3)=Loc; % Card Number of Highest Remainder
        BestHand(Index,4:6)=0;
        clear Loc FreqMatrixW
    end
    clear Index
    
    % Calculate Straight Flush
    for j = 1:13
        Index = sum(FreqMatrix(:,Straight(j:j+4))>0,2)==5;
        if sum(Index)>=1
            for q = 1:4
                if sum(round(CurrentPlayerHand(Index,:)*10)/10==...
                    Straight(j)+q/10)+...
                    sum(round(CurrentPlayerHand(Index,:)*10)/10==...
                    Straight(j+1)+q/10)+...
                    sum(round(CurrentPlayerHand(Index,:)*10)/10==...
                    Straight(j+2)+q/10)+...
                    sum(round(CurrentPlayerHand(Index,:)*10)/10==...
                    Straight(j+3)+q/10)+...
                    sum(round(CurrentPlayerHand(Index,:)*10)/10==...
                    Straight(j+4)+q/10)==5
                BestHand(Index,1)= 9; % Straight Flush Index
                BestHand(Index,2)= Straight(j+4); % Highest Card In Straight
                BestHand(Index,3:6)=0;
                end
            end
        end
        clear Index
    end    
    clear j
  
% Score Each Hand as Single Value For Direct Comparison    
ScoreHands(i,:) = BestHand(:,1)*10000000000+BestHand(:,2)*...
    100000000+BestHand(:,3)*1000000+BestHand(:,4)*10000+...
    BestHand(:,5)*100+BestHand(:,6)*1;
clear CurrentPlayerHand FreqMatrix BestHand oKind1 oKind2 oKind3 oKind4
end

%% Compute Winner of Each Iteration
% Create Function Handle to Avoid Loop
RetrieveMax = @(x) max(ScoreHands(:,x));
% Retrieve Best Score Per Hand
[HandMax,~] = RetrieveMax(1:nIter);

% Create nPlayer Rows of Hand Max for Logic Matrix Comparison
HandMax = repmat(HandMax,nPlayers,1);
% Create Logical Index of Winners By Score
WinnerMatrix = HandMax==ScoreHands;
% Calculate the Probability of Each Player Winning Adjusted for Ties
WinProb = WinnerMatrix/sum(WinnerMatrix,1);

    
end
