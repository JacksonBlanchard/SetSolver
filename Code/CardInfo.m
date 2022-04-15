%
% A class to hold card information
%
classdef CardInfo < handle
    properties (Access = private)
        % Upper, lower, left and right bounds of card relative to entire
        % image
        bounds = [];
        % Normalized image of this card
        nrm_img = [];
        % Number of shapes on this card (Default is 0)
        % Valid numbers are 1, 2, 3
        num = 0;
        % Color of shapes on this card (Default is "")
        % Valid colors are "red", "green", "purple"
        color = "";
        % Pattern of shapes on this card (Default is "")
        % Valid patters are "empty", "lines" "filled"
        pattern = "";
        % Type of shape on this card (Default is "")
        % Valid shapes are "diamond", "squiggle", "oval"
        shape = "";
    end
    methods
        % Init function for CardInfo, takes in corners, rgb and normalized 
        % image of card
        function obj = CardInfo(bounds, nrm_img)
            % If making an empty object, just return
            if nargin < 2
                return
            end
            obj.bounds = bounds;
            obj.nrm_img = nrm_img;
        end

        % getBounds - getter method for card bounds
        function bounds = getBounds(obj)
            bounds = obj.bounds;
        end
        % getNrmImg - getter method for normalized image of card
        function nrmImg = getNrmImg(obj)
            nrmImg = obj.nrm_img;
        end

        % getNum - getter method for number of shapes on card
        function num = getNum(obj)
            num = obj.num;
        end
        % getColor - getter method for color of shapes on card
        function color = getColor(obj)
            color = obj.color;
        end
        % getPattern - getter method for pattern of shapes on card
        function pattern = getPattern(obj)
            pattern = obj.pattern;
        end
        % getShape - getter method for shape on card
        function shape = getShape(obj)
            shape = obj.shape;
        end

        % setNum - setter method for number on card
        function setNum(obj, num)
            obj.num = num;
        end
        % setColor - setter method for color of shapes on card
        function setColor(obj, color)
            obj.color = color;
        end
        % setPattern - setter method for pattern of shapes on card
        function setPattern(obj, pattern)
            obj.pattern = pattern;
        end
        % setShape - setter method for shape on card
        function setShape(obj, shape)
            obj.shape = shape;
        end
    end
end