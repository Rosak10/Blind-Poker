% This script will demo the Card Analyze Function which Evaluates
% Probability of each player winning in a round of Texas Holdem.

% Choose Number of Players
nPlayers = 6;

% Choose Number of Players Whose Cards Are Known
KnownPlayers = 3;

% Number of Iterations to Estimate Probabilities (more == accurate)
nIter = 5000;

% Create a Deck of Cards
%   Whole number = Card Number
%   Decimal      = Card Suit
Cards = 2:.1:15;
Cards(mod(Cards,1)>.41 | mod(Cards,1)<.09)=[];

% Suffle Cards
%   First nPlayers X 2 Go to Players
%   Remainder is left in the deck
Shuffle = Cards(randperm(length(Cards)));
% Deal a Hand 
Hand = reshape(Shuffle(1:1:2*KnownPlayers),2,KnownPlayers);

% Cards Currently on the Table
Table = []; % make sure anything on the table isn't in a hand

tic
% Evaluate Probabilities of Each Player Winning The Round
WinProb = CardAnalyze(Hand,Table,nPlayers,nIter);
toc

% Bar Graph of Win Probabilities
bar(WinProb)

clear nPlayers Cards nIter Shuffle KnownPlayers
