%
% Given a normalized card, determine the color of the shape on the card.
%
function color_found = GetCardColor(nrmCard)

    % Cut off roughly 30 pixels in all directions of the card, to remove
    % any chance of extra border getting through
    nrmCard = nrmCard(30:670,30:470,:);

    % Initialize the total number of non-white pixels and each color
    % component
    num_pixels = 0;
    total_red = 0;
    total_blu = 0;
    total_grn = 0;

    % Calculate the average non-white pixel value
    for r = 1:size(nrmCard, 1)
        for c = 1:size(nrmCard, 2)
            pixel_val = squeeze(nrmCard(r,c,:)).';
            % If the pixel is above this threshold it is white
            if pixel_val(1) < 100 || pixel_val(2) < 100 || pixel_val(3) < 100
                % Add the current pixel value to the running total
                total_red = total_red + double(pixel_val(1));
                total_grn = total_grn + double(pixel_val(2));
                total_blu = total_blu + double(pixel_val(3));
                % Increment our counter for the number of pixels added
                num_pixels = num_pixels + 1;
            end
        end
    end

    % Compute the averages of each color channel for all the non-white
    % pixels in the normalized image.
    avg_red = total_red / num_pixels;
    avg_grn = total_grn / num_pixels;
    avg_blu = total_blu / num_pixels;

    % If green has the highest average, the card is green
    if avg_grn > avg_red && avg_grn > avg_blu
        color_found = "green";
    % If there is way more red than anything else, the card is red
    elseif avg_red > (avg_grn + avg_blu)
        color_found = "red";
    % Otherwise there is a mix of red and blue, so the card is purple
    else
        color_found = "purple";
    end
end