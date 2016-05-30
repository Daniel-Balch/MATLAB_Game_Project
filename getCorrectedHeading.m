function [gen,headingX,headingY] = getCorrectedHeading(mPos)
    x = mPos(1);
    xCenter = (x+(mPos(3)/2));
    y = mPos(2);
    yCenter = (y+(mPos(4)/2));
    screenDims = get(0,'screensize');
    sXCenter = (screenDims(3)/2);
    sYCenter = (screenDims(4)/2);
    headingX = (sXCenter - xCenter);
    headingY = (sYCenter - yCenter);
    bearing = ((180/pi)*(atan2(headingY,headingX)));
    if ((bearing >= 337.5) && (bearing < 22.5))
        gen = 1;
    elseif ((bearing >= 22.5) && (bearing < 67.5))
        gen = 2;
    elseif ((bearing >= 67.5) && (bearing < 112.5))
        gen = 3;
    elseif ((bearing >= 112.5) && (bearing < 157.5))
        gen = 4;
    elseif ((bearing >= 157.5) && (bearing < 202.5))
        gen = 5;
    elseif ((bearing >= 202.5) && (bearing < 247.5))
        gen =6 ;
    elseif ((bearing >= 247.5) && (bearing < 292.5))
        gen = 7;
    else
        gen = 8;
    end
end