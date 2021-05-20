function varargin = Words2Pictures(varargout)
% ----------------------------------------------------------------------------------
% FileName: Words2Pictures.m
% 
% Function: Generate Picture(s) with Word(s)
% 
% Author: Jiang Ting, 2017.3.27, in School of Psychology, Beijing Normal University
%         E-Mail: psytingjiang@gmail.com
%         QQ or WeChat: 10045198
%
% ----------------------------------------------------------------------------------

% Create a figure
hFigure1 = figure(1);
set(gcf, 'NumberTitle','off', 'Name', ' Generate Pictures with Words', 'position',[200 100 1024 768], 'Visible','off', 'toolbar','none');

% Create axes1 for bkground and axes2 for angrybird
hAxes_BKG = axes('Parent', hFigure1);
set(gca, 'box','off', 'xtick',[], 'ytick',[], 'units','pixels', 'position',[0 0 1024 768]);

%------ prepare the background picture -------
        %
        CurrentWorkingDirectory = fileparts(mfilename('fullpath'));
        sourceFolderName = 'SourceFolder';
        sourcePath = sprintf('%s\\%s', CurrentWorkingDirectory, sourceFolderName);
        
        bkgImgFileName = 'WhiteBackground.jpg';
        bkgImgPathName = sprintf('%s\\%s', sourcePath, bkgImgFileName);
        
        % if the folder for source does not exist, make a new one
        if ~exist(sourcePath) 
            mkdir(sourcePath);       
            bkgImgMatrix = ones(768, 1024, 3);
            imwrite(bkgImgMatrix, bkgImgPathName, 'JPEG');
        end
        
        % imread the .jpg file
        imgBackGround = imread(bkgImgPathName);

        % Show the BKG image 
        axes(hAxes_BKG);
        h_BKG = imshow(imgBackGround);
%----------------------------------------------



% Create 3 panels: Load Words, Set Parameters, and Generate Pictures
% Panel 1
hPanel_LoadWords = uipanel('Parent', hFigure1,...
                           'Title',' Load words from a .txt File.',... 
                           'FontSize',10,...
                           'units','pixels',...
                           'BackgroundColor','white',...
                           'Position',[40 100 300 600]);
% Panel 2                   
hPanel_SetParameters = uipanel('Parent', hFigure1,...
                               'Title',' Set Parameter for Words.',... 
                               'FontSize',10,...
                               'units','pixels',...
                               'BackgroundColor','white',...
                               'Position',[360 100 300 600]);
% Panel 3                      
hPanel_GeneratePictures = uipanel('Parent', hFigure1,...
                                  'Title',' Preview and Generate Pictures.',... 
                                  'FontSize',10,...
                                  'units','pixels',...
                                  'BackgroundColor','white',...
                                  'Position',[680 100 300 600]);
                              

        
                              
                              
                              
                              
%% Panel 1: "Load Words"  
% Create a Editbox with MultipleLines, for words list
Edit_WordsList = uicontrol('Parent',hPanel_LoadWords, 'Style','edit', 'String', '', 'Max',10, 'Position', [20 160 258 400],...
        'Callback','clc'); 
    
% Create a PushButton
Btn_LoadWords = uicontrol('Parent',hPanel_LoadWords, 'Style', 'pushbutton', 'String', 'Load the Words from a .txt File', 'Position', [20 110 258 25],...
        'Callback', @Btn_LoadWordsFcn); 

% Create a Editbox for .txt file PathName
Edit_PathName_txtFile = uicontrol('Parent',hPanel_LoadWords, 'Style','edit', 'String', '', 'Position',[20 60 258 25], 'Enable','on',...
        'Callback', 'clc'); 
    
%------ initialize the WordIndex -------
        %
        WordIndex = 1;
        WordsList_Cells = {'Rat'; 'Ox'; 'Tiger'; 'Rabbit'; 'Dragon'; 'Snake'; 'Horse'; 'Goat'; 'Monkey'; 'Rooster'; 'Dog'; 'Pig'};
        WordNumber = length(WordsList_Cells);
        set(Edit_WordsList, 'String', WordsList_Cells);
        
        NumberWordsList_Cells = {'Zero'; 'One'; 'Two'; 'Three'; 'Four'; 'Five'; 'Six'; 'Seven'; 'Eight'; 'Nine'; 'Ten'; 'Eleven'; 'Twelve'};
        %
        CurrentWorkingDirectory = fileparts(mfilename('fullpath'));
        textFolderName = 'TextFolder';
        textPath = sprintf('%s\\%s', CurrentWorkingDirectory, textFolderName);
        textFileName = 'NumberWordsList.txt';
        textPathName = sprintf('%s\\%s', textPath, textFileName);
        if ~exist(textPath) 
            mkdir(textPath);
            fid = fopen(textPathName, 'w+');
                for iNumWord = 1:length(NumberWordsList_Cells)
                     tmpWord = NumberWordsList_Cells{iNumWord};
                     fprintf(fid, '%s\r\n', tmpWord);
                end
            fclose(fid);
        end

%------ ------------------------- -------


    
%% Panel 2: "Set Parameters"  
% Add a Text to label Editbox of the Font info. Select
Text_FontSet = uicontrol('Parent',hPanel_SetParameters, 'Style','text', 'Position',[20 545 100 16], 'HorizontalAlignment','Left', 'String','Set Font', 'BackgroundColor','White'); 

% Create a Editbox for Font info.
Edit_FontSet = uicontrol('Parent',hPanel_SetParameters, 'Style','edit', 'String','', 'Position',[20 515 258 25], 'Enable','off',...
        'Callback', 'clc'); 

% Create a PushButton for Font info. Select
Btn_FontSet = uicontrol('Parent',hPanel_SetParameters, 'Style','pushbutton', 'String','Font Select', 'Position',[180 485 100 25],...
        'Callback', @Btn_FontSetFcn);

    
% Add a Text to label Editbox of the Font Color
Text_FontColor = uicontrol('Parent',hPanel_SetParameters, 'Style','text', 'Position',[20 455 100 16], 'HorizontalAlignment', 'Left', 'String','Font Color', 'BackgroundColor','White'); 

% Create a Editbox for Font Color
Edit_FontColor =  uicontrol('Parent',hPanel_SetParameters, 'Style','edit', 'String','', 'Position',[20 425 258 25], 'Enable','off',...
        'Callback', 'clc');

% Create a PushButton for Font Color
Btn_FontColor = uicontrol('Parent',hPanel_SetParameters, 'Style','pushbutton', 'String','Font Color Select', 'Position',[180 395 100 25], ...
        'Callback', @Btn_FontColorFcn);


% Add a Text to label Editbox of the Font Color
Text_BKGColor = uicontrol('Parent',hPanel_SetParameters, 'Style','text', 'Position',[20 365 100 16], 'HorizontalAlignment', 'Left', 'String','Background Color', 'BackgroundColor','White'); 

% Create a Editbox for Font Color
Edit_BKGColor =  uicontrol('Parent',hPanel_SetParameters, 'Style','edit', 'String','', 'Position',[20 335 258 25], 'Enable','off',...
        'Callback', 'clc');

% Create a PushButton for Font Color
Btn_BKGColor = uicontrol('Parent',hPanel_SetParameters, 'Style','pushbutton', 'String','BKG Color Select', 'Position',[180 305 100 25], ...
        'Callback', @Btn_BKGColorFcn);

    

% Add Texts to label Width and Height
Text_Width = uicontrol('Parent',hPanel_SetParameters, 'Style','text', 'Position',[20 250 100 16], 'HorizontalAlignment','Left', 'String','Width', 'BackgroundColor','White'); 
Text_Height = uicontrol('Parent',hPanel_SetParameters, 'Style','text', 'Position',[150 250 100 16], 'HorizontalAlignment','Left', 'String','Height', 'BackgroundColor','White'); 

% Create Editboxes for Width and Height
Edit_Width = uicontrol('Parent',hPanel_SetParameters, 'Style','edit', 'String','', 'Position',[20 221 100 25],...
        'Callback', 'clc');
Edit_Height = uicontrol('Parent',hPanel_SetParameters, 'Style','edit', 'String','', 'Position',[150 221 100 25],...
        'Callback', 'clc');

% Add Radiobuttons and one Editbox for showing L/M/R
RadiobuttonLeft = uicontrol('Parent',hPanel_SetParameters, 'Style','radio', 'String','Left', 'BackgroundColor', 'White', 'Position',[20 165 58 25], 'Callback', @RadioBtnLeftFcn);
RadiobuttonMiddle = uicontrol('Parent',hPanel_SetParameters, 'Style','radio', 'String','Middle', 'BackgroundColor', 'White', 'Position',[88 165 58 25], 'Callback', @RadioBtnMiddleFcn);
RadiobuttonRight = uicontrol('Parent',hPanel_SetParameters, 'Style','radio', 'String','Right', 'BackgroundColor', 'White', 'Position',[156 165 58 25], 'Callback', @RadioRightFcn);

Edit_Aligh = uicontrol('Parent',hPanel_SetParameters, 'Style','edit', 'String','', 'Position',[224 165 25 25],...
        'Callback', 'clc');


% Add 2 Buttons: CounterClockwise vs. Clockwise
Btn_CounterClockwise = uicontrol('Parent',hPanel_SetParameters, 'Style','pushbutton', 'String','CounterClockwise', 'Position',[20 110 100 25], ...
        'Callback', @Btn_CounterClockwiseFcn);
   
Btn_Clockwise = uicontrol('Parent',hPanel_SetParameters, 'Style','pushbutton', 'String','Clockwise', 'Position',[180 110 100 25], ...
        'Callback', @Btn_ClockwiseFcn);

% Add a Editbox for Angle Degree
Edit_Angle = uicontrol('Parent',hPanel_SetParameters, 'Style','edit', 'String','', 'Position',[125 110 30 25],...
        'Callback', 'clc');

Text_Degree = uicontrol('Parent',hPanel_SetParameters, 'Style','text', 'Position',[156 110 20 20], 'HorizontalAlignment','Left', 'String','deg', 'BackgroundColor', 'White'); 
    


% Add a Button: Restore the default parameters
Btn_Restore = uicontrol('Parent',hPanel_SetParameters, 'Style','pushbutton', 'String','Restore the default parameters', 'Position',[20 60 258 25], ...
        'Callback', @Btn_RestoreFcn);
   
    
%------ initialize the parameters -------
        %
        sFont.FontName = 'Arial';
        sFont.FontSize = 36;
        sFont.FontUnits = 'normalized';
        
        %
        fColor = [1 1 1];
        bkgColor = [0 0 0];
        
        %
        set(Edit_FontSet, 'String', 'Name:Arial; Weight:normal; Size:36');   
        set(Edit_FontColor, 'String', 'R:255; G:255; B:255');
        set(Edit_BKGColor, 'String', 'R:0; G:0; B:0');
        
        %
        rWidth = 200;
        rHeight = 200;
        set(Edit_Width, 'String', rWidth);
        set(Edit_Height, 'String', rHeight);

        %
        set(RadiobuttonLeft, 'Value', 0);
        set(RadiobuttonMiddle, 'Value', 1);
        set(RadiobuttonRight, 'Value', 0);
        set(Edit_Aligh, 'String', 'M');

        %
        Angle_Variable = 0;
        tmpAngleString = sprintf('%.1f', Angle_Variable);
        set(Edit_Angle, 'String',  tmpAngleString);
%------ ------------------------- -------
    
%% Panel 3: "Preview and Generate Pictures"

% Create a Gray Background
hAxes_BKG = axes('Parent', hPanel_GeneratePictures);
set(hAxes_BKG, 'box','on', 'xtick',[], 'ytick',[], 'units','pixels', 'position',[49 360 200 200]);
grayImage = zeros(300,300,3)+0.9;
imshow(grayImage);

% Create Axes for Preview
hAxes_Preview = axes('Parent', hPanel_GeneratePictures);
set(gca, 'box','off', 'xtick',[], 'ytick',[], 'units','pixels', 'position',[49 360 200 200],'visible','off');

% Create 2 Buttons: Previous vs. Posterior
Btn_Previous = uicontrol('Parent',hPanel_GeneratePictures, 'Style','pushbutton', 'String','<', 'Position',[12 440 25 50], ...
        'Callback', @Btn_PreviousFcn);
Btn_Posterior = uicontrol('Parent',hPanel_GeneratePictures, 'Style','pushbutton', 'String','>', 'Position',[260 440 25 50], ...
        'Callback', @Btn_PosteriorFcn);

% Create 3 Buttons: Preview one Picture, Generate one Picture, and Generate all Pictures
Btn_PreviewOnePicture = uicontrol('Parent',hPanel_GeneratePictures, 'Style', 'pushbutton', 'String', 'Preview One Picture', 'Position', [48 300 202 25],...
        'Callback', @Btn_PreviewOnePictureFcn);     
Btn_GenerateOnePicture = uicontrol('Parent',hPanel_GeneratePictures, 'Style', 'pushbutton', 'String', 'Generate One Picture', 'Position', [48 250 202 25],...
        'Callback', @Btn_GenerateOnePictureFcn);  
Btn_GenerateAllPictures = uicontrol('Parent',hPanel_GeneratePictures, 'Style', 'pushbutton', 'String', 'Generate All Pictures', 'Position', [48 200 202 25],...
        'Callback', @Btn_GenerateAllPicturesFcn);  
  
% Add a label for Saving Directory
Text_Saving_Directory = uicontrol('Parent',hPanel_GeneratePictures, 'Style','text', 'Position',[20 140 100 16], 'HorizontalAlignment','Left', 'String','Saving Directory', 'BackgroundColor', 'White');

% Create a Editbox for Saving Directory
Edit_SavingDirectory =  uicontrol('Parent',hPanel_GeneratePictures, 'Style','edit', 'String','', 'Position',[20 110 258 25], 'Enable','off',...
        'Callback', 'clc'); 
    
Btn_ChangeSavingDirectory = uicontrol('Parent',hPanel_GeneratePictures, 'Style', 'pushbutton', 'String', 'Change Saving Directory', 'Position', [148 78 132 25],...
        'Callback', @Btn_ChangeSavingDirectoryFcn); 

% Create a label for storage format
Text_StorageFormat = uicontrol('Parent',hPanel_GeneratePictures, 'Style','text', 'BackgroundColor', 'White', 'Position',[148 150 80 16], 'HorizontalAlignment','Left', 'String','Storage Format');
    
% Create pop-up menu
Popup_StorageFormat = uicontrol('Parent',hPanel_GeneratePictures, 'Style', 'popup', 'String',{'.bmp', '.jpg', '.png', '.tif'}, 'FontSize',8, 'Position', [228 162 50 8],...
           'Callback', @setmap);  

%------ initialize the Saving Directory -------
        %
        CurrentWorkingDirectory = fileparts(mfilename('fullpath'));
        picturesFolderName = 'PicturesFolder';
        picturesPath = sprintf('%s\\%s', CurrentWorkingDirectory, picturesFolderName);
        % if the folder for pictures does not exist, make a new one
        if ~exist(picturesPath) 
            mkdir(picturesPath);       
        end 
        % set the default pictures Path
        set(Edit_SavingDirectory, 'String', picturesPath);
%------ ------------------------- -------
       
% Figure "on"
set(hFigure1, 'Visible','on');







%% --- Fucntions ---
%-->Load Words Fucntion
    function Btn_LoadWordsFcn(hObject, eventdata, handles)
        CurrentWorkingDirectory = fileparts(mfilename('fullpath'));
        textFolderName = 'TextFolder';
        textPathNames_forGetFile = sprintf('%s\\%s\\*.txt', CurrentWorkingDirectory, textFolderName);
        [txtFileName, txtPath] = uigetfile(textPathNames_forGetFile, 'Pick a .txt File to load the words list in it!');
        txtPathName = sprintf('%s%s', txtPath, txtFileName);
        set(Edit_PathName_txtFile, 'String', txtPathName);
        try
            [WordsArray] = textread(txtPathName, '%s', 'delimiter', '\n');
            set(Edit_WordsList, 'String', WordsArray);
        catch
            fprintf('File not found!\n');
        end
        
    end

%-->Font Set Fucntion
    function Btn_FontSetFcn(hObject, eventdata, handles)
        sFont = uisetfont(sFont);
        tmpFontString = sprintf('Name:%s; Weight:%s; Size:%d', sFont.FontName, sFont.FontWeight, sFont.FontSize);
        set(Edit_FontSet, 'String', tmpFontString);
    end

%-->Font Color Function
    function Btn_FontColorFcn(hObject, eventdata, handles)
        fColor = uisetcolor(fColor);
        tmpColorString = sprintf('R:%d; G:%d; B:%d', fColor(1) * 255, fColor(2) * 255, fColor(3) * 255);
        set(Edit_FontColor, 'String', tmpColorString);
    end

%-->Background Color Function
    function Btn_BKGColorFcn(hObject, eventdata, handles)
        bkgColor = uisetcolor(bkgColor);
        tmpColorStringBKG = sprintf('R:%d; G:%d; B:%d', bkgColor(1) * 255, bkgColor(2) * 255, bkgColor(3) * 255);
        set(Edit_BKGColor, 'String', tmpColorStringBKG);
    end

%-->Radio Left Function
    function RadioBtnLeftFcn(hObject, eventdata, handles)
        set(RadiobuttonLeft, 'Value', 1);
        set(RadiobuttonMiddle, 'Value', 0);
        set(RadiobuttonRight, 'Value', 0);
        set(Edit_Aligh, 'String', 'L');
    end

%-->Radio Middle Function
    function RadioBtnMiddleFcn(hObject, eventdata, handles)
        set(RadiobuttonLeft, 'Value', 0);
        set(RadiobuttonMiddle, 'Value', 1);
        set(RadiobuttonRight, 'Value', 0);
        set(Edit_Aligh, 'String', 'M');
    end

%-->Radio Right Function
    function RadioRightFcn(hObject, eventdata, handles)
        set(RadiobuttonLeft, 'Value', 0);
        set(RadiobuttonMiddle, 'Value', 0);
        set(RadiobuttonRight, 'Value', 1);
        set(Edit_Aligh, 'String', 'R');
    end

%-->CounterClockwise Function
    function Btn_CounterClockwiseFcn(hObject, eventdata, handles)
        tmpString = get(Edit_Angle, 'String');
        AngleValue = str2num(tmpString);
        AngleValue = AngleValue - 10;
        if AngleValue < 0
           AngleValue = AngleValue + 360; 
        end
        tmpAngleString = sprintf('%.1f', AngleValue);
        set(Edit_Angle, 'String', tmpAngleString);
    end

%-->Clockwise Function
    function Btn_ClockwiseFcn(hObject, eventdata, handles)
        tmpString = get(Edit_Angle, 'String');
        AngleValue = str2num(tmpString);
        AngleValue = AngleValue + 10;
        if AngleValue > 360
           AngleValue = AngleValue - 360; 
        end
        tmpAngleString = sprintf('%.1f', AngleValue);
        set(Edit_Angle, 'String', tmpAngleString);
    end

%-->Restore Function
    function Btn_RestoreFcn(hObject, eventdata, handles)
%
        set(Edit_FontSet, 'String', 'Name:Arial; Weight:normal; Size:36');   
        set(Edit_FontColor, 'String', 'R:255; G:255; B:255');
        set(Edit_BKGColor, 'String', 'R:0; G:0; B:0');
        
%
        set(Edit_Width, 'String', 200);
        set(Edit_Height, 'String', 200);

%
        set(RadiobuttonLeft, 'Value', 0);
        set(RadiobuttonMiddle, 'Value', 1);
        set(RadiobuttonRight, 'Value', 0);
        set(Edit_Aligh, 'String', 'M');

%
        Angle_Variable = 0;
        tmpAngleString = sprintf('%.1f', Angle_Variable);
        set(Edit_Angle, 'String',  tmpAngleString);

    end

%-->ChangeSavingDirectory Function
    function Btn_ChangeSavingDirectoryFcn(hObject, eventdata, handles)
        CurrentWorkingDirectory = fileparts(mfilename('fullpath'));
        ChangePath = uigetdir(CurrentWorkingDirectory);
        set(Edit_SavingDirectory, 'String', ChangePath);
    end

%-->PreviewOnePicture Function
    function Btn_PreviewOnePictureFcn(hObject, eventdata, handles)
        % get the angle parameter
        cAngleValue = str2num(get(Edit_Angle, 'String'));
        if cAngleValue > 0
            set(RadiobuttonLeft, 'Value',0);
            set(RadiobuttonMiddle, 'Value',1);
            set(RadiobuttonRight, 'Value',0);
            set(Edit_Aligh, 'String','M');
        end
        
        % get the Width and Height
        rWidth = str2num(get(Edit_Width,'String'));
        rHeight = str2num(get(Edit_Height,'String'));
        
        ratio_RealvsView = max(rWidth, rHeight)/200;
%         
%         cWidth = rWidth/ratio_RealvsView;
%         cHeight = rHeight/ratio_RealvsView;
        
        % get the Align info. 
        if get(RadiobuttonLeft,'Value')
            cAlign = 'left';
        elseif get(RadiobuttonMiddle,'Value')
            cAlign = 'center';
        elseif get(RadiobuttonRight,'Value')
            cAlign = 'right';
        end
        
        % prepare the Background Canvas
        BKGCanvas = zeros(rHeight, rWidth, 3);
        BKGCanvas(:,:,1) = bkgColor(1);
        BKGCanvas(:,:,2) = bkgColor(2);
        BKGCanvas(:,:,3) = bkgColor(3);
        
        % create a new figure: hFigure2, note the +20 +20, and the 10 10 (figure border larger than axes border!)
        hFigure2 = figure('position', [0 0 rWidth+20 rHeight+20]);
        figure(hFigure2);
        hAxes_Original = axes('visible','off', 'units','pixels', 'position',[10 10 rWidth rHeight], 'ytick',[], 'xtick',[]);
        axes(hAxes_Original);
        imshow(BKGCanvas, 'Parent', hAxes_Original);
        set(hFigure2,'visible','off');
                  
        % 3 
        %
        WordsList_Cells = get(Edit_WordsList, 'String');
        cWord = WordsList_Cells{WordIndex};
        cFontName = sFont.FontName;
        cFontSize = sFont.FontSize;
        cFontWeight = sFont.FontUnits;
        if strcmp(cFontWeight,'normalized') == 1
            cFontWeight = 'normal';
        else
            cFontWeight = 'bold';
        end
        
        cAngleValue = 360 - cAngleValue; 
        printWord = text(rWidth/2, rHeight/2, cWord, 'fontname',cFontName, 'HorizontalAlignment',cAlign, 'fontsize',cFontSize, 'fontweight',cFontWeight, 'color',fColor, 'parent',hAxes_Original, 'visible','on', 'units','pixels');
        set(printWord, 'rotation',cAngleValue);
        
        axesFrame = getframe(hAxes_Original, [0 0 rWidth rHeight]);
        imgMatrix = axesFrame.cdata;
        axes(hAxes_Preview);
        imshow(imgMatrix, 'Parent', hAxes_Preview);
        close(hFigure2);
        
    end

%-->Btn_Previous Function
    function Btn_PreviousFcn(hObject, eventdata, handles)
        if WordIndex > 1
            WordIndex = WordIndex - 1;
        end
        Btn_PreviewOnePictureFcn();
    end

%-->Btn_Posterior Function
    function Btn_PosteriorFcn(hObject, eventdata, handles)
        if WordIndex < WordNumber
            WordIndex = WordIndex + 1;
        end
        Btn_PreviewOnePictureFcn();
    end

%-->Btn_GenerateOnePictureFcn Function
    function Btn_GenerateOnePictureFcn(hObject, eventdata, handles)
        % get the angle parameter
        cAngleValue = str2num(get(Edit_Angle, 'String'));
        if cAngleValue > 0
            set(RadiobuttonLeft, 'Value',0);
            set(RadiobuttonMiddle, 'Value',1);
            set(RadiobuttonRight, 'Value',0);
            set(Edit_Aligh, 'String','M');
        end
        
        % get the Width and Height
        rWidth = str2num(get(Edit_Width,'String'));
        rHeight = str2num(get(Edit_Height,'String'));
        
        ratio_RealvsView = max(rWidth, rHeight)/200;
        
        % get the Align info. 
        if get(RadiobuttonLeft,'Value')
            cAlign = 'left';
        elseif get(RadiobuttonMiddle,'Value')
            cAlign = 'center'
        elseif get(RadiobuttonRight,'Value')
            cAlign = 'right'
        end
        
        %
        BKGCanvas = zeros(rHeight, rWidth, 3);
        BKGCanvas(:,:,1) = bkgColor(1);
        BKGCanvas(:,:,2) = bkgColor(2);
        BKGCanvas(:,:,3) = bkgColor(3);
        
        hFigure3 = figure('position', [0 0 rWidth+20 rHeight+20]);
        figure(hFigure3);
        hAxes_Original = axes('visible','off', 'units','pixels', 'position',[10 10 rWidth rHeight], 'ytick',[], 'xtick',[]);
        axes(hAxes_Original);
        imshow(BKGCanvas, 'Parent', hAxes_Original);
        set(hFigure3, 'visible','off');
        
        % 3 
        %
        
        WordsList_Cells = get(Edit_WordsList, 'String');
        cWord = WordsList_Cells{WordIndex};
        cFontName = sFont.FontName;
        cFontSize = sFont.FontSize;
        cFontWeight = sFont.FontUnits;
        if strcmp(cFontWeight,'normalized') == 1
            cFontWeight = 'normal';
        else
            cFontWeight = 'bold';
        end
        
        cAngleValue = 360 - cAngleValue; 
        printWord = text(rWidth/2, rHeight/2, cWord, 'fontname',cFontName, 'HorizontalAlignment',cAlign, 'fontsize',cFontSize, 'fontweight',cFontWeight, 'color',fColor, 'parent',hAxes_Original, 'visible','on', 'units','pixels');
        set(printWord, 'rotation',cAngleValue);
        
        axesFrame = getframe(hAxes_Original, [0 0 rWidth rHeight]);
        imgMatrix = axesFrame.cdata;
        axes(hAxes_Preview);
        imshow(imgMatrix, 'Parent', hAxes_Preview);
        
        %
        SavingPath = get(Edit_SavingDirectory,'String');
        PopupStringsList = get(Popup_StorageFormat,'String');
        PopupValue = get(Popup_StorageFormat,'Value');
        cFileExtention = PopupStringsList{PopupValue};
        
        pictureFileName = sprintf('%s%s', cWord, cFileExtention);
        picturePath = get(Edit_SavingDirectory, 'String');
        picturePathName = sprintf('%s\\%s', picturePath, pictureFileName);
        
        
        switch cFileExtention
            case '.bmp'
                imwrite(imgMatrix, picturePathName, 'BMP');
%                 print(newf,'-dbmp',picturePathName);
%                 delete(newf);

            case '.jpg'
                imwrite(imgMatrix, picturePathName, 'JPEG');
            case '.png'
                imwrite(imgMatrix, picturePathName, 'PNG');
            case '.tif'
                imwrite(imgMatrix, picturePathName, 'TIFF');
        end
        
        close(hFigure3);
    end

%-->Btn_GenerateAllPictures Function
    function Btn_GenerateAllPicturesFcn(hObject, eventdata, handles)
%         tmpWordIndex = WordIndex;
        for i = 1:WordNumber
            WordIndex = i;
            Btn_GenerateOnePictureFcn();
        end
%         WordIndex = tmpWordIndex;
    
    end
end
