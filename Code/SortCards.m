%
% Method for sorting cards in array
% First row of cards in index 1 - 4, second in 5 - 8, third in 9 - 12
%
function newNewCardList = SortCards(cardList, CARD_NUM)
    % Storage for the new card list
    newCardList = [];

    % First sort the cards based on their height
    for cardIndex = 1:CARD_NUM
        % Get the card at this index
        card = cardList(cardIndex);
        % If the card list is empty, append to the list
        if length(newCardList) == 0
            newCardList = [card];
        % If the list is not empty, determine where this card goes via
        % insertion sort
        else
            % For each card in the list
            for listCardIndex = 1:length(newCardList)
                % Get the card in the list
                listCard = newCardList(listCardIndex);
                % If the current card goes before the list card
                if card.getUpperBound() < listCard.getUpperBound()
                    % Add to the list and break from loop
                    if listCardIndex == 1
                        newCardList = [card;newCardList];
                    else
                        newCardList = [newCardList(1:listCardIndex-1);card;newCardList(listCardIndex:length(newCardList))];
                    end
                    % Break from loop
                    break
                end
                % If card doesn't go before any other card, it goes at
                % end of list
                if listCardIndex == length(listCardIndex)
                    newCardList = [newCardList;card];
                end
            end
        end
    end

    % Group size
    GROUP_SIZE = CARD_NUM / 4;

    % New card list
    newNewCardList = [];

    % Next, sort groupings of cards based on leftmost bounds
    for group = 1:GROUP_SIZE
        % Ordered left list
        leftOrderedList = [];

        % Get starting index for group
        startIndex = group*4 - 3;
        % Get ending index for group
        endIndex = group*4;

        % For every card in the group
        for cardIndex = startIndex:endIndex
            % Get the card at this index
            card = newCardList(cardIndex);
            % If the card list is empty, append to the list
            if length(leftOrderedList) == 0
                leftOrderedList = [card];
            % If the list is not empty, determine where this card goes via
            % insertion sort
            else
                % For each card in the list
                for listCardIndex = 1:length(leftOrderedList)
                    % Get the card in the list
                    listCard = leftOrderedList(listCardIndex);
                    % If the current card goes before the list card
                    if card.getLeftBound() < listCard.getLeftBound()
                        % Add to the list and break from loop
                        if listCardIndex == 1
                            leftOrderedList = [card;leftOrderedList];
                        else
                            leftOrderedList = [leftOrderedList(1:listCardIndex-1);card;leftOrderedList(listCardIndex:length(newCardList))];
                        end
                        % Break from loop
                        break
                    end
                    % If card doesn't go before any other card, it goes at
                    % end of list
                    if listCardIndex == length(listCardIndex)
                        leftOrderedList = [leftOrderedList;card];
                    end
                end
            end
        end
        % Append to new card list
        newNewCardList = [newNewCardList;leftOrderedList];
    end
end