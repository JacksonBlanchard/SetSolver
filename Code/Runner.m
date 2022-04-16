%
% Set Solver Project Runner - Applies all parts of project to a set image
%
function Runner(filename)

    % By default, there will be 12 cards present in each image
    CARD_NUM = 12;

    % Add the Images folder to the search path
    addpath('..\Images');

    % Set default filename is none is passed in
    if nargin < 1
        filename = 'IMG_7534.jpg';
    end

    % Storage for each of the cards
    cards = [];

    % Determine the bounds for each of the cards
    bounds = IsolateCards(filename);

    % For each card's bounds
    for boundIndex = 1:CARD_NUM
        % Acquire the card bounds
        cardBounds = bounds(boundIndex,:);
        % Normalize the card given the
        nrmCard = NormalizeCard(filename, cardBounds);
        % Create card object with bounds and normalized card parameters
        cards = [cards;CardInfo(cardBounds,nrmCard)];
    end

    % Displays each normalized card (Uncomment if you want to test)
    % For each card in the list
    for cardIndex = 1:CARD_NUM
        % Set figure
        figure(cardIndex);
        % Acquire card from list
        card = cards(cardIndex);
        % Display the normalized card
        imshow(card.getNrmImg());
    end
end


