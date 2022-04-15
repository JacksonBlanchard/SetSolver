   
%
% Set Solver Project Part 1 - Get cards from the image
% Returns a list, where each row corresponds to a card and each column
% contains the information about each of the cards 4 corners
% [Top left, top right, bottom left, bottom right]
%
function card_corners = Part1(filename)
    % Add the Images folder to the search path
    addpath('Images');

    % Set default filename is none is passed in
    if nargin < 1
        filename = 'IMG_7534.jpg';
    end

    % Read in the original image
    im_original = imread(filename);

    % Convert image to grayscale
    %im_grayscale = rgb2gray(im_original);

    % Generate a version of the image where pixel value = sum of rgb
    % channels
    im_rgbsum = im_original(:,:,1) + im_original(:,:,1) + im_original(:,:,1);

    % Convert to binary with low threshold (Shows cards against black
    % cloth)
    im_bin = imbinarize(im_rgbsum, 0.4);

    % Close the image to remove small black spots, then open to remove
    % small white spots
    strel_disk = strel("disk",5);
    im_bin = imclose(im_bin, strel_disk);
    im_bin = imopen(im_bin, strel_disk);

    % Find each potential card
    [potential_cards, regions_found] = bwlabel(im_bin);

    % Storage for found card
    % [Upper bound, lower bound, left bound, right bound]
    found_cards = [];

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

        % If region area is larger than 150000 pixels and less than 900000 
        % pixels, this is a card
        if (region_area > 150000 && region_area < 900000)
            found_cards = [found_cards; [upper,lower,left,right]];
        end
    end

    % Storage for list of corners of each card
    % [Top left, top right, bottom left, bottom right]
    card_corners = [];
    
    % For each card found
    for found_card = 1:size(found_cards,1)
        % Get the bounds of the card (But increase border around cards)
        card_bounds = found_cards(found_card,:);
        upper = card_bounds(1)-5;
        lower = card_bounds(2)+5;
        left = card_bounds(3)-5;
        right = card_bounds(4)+5;
    
        % Isolate section of image containing card from rgbsum space
        rgbsum_card = im_rgbsum(upper:lower,left:right);

        % Apply a very low threshold to the rgbsum card and open to remove
        % white spots
        bin_card = imbinarize(rgbsum_card, 0.2);
        strel_card = strel("disk",5);
        bin_card = imopen(bin_card,strel_card);

        % Determine all corners of the binary card
        corners = detectMinEigenFeatures(bin_card);
    
        % Reference for image top left, bottom left, top right and bottom
        % right corners
        [ybound,xbound] = size(bin_card);
        im_topleft = [0,0];
        im_topright = [xbound,0];
        im_bottomleft = [0,ybound];
        im_bottomright = [xbound,ybound];

        % Storage for closest corner found to each real corner
        % Default to first corner in the list
        topleft = ceil(corners.Location(1,:));
        topright = ceil(corners.Location(1,:));
        bottomleft = ceil(corners.Location(1,:));
        bottomright = ceil(corners.Location(1,:));

        % For all other corners detected
        for cornerIndex = 2:length(corners.Location)
            % Acquire the corner
            corner = ceil(corners.Location(cornerIndex,:));

            % If this corner is closer to top left
            if pdist([corner;im_topleft]) < pdist([im_topleft;topleft])
                topleft = corner;
            end
            % If this corner is closer to top right
            if pdist([corner;im_topright]) < pdist([im_topright;topright])
                topright = corner;
            end
            % If this corner is closer to bottom left
            if pdist([corner;im_bottomleft]) < pdist([im_bottomleft;bottomleft])
                bottomleft = corner;
            end
            % If this corner is closer to bottom right
            if pdist([corner;im_bottomright]) < pdist([im_bottomright;bottomright])
                bottomright = corner;
            end
        end

        % Normalize the corners to the entire image
        topleft = topleft + [left, upper];
        topright = topright + [left, upper];
        bottomleft = bottomleft + [left, upper];
        bottomright = bottomright + [left, upper];

        % Assign the corners to the list of card corners
        card_corners = [card_corners;topleft,topright,bottomleft,bottomright];

    end

    % Determine the corners of the cards from the binary image
    %%corners = detectHarrisFeatures(im_bin, 'FilterSize', 25);
    % Show the image with corners marked
    %%imshow(im_original);
    %%hold on;
    %%plot(corners);

    %corners = detectHarrisFeatures(im_grayscale, 'FilterSize', 25);
    %imshow(im_original);
    %hold on;
    %plot(corners);
    
    %{
    figure();
    imshow(im_original);
    % Select the corners of each card starting from the top-left
    fprintf('Select the corners of each card starting from top-left moving clockwise.');
    [xs_in,ys_in] = ginput();
    round(xs_in.');
    round(ys_in.');
    % Set up the output coordinates to match the smallest card dimensions
    s = [ys_in(3) - ys_in(2), xs_in(2) - xs_in(1)];
    % Set up the final output coordinates to have a 10 pixel cushion from
    % edge to account for user error.
    xs_out = [10 s(2)-10 s(2)-10 10].';
    ys_out = [10 10 s(1)-10 s(1)-10].';
    % Pair up the x's and y's for geometric transformation
    input_pts = [xs_in, ys_in];
    output_pts = [xs_out, ys_out];
    % Fit the cards to the output coordinates
    card = fitgeotrans(input_pts, output_pts, 'projective');
    % Move all the pixels into the new image
    rectified_img = imwarp(im_original, card, 'OutputView', imref2d(s));
    imshow(rectified_img);
    %}
end