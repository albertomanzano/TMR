% Read in original RGB image.
rgbImage = imread('monet.jpg');

% Extract color channels.
redChannel = rgbImage(:,:,1); % Red channel
greenChannel = rgbImage(:,:,2); % Green channel
blueChannel = rgbImage(:,:,3); % Blue channel

% Create an all black channel.
allBlack = zeros(size(rgbImage, 1), size(rgbImage, 2), 'uint8');

% Create color versions of the individual color channels.
just_red = cat(3, redChannel, allBlack, allBlack);
just_green = cat(3, allBlack, greenChannel, allBlack);
just_blue = cat(3, allBlack, allBlack, blueChannel);

% Recombine the individual color channels to create the original RGB image again.
subplot(1,3,1), imshow(just_red)
subplot(1,3,2), imshow(just_green)
subplot(1,3,3), imshow(just_blue)
