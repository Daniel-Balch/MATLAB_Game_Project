function [go] = countdown(cdownType,lvl,round,livesUsed,lifeLimit,score)
if (cdownType ~= -1)
    lRem = (lifeLimit-livesUsed);
    switch(cdownType)
        case(0)
            fileText = 'gamebegins';
        case(1)
            fileText = 'died';
        case(2)
            fileText = 'survived';
        otherwise
            fileText = 'levelup';
    end
    titleText = sprintf('Round: %i',round);
    if (lvl ~= 0)
        titleTextB = sprintf('  |  Level: %i',lvl);
        titleText = sprintf('%s%s',titleText,titleTextB);
    end
    footerText = '';
    if (lifeLimit ~= 0)
        footerText = sprintf('Lives Remaining: %i',lRem);
    end
    if (cdownType > 0)
        footerText = sprintf('%s  |  Score: %i',footerText,score);
    end
    title(titleText,'FontSize',14);
    if (length(footerText) > 1)
        xlabel(footerText,'FontSize',14);
    end
    close all;
    screenDims = get(0,'screensize');
    cdPos = [0 0 screenDims(3) screenDims(4)];
    for k = 1:5
        A = imread((sprintf('%s%i.jpg',fileText,(6-k))));
        if (k == 1)
            figure('units','pixels','position',cdPos,...
                'menubar','none','name','Countdown','numbertitle','off',...
                'resize','off','keypressfcn',@fh_kpfcn);
        else
            hold on;
        end
        imshow(A);
        title(titleText,'FontSize',14);
        if (length(footerText) > 1)
            xlabel(footerText,'FontSize',14);
        end
        pause(1);
    end
end
close all;
go = 1;
end