function[pos,error] = getMonsterStartParams(pSec,margin,size)
    screenDims = get(0,'screensize');
    preError = 0;
    sX = screenDims(3);
    sY = screenDims(4);
    sMX1 = round((sX*(1/3)));
    sMX2 = round((sX*(2/3)));
    sMY1 = round((sY*(1/3)));
    sMY2 = round((sY*(2/3)));
    switch(pSec)
        case(1)
            validMonsterStarts = [3 5 6 7 8];
        case(2)
            validMonsterStarts = [4 5 6 7 8];
        case(3)
            validMonsterStarts = [1 4 6 7 8];
        case(4)
            validMonsterStarts = [2 3 5 7 8];
        case(5)
            validMonsterStarts = [1 2 4 6 7];
        case(6)
            validMonsterStarts = [1 2 3 5 8];
        case(7)
            validMonsterStarts = [1 2 3 4 5];
        case(8)
            validMonsterStarts = [1 2 3 4 6];
        case(9)
            validMonsterStarts = [1 3 6 8];
        otherwise
            preError = 1;
    end
    error = preError;
    monsterStartIndex = randi((length(validMonsterStarts)));
    mSec = validMonsterStarts(monsterStartIndex);
    lB = (-1*margin);
    lBa = (lB-size(1));
    lB2 = (lB-size(2));
    rB = (sX+margin);
    rBa = (rB+size(1));
    tB = (sY+margin);
    tBa = (tB+size(2));
    xLowerLims = [lB sMX1 sMX2 lBa rB lB sMX1 sMX2];
    xUpperLims = [sMX1 sMX2 rB sMX1 rBa sMX1 sMX2 rB];
    yLowerLims = [sMY2 tB sMY2 sMY1 sMY1 lB lB2 lB];
    yUpperLims = [tB tBa tB sMY2 sMY2 sMY1 lB sMY1];
    switch(mSec)
        case(1)
            if (pSec == 3)
                side = 2;
            elseif (pSec == 6)
                side = 1;
            else
                side = randi(2);
            end
        case(3)
            if (pSec == 8)
                side = 1;
            elseif (pSec == 1)
                side = 3;
            else
                side = (((randi(2))*2)-1);
            end
        case(6)
            if (pSec == 1)
                side = 4;
            elseif (pSec == 8)
                side = 2;
            else
                side = ((randi(2))*2);
            end
        case(8)
            if (pSec == 3)
                side = 4;
            elseif (pSec == 6)
                side = 3;
            else
                side = ((randi(2))+2);
            end
        case(2)
            side = 1;
        case(4)
            side = 2;
        case(5)
            side = 3;
        otherwise
            side = 4;
    end
    if ((side == 1) || (side == 4))
        xLeft = xLowerLims(mSec);
        xRight = xUpperLims(mSec);
        xPos = (xLeft+(randi((xRight-xLeft))));
    else
        yBottom = yLowerLims(mSec);
        yTop = yUpperLims(mSec);
        yPos = (yBottom+(randi((yTop-yBottom))));
    end
    switch(side)
        case(1)
            yPos = tB;
        case(2)
            xPos = lBa;
        case(3)
            xPos = rB;
        otherwise
            yPos = lB2;
    end
    pos = [xPos yPos size];
end