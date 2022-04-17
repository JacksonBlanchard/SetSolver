%
% Set Solver Project Runner - Applies all parts of project to a set image
%
function Runner(filename)

    % By default, there will be 12 cards present in each image
    CARD_NUM = 1;

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
        card = CardInfo(cardBounds,nrmCard);

        % Determine the number of shapes on this card and store value
        card.setNum(GetCardNum(nrmCard));

        % Determine the pattern of this card's shapes and store value
        card.setPattern(GetCardPattern(nrmCard));

        % Determine the shape present on this card and store value
        card.setShape(GetCardShape(nrmCard));

        % Store this card in the list of cards
        cards = [cards; card];
    end

    figure(3)

    % Displays each normalized card (Uncomment if you want to test)
    % For each card in the list
    for cardIndex = 1:CARD_NUM
        % Subplot to display this card
        subplot(4,3,cardIndex);
        % Acquire card from list
        card = cards(cardIndex);
        % Display the normalized card
        imshow(card.getNrmImg());
        % Set title
        title(sprintf("%d %s %s %s(s) ", card.getNum(), card.getPattern(), card.getColor(), card.getShape()));
    end
end