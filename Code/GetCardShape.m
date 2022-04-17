%
% Given a normalized card, determine the shape present on the card
%
function shape = GetCardShape(nrmCard)

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

            % Convert the shape region to binary with medium threshold
            bin_shape = 1 - imbinarize(im2gray(shape));

            % Fill any holes in the shape
            bin_shape = imfill(bin_shape, 'holes');

            % Read in the oval, squiggle (both orientations) and diamond shape as binary images
            oval_im = imbinarize(imread('oval.jpg'));
            squiggle_im = imbinarize(imread('squiggle.jpg'));
            squiggle2_im = imbinarize(imread('squiggle2.jpg'));
            diamond_im = imbinarize(imread('diamond.jpg'));

            % Resize these images to be the same size as the binary shape
            oval_im = imresize(oval_im, size(bin_shape));
            squiggle_im = imresize(squiggle_im, size(bin_shape));
            squiggle2_im = imresize(squiggle2_im, size(bin_shape));
            diamond_im = imresize(diamond_im, size(bin_shape));

            % XOR the binary image with each of the three images and sum
            % the result
            % (Lower value sum means more alikeness between the binary
            % image and a given shape)
            oval_likeness = sum(sum(xor(bin_shape,oval_im)));
            squiggle_likeness = min(sum(sum(xor(bin_shape,squiggle_im))), ...
                sum(sum(xor(bin_shape,squiggle2_im))));
            diamond_likeness = sum(sum(xor(bin_shape,diamond_im)));

            % If the oval likness is the smallest of the three, this shape
            % is an oval
            if oval_likeness < squiggle_likeness && oval_likeness < diamond_likeness
                shape = 'oval';
            % If the squiggle likeness is the smallest of the three, this
            % shape is a squiggle
            elseif squiggle_likeness < oval_likeness && squiggle_likeness < diamond_likeness
                shape = 'squiggle';
            % Otherwise, the diamond likeness is the smallest of the three,
            % and this shape is a diamond
            else
                shape = 'diamond';
            end

            % No longer need to loop, can be broken out of when completed
            break
        end
    end
end