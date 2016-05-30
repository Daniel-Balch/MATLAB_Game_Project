function [mStep,mLim,pSize,mSize,lives,rounds,lvl] = getStartupParams();
clc;
fprintf('The object of this game is to dodge the monster using your\n');
fprintf('arrow keys.\n\n');
fprintf('Tip: Disable sound, as spurious errors are sometimes\n');
fprintf('produced by in the console during gameplay.\n\n');
setChoice = -1;
while ((setChoice < 0) || (setChoice > 7))
    fprintf('Please choose from one of the difficulty levels below\n');
    fprintf('(or choose custom settings for more gameplay control):\n\n');
    fprintf('\t(0) [Custom Settings]\n');
    fprintf('\t(1) Too Easy\n');
    fprintf('\t(2) Casual\n');
    fprintf('\t(3) Normal\n');
    fprintf('\t(4) Slightly Challenging\n');
    fprintf('\t(5) Advanced\n');
    fprintf('\t(6) Expert\n');
    fprintf('\t(7) Insane\n\n');
    setChoice = input('Your choice (number only): ');
    if ((setChoice < 0) || (setChoice > 7))
        clc;
        fprintf('Sorry, but you entered an invalid choice.\n');
        fprintf('Please try again.\n\n');
    end
end
lvl = setChoice;
if (setChoice == 0)
    screenDims = get(0,'screensize');
    sX = screenDims(3);
    sY = screenDims(4);
    customResponses = zeros(1,7);
    clc;
    paramStrings = ['Monster Step Size                '
                    'Monster Direction Change Interval'
                    'Monster Figure Height            '
                    'Monster Figure Width             '
                    'Player Figure Height             '
                    'Player Figure Width              '
                    'Number of Lives                  '];
    fprintf('Please enter values for the custom parameters specified.\n');
    minValues = [1 1 5 5 5 5 1];
    maxValues = zeros(1,7);
    for k = 1:7
        validResponse = 0;
        while (validResponse == 0)
            fprintf('\n\tParameter: %s\n',paramStrings(k,1:33));
            fprintf('\tMinimum Allowed Value: %i\n',minValues(k));
            switch(k)
                case(1)
                    maxValues(k) = (round((0.5*min(sX,sY))));
                    fprintf('\tMaximum Allowed Value: %i\n',...
                        maxValues(k));
                    fprintf('\tSuggested Range: 1-7\n');
                case(2)
                    maxValues(k) = Inf;
                    fprintf('\tMaximum Allowed Value: No Limit');
                    fprintf('(enter 0 to disable direction changes)\n');
                    fprintf('\tSuggested Value: At least 2\n');
                case(3)
                    maxValues(k) = (round((0.75*sY)));
                    fprintf('\tMaximum Allowed Value: %i\n',...
                        maxValues(k));
                    fprintf('\tSuggested Range: 35-%i\n',...
                        (round((0.4*sY))));
                case(4)
                    maxValues(k) = (round((0.75*sX)));
                    fprintf('\tMaximum Allowed Value: %i\n',...
                        maxValues(k));
                    fprintf('\tSuggested Range: 50-%i\n',...
                        (1.4*round((0.4*sY))));
                case(5)
                    maxValues(k) = (round(((0.9*sY)-(customResponses(3)))));
                    fprintf('\tMaximum Allowed Value: %i\n',...
                        maxValues(k));
                    fprintf('\tSuggested Range: 10-%i\n',...
                        (round((0.5*maxValues(k)))));
                case(6)
                    maxValues(k) = (round(((0.9*sX)-(customResponses(4)))));
                    fprintf('\tMaximum Allowed Value: %i\n',...
                        maxValues(k));
                    fprintf('\tSuggested Range: 14-%i\n',...
                        (round((0.5*maxValues(k)))));
                otherwise
                    maxValues(k) = Inf;
                    fprintf('\tMaximum Allowed Value: No Limit');
                    fprintf('(enter 0 for infinite lives)\n');
            end
            response = input('\nEnter parameter value: ');
            if ((response < minValues(k)) || (response > maxValues(k)))
                fprintf('\nSorry, you entered an invalid response.\n');
                fprintf('Please try again.\n\n');
            else
                customResponses(k) = response;
            end
        end
    end
    mStep = repmat((customResponses(1)),1,7);
    mLim = repmat((customResponses(2)),1,7);
    pSize = [customResponses(6) customResponses(5)];
    mSize = [customResponses(4) customResponses(3)];
    lives = customResponses(7);
    rounds = 0;
else
    numLives = 0;
    numRounds = -1;
    while (numRounds < 0)
        fprintf('\nPlease specify the number of rounds per level\n');
        fprintf('(enter 0 to disable "level-ups").\n\n');
        numRounds = input('Enter a number: ');
        if (numRounds < 0)
            fprintf('\nSorry, you entered an invalid response.\n');
            fprintf('Please try again.\n\n');
        end
    end
    while (numLives < 1)
        fprintf('\nPlease specify the number of lives per level.\n\n');
        numLives = input('Enter a number: ');
        if (numLives < 1)
            fprintf('\nSorry, you entered an invalid response.\n');
            fprintf('Please try again.\n\n');
        end
    end
    mStep = [1 2 3 4 5 7 7];
    mLim = [16 4 2 2 4 2 4];
    pSize = [130 95];
    mSize = (pSize.*2);
    lives = numLives;
    rounds = numRounds;
end
end
    