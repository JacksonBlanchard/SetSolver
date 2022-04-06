%
% Set Solver Project Part 1 - Get cards from the image
%
function Part1(filename)
    % Add the Images folder to the search path
    addpath('..\Images');

    % Set default filename is none is passed in
    if nargin < 1
        filename = 'IMG_7534.jpg';
    end

    % Read in the original image
    im_original = imread(filename);

    im_grayscale = rgb2gray(im_original);
    corners = detectHarrisFeatures(im_grayscale, 'FilterSize', 25);
    imshow(im_original);
    hold on;
    plot(corners);
    
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