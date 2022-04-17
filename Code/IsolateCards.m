%
% IsolateCards - Isolate the cards from the background
% Returns a list of bounds for the card in the form
%  [Upper bound, lower bound, left bound, right bound]
%  relative to the original image
function card_bounds = IsolateCards(filename)
    % Read in the original image
    im_original = imread(filename);

    % Generate a version of the image where pixel value = sum of rgb
    % channels
    im_rgbsum = im_original(:,:,1) + im_original(:,:,2) + im_original(:,:,3);

    % Convert to binary with low threshold (Shows cards against black
    % cloth)
    im_bin = imbinarize(im_rgbsum, 0.4);

    % Close the image to remove small black spots, then open to remove
    % small white spots
    strel_disk = strel("disk",5);
    im_bin = imclose(im_bin, strel_disk);
    im_bin = imopen(im_bin, strel_disk);

    % Set border of entire image to white
    [len,width] = size(im_original);
    im_bin(1,:) = 1;
    im_bin(len,:) = 1;
    im_bin(:,1) = 1;
    im_bin(:,width) = 1;

    % Find each potential card
    [potential_cards, regions_found] = bwlabel(im_bin);

    % Storage for card bounds detected
    card_bounds = [];

    % For each potential card
    for potential_card = 1:regions_found
        % Find the region coresponding to the potential card
        [rows,cols] = find(potential_cards==potential_card);
    
        % Find the bounds of this region
        upper = min(rows);
        lower = max(rows);
        left = min(cols);
        right = max(cols);

        % Calculate the area found for this region
        region_area = (right-left)*(lower-upper);

        % If region area is larger than 150000 pixels and less than 1500000 
        % pixels, this is a card
        if (region_area > 150000 && region_area < 1500000)
            card_bounds = [card_bounds; [upper,lower,left,right]];
        end
    end
end