%
% Given a normalized card, determine the number of shapes present on the
% card
%
function shapes_found = GetCardNum(nrmCard)

    % Convert the card to binary with medium threshold
    bin_card = imbinarize(im2gray(nrmCard));
    
    % Invert the card image for shape detection
    bin_card = 1 - bin_card;

    % Cut off roughly 30 pixels in all directions of the card, to remove
    % any chance of extra border getting through
    bin_card = bin_card(30:670,30:470);

    % Determine the number of shapes on the card
    [potential_shapes, regions_found] = bwlabel(bin_card);

    % Counter for number of shapes found
    shapes_found = 0;

    % For each potential shape found
    for potential_shape = 1:regions_found
        % Find the region coresponding to the potential shape
        [rows,~] = find(potential_shapes==potential_shape);
        % If this region contains more than 1000 pixels
        if length(rows) > 1000
            % This is a shape
            shapes_found =  shapes_found + 1;
        end
    end
end