function [S] = move_fig(pos)
% move figure with arrow keys.
I = imread('player3.tif');
S.fh = figure('units','pixels',...
    'position',pos,...
    'menubar','none',...
    'name','move_fig',...
    'numbertitle','off',...
    'resize','off',...
    'keypressfcn',@fh_kpfcn); imshow(I);
S.tx = uicontrol('style','text',...
    'units','pixels',...
    'position',pos,...
    'fontweight','bold');
guidata(S.fh,S)
set(S.fh,'position',pos);
end
function [] = fh_kpfcn(H,E)
% Figure keypressfcn
S = guidata(H);
P = get(S.fh,'position');
screenDims = get(0,'screensize');
sX = (screenDims(3)+10);
sY = (screenDims(4)+10);
set(S.tx,'string',E.Key)
step = 10;
switch E.Key
    case 'rightarrow'
        if ((P(1)+P(3)) <= sX)
            set(S.fh,'pos',P+[step 0 0 0]);
        end
    case 'leftarrow'
        if (P(1) >= -10)
            set(S.fh,'pos',P+[(-1*step) 0 0 0]);
        end
    case 'uparrow'
        if ((P(2)+P(4)) <= sY)
            set(S.fh,'pos',P+[0 step 0 0]);
        end
    case 'downarrow'
        if (P(2) >= -10)
            set(S.fh,'pos',P+[0 (-1*step) 0 0]);
        end
    otherwise
end
end