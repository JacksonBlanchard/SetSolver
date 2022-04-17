%
% Given the bounds of a card and the original image, return a normalized 
% version of the card with set length and width [Ratio of 3.5 : 2.5]
% End result card will be 700 x 500 pixels
%
function nrmCard = NormalizeCard(filename, card_bounds)
    % Disable warnings until end of function
    warning("off");

    % Read in the original image
    im_original = imread(filename);

    % Generate a version of the image where pixel value = sum of rgb
    % channels
    im_rgbsum = im_original(:,:,1) + im_original(:,:,2) + im_original(:,:,3);

    % Unpack card bounds
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

    % Assign moving points for the card
    % [Top Left, Bottom Left, Bottom Right, Top Right]
    movingPoints = [topleft;bottomleft;bottomright;topright];
    % Define what they should be mapped onto
    % [Top Left, Bottom Left, Bottom Right, Top Right]
    fixedPoints = [1 1; 1 700; 500 700; 500 1];

    % Generate the transformation matrix for the card
    tform = fitgeotrans(movingPoints,fixedPoints,"projective");
    % Generate a template to put mapped card onto
    warpedCard = imref2d([700 500]);
    % Transform the card and map onto template
    nrmCard = imwarp(im_original, tform, 'OutputView', warpedCard);

    % Re-enable warnings
    warning('on');
end