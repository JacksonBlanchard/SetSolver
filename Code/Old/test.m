function test()
    % Get corners for cards
    img = "IMG_7534.jpg";
    card_corners = Part1(img);

    % Get the number of cards
    [card_num,~] = size(card_corners);
    
    % Display the image
    imshow(imread(img));
    hold on;

    % For each card
    for card = 1:card_num
        % Get the point data for the card corners
        %  [Top left, top right, bottom left, bottom right]
        corner_data = card_corners(card,:);
        topleft = [corner_data(1),corner_data(2)];
        topright = [corner_data(3),corner_data(4)];
        bottomleft = [corner_data(5),corner_data(6)];
        bottomright = [corner_data(7),corner_data(8)];

        % Plot the corners of this card
        plot(topleft(1),topleft(2), 'r+', 'MarkerSize', 30, 'LineWidth', 2);
        plot(bottomleft(1),bottomleft(2), 'r+', 'MarkerSize', 30, 'LineWidth', 2);
        plot(topright(1),topright(2), 'r+', 'MarkerSize', 30, 'LineWidth', 2);
        plot(bottomright(1),bottomright(2), 'r+', 'MarkerSize', 30, 'LineWidth', 2);
    end
end