close all;
clear all;
clc;
[allMStep,allMLim,playerSize,monsterSize,lifeLimit,roundLimit,lvl] = ...
    getStartupParams();
if (lvl ~= 0)
    mStepSize = allMStep(lvl);
    mLimit = allMLim(lvl);
else
    mStepSize = allMStep(1);
    mLimit = allMLim(1);
end
scoreWeights = [1 2 5 10 15 30 65];
gameOver = imread('game_over.jpg');
errorPic = imread('error.jpg');
screenDims = get(0, 'screensize');
screenMargin = 10;
xLim = (screenDims(3) + screenMargin);
yLim = (screenDims(4) + screenMargin);
%playerSize = [130 95];
%monsterSizeFactor = 2;
%monsterSize = (playerSize.*monsterSizeFactor);
needSpawn = 1;
mCount = 0;
%mLimit = 2;
%mStepSize = 3;
mStepCounter = 0;
mStepThresholdA = (mStepSize*20);
mStepThresholdB = (mStepSize*150);
error = 0;
livesUsed = 0;
totalDeaths = 0;
direction = 1;
genDirection = 1;
transition = 0;
score = 0;
round = 0;
totalRounds = 0;
gameSpeed = 70;
thresholdMultiplier = 1.12;
headingX = 0;
headingY = 0;
cdownType = 0;
while ((livesUsed < lifeLimit) && (error == 0))
    headingOverride = ((transition == 0) && (mStepCounter > mStepThresholdA));
    if (needSpawn == 1)
        go = countdown(cdownType,lvl,round,livesUsed,lifeLimit,score);
        if (cdownType ~= -1)
            playerStartX = randi((xLim - playerSize(1)));
            playerStartY = randi((yLim - playerSize(2)));
            SPos = [playerStartX playerStartY playerSize];
        end
        playerSec = getScreenSection([SPos(1) SPos(2)]);
        [mPos,error] = getMonsterStartParams(playerSec,screenMargin,...
            monsterSize);
        if (error == 1)
            disp('Error in setting monster spawning position.');
            break;
        end
        MF = monsterMove(mPos);
        headingX = (playerStartX-(mPos(1)));
        headingY = (playerStartY-(mPos(2)));
        heading = ((180/pi)*(atan2(headingY,headingX)));
        if ((heading >= 337.5) && (heading < 22.5))
            genDirection = 1;
        elseif ((heading >= 22.5) && (heading < 67.5))
            genDirection = 2;
        elseif ((heading >= 67.5) && (heading < 112.5))
            genDirection = 3;
        elseif ((heading >= 112.5) && (heading < 157.5))
            genDirection = 4;
        elseif ((heading >= 157.5) && (heading < 202.5))
            genDirection = 5;
        elseif ((heading >= 202.5) && (heading < 247.5))
            genDirection =6 ;
        elseif ((heading >= 247.5) && (heading < 292.5))
            genDirection = 7;
        else
            genDirection = 8;
        end
        needSpawn = 0;
        S = move_fig(SPos);
    end
    SPos = get(S.fh, 'position');
    mPos = get(MF, 'position');
    xDistance = abs(mPos(1)-SPos(1));
    yDistance = abs(mPos(2)-SPos(2));
    if (headingOverride)
        direction = genDirection;
    elseif (mCount >= mLimit)
        direcAdjust = randi(3);
        if ((direcAdjust == 1) && (genDirection == 1))
            direction = 8;
        elseif ((direcAdjust == 1) && (genDirection > 1))
            direction = (genDirection - 1);
        elseif ((direcAdjust == 3) && (genDirection == 8))
            direction = 1;
        elseif ((direcAdjust == 3) && (genDirection < 8))
            direction = (genDirection + 1);
        else
            direction = genDirection;
        end
        mCount = 0;
    end
    if (direction == genDirection)
        headingMax = max(headingX,headingY);
        headingMultiplier = (mStepSize/headingMax);
        normX = min((headingX*headingMultiplier),mStepSize);
        normY = min((headingY*headingMultiplier),mStepSize);
        set(MF,'pos',mPos+[normX normY 0 0]);
    else
        switch (direction)
            case(1)
                set(MF,'pos',mPos+[mStepSize 0 0 0]);
            case(2)
                set(MF,'pos',mPos+[mStepSize mStepSize 0 0]);
            case(3)
                set(MF,'pos',mPos+[0 mStepSize 0 0]);
            case(4)
                set(MF,'pos',mPos+[(-1*mStepSize) mStepSize 0 0]);
            case(5)
                set(MF,'pos',mPos+[(-1*mStepSize) 0 0 0]);
            case(6)
                set(MF,'pos',mPos+[(-1*mStepSize) (-1*mStepSize) 0 0]);
            case(7)
                set(MF,'pos',mPos+[0 (-1*mStepSize) 0 0]);
            case(8)
                set(MF,'pos',mPos+[mStepSize (-1*mStepSize) 0 0]);
            otherwise
                error = 1;
                disp('Error in updating position.');
                break;
        end
    end
    mStepCounter = (mStepCounter+mStepSize);
    if ((SPos(1)) <= mPos(1))
        xThreshold = playerSize(1);
    else
        xThreshold = monsterSize(1);
    end
    if ((SPos(2)) <= mPos(2))
        yThreshold = playerSize(2);
    else
        yThreshold = monsterSize(2);
    end
    xThreshold = (xThreshold*thresholdMultiplier);
    yThreshold = (yThreshold*thresholdMultiplier);
    if ((xDistance < xThreshold) && (yDistance < yThreshold))
        livesUsed = (livesUsed+1);
        totalDeaths = (totalDeaths+1);
        if ((livesUsed >= lifeLimit) && (lifeLimit > 0))
            break;
        else
            close all;
            clear MF;
            clear 'move_fig';
            needSpawn = 1;
            transition = 0;
            mStepCounter = 0;
            mCount = 0;
            cdownType = 1;
        end
    else
        mCornersX = [(mPos(1)) (mPos(1)+mPos(3))];
        mCornersY = [(mPos(2)) (mPos(2)+mPos(4))];
        onScreenCount = 0;
        for u = 1:2
            for v = 1:2
                onScreenA = (((mCornersX(u)) < xLim) && ...
                    ((mCornersX(u)) >= 0));
                onScreenB = (((mCornersY(v)) < yLim) && ...
                    ((mCornersY(v)) >= 0));
                if (onScreenA && onScreenB)
                    onScreenCount = (onScreenCount + 1);
                end
            end
        end
        if ((onScreenCount > 0) && (transition == 0))
            transition = 1;
        elseif ((onScreenCount == 0) && (transition == 1))
            close all;
            clear MF;
            clear 'move_fig';
            needSpawn = 1;
            score = (score + (scoreWeights(lvl)));
            round = (round + 1);
            totalRounds = (totalRounds + 1);
            cdownType = 2;
            if ((round >= roundLimit) && (roundLimit > 0))
                if (lvl < 7)
                    lvl = (lvl+1);
                    cdownType = 3;
                else
                    lvl = 7;
                end
                mStepSize = allMStep(lvl);
                mLimit = allMLim(lvl);
                livesUsed = 0;
                round = 0;
            end
            transition = 0;
            mStepCounter = 0;
            mCount = 0;
            elseif ((transition == 0) && (mStepCounter > mStepThresholdB))
                close all;
                clear MF;
                clear 'move_fig';
                needSpawn = 1;
                cdownType = -1;
                mStepCounter = 0;
                mCount = 0;
            end
            mCount = (mCount + 1);
        if (headingOverride)
            [genDirection,headingX,headingY] = getCorrectedHeading(mPos);
        end
    end
    pause((1/gameSpeed));
end
close all;
if ((error == 0) && (livesUsed >= lifeLimit) && (lifeLimit > 0))
    figure, imshow(gameOver);
    titleText = sprintf('Score: %i  |  Total Lives Used: %i',...
        score,totalDeaths);
    if (lvl == 0)
        footerText = sprintf('Total Rounds Completed: %i',totalRounds);
    else
        footerText = sprintf('Total Rounds Completed: %i  |  Level: %i',...
            totalRounds,lvl);
    end
    title(titleText,'FontSize',14);
    xlabel(footerText,'FontSize',14);
else
    imshow(errorPic);
end