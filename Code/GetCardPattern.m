%
% Given a normalized card, determine the number of pattern of the shapes
% present on the card
%
function pattern = GetCardPattern(nrmCard)

    % Convert the card to binary with medium threshold
    bin_card = imbinarize(im2gray(nrmCard));

    % Invert the card image for shape detection
    bin_card = 1 - bin_card;

    % Cut off roughly 30 pixels in all directions of the card, to remove
    % any chance of extra border getting through
    bin_card = bin_card(30:670,30:470);

    % Determine the number of shapes on the card
    [potential_shapes, regions_found] = bwlabel(bin_card);

    % Find a single region that contains a shape
    for potential_shape = 1:regions_found
        % Find the region coresponding to the potential shape
        [rows,cols] = find(potential_shapes==potential_shape);
        % If this region contains more than 1000 pixels, this is a shape
        if length(rows) > 1000
            % Calculate the bounds of this shape (with 5 pixels of padding)
            upper = min(rows) - 5;
            lower = max(rows) + 5;
            left = min(cols) - 5;
            right = max(cols) + 5;

            % Isolate this shape in the normalized image (w/ 30 pixels
            % removed from each side)
            smol_card = nrmCard(30:670,30:470,:);
            shape = smol_card(upper:lower,left:right,:);

            % Brighten shape
            shape = im2double(shape).^3;


            % Convert the shape region to binary with medium threshold
            bin_shape = imbinarize(im2gray(shape));
            % Determine the number of regions within this shape
            [~, regions_found] = bwlabel(bin_shape);

            % The number of regions within the shape should be one less
            % than the total number of regions found, as the background
            % counts as a region
            inner_regions_found = regions_found - 1;

            % If no regions are found, shape has a 'filled' pattern
            if inner_regions_found == 0
                pattern = 'filled';
            % If one regions is found, shape has an 'empty' pattern
            elseif inner_regions_found == 1
                pattern = 'empty';
            % Otherwise, multiple regions were found, and shape has a
            % 'lined' pattern
            else
                pattern = 'lined';
            end
            % No longer need to loop, can be broken out of when completed
            break
        end
    end
end