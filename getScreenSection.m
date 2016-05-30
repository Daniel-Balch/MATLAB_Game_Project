function [section] = getScreenSection(pos)
    screenDims = get(0,'screensize');
    x = pos(1);
    y = pos(2);
    sX = screenDims(3);
    sY = screenDims(4);
    sMX1 = round((sX*(1/3)));
    sMX2 = round((sX*(2/3)));
    sMY1 = round((sY*(1/3)));
    sMY2 = round((sY*(2/3)));
    if (x < sMX1)
        if (y < sMY1)
            section = 6;
        elseif (y < sMY2)
            section = 4;
        else
            section = 1;
        end
    elseif (x < sMX2)
        if (y < sMY1)
            section = 7;
        elseif (y < sMY2)
            section = 9;
        else
            section = 2;
        end
    else
        if (y < sMY1)
            section = 8;
        elseif (y < sMY2)
            section = 5;
        else
            section = 3;
        end
    end
end