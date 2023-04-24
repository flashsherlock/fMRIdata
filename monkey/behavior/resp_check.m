function varargout = resp_check(varargin)
% GuFei 2023/04/23

% Begin initialization code - DO NOT EDIT
% 0-allow more than one widow 1-only one window
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @resp_checkOpeningFcn, ...
                   'gui_OutputFcn',  @resp_checkOutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
%% functions of components
% --- Executes just before respir is made visible.
function resp_checkOpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to respir (see VARARGIN)

% change path
workingpath='/Volumes/WD_D/gufei/monkey_data/respiratory/adinstrument';
% set workingpath
set(handles.path,'String',workingpath);
handles.workingpath=workingpath;
if exist([handles.workingpath filesep 'trials.mat'],'file')
    % the first file is default file
    handles.filename=[handles.workingpath filesep 'trials.mat'];
    set(handles.load,'Enable','on');
else
    set(handles.load,'Enable','off');
end
% plot matlab icon
LL=40*membrane(1,25);
surfl(LL)
shading interp
axis off
% disable buttons
handles=setbuttons(handles,'off');
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes respir wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = resp_checkOutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
%
% set keyboard shortcuts
% disp(eventdata.Key);
switch eventdata.Key
    % press d or leftarrow to move left
    case {'leftarrow','d'}
    if strcmp(get(handles.left,'Enable'),'on')
        if handles.plotnum>1
        handles.plotnum=handles.plotnum-1;
        set(handles.currentnum,'String',num2str(handles.plotnum));
        set(handles.position,'Value',handles.plotnum);
        plotcurrentnum(handles.tempdata(handles.plotnum,:,:),handles.chanplot,handles.curchan,handles.curp);
        end
    end
    % press f or rightarrow to move right
    case {'rightarrow','f'}
    if strcmp(get(handles.right,'Enable'),'on')
        if handles.plotnum<handles.resnum
        handles.plotnum=handles.plotnum+1;
        set(handles.currentnum,'String',num2str(handles.plotnum));
        set(handles.position,'Value',handles.plotnum);
        plotcurrentnum(handles.tempdata(handles.plotnum,:,:),handles.chanplot,handles.curchan,handles.curp);
        end
    end
    % press v or downarrow to choose point
    case {'downarrow','v'}
    if strcmp(get(handles.choose,'Enable'),'on')
        handles=choosepoint(handles);
    end
    % press s to save the data
    case 's'
    guisave=handles.guisave;
    data=handles.tempdata;
    % save the data without smooth
    data(:,1)=handles.nosmooth;
    % save parameters used to find points
    parameters=handles.usepara;
    save([handles.workingpath '/' handles.savename '.mat'],'data','guisave','parameters');
end
guidata(hObject, handles);



% --- Executes on button press in choose.
function choose_Callback(hObject, eventdata, handles)
% hObject    handle to choose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% choose point on the figure
handles=choosepoint(handles);
% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% interplay with two other buttons
if get(hObject,'Value')
    set(handles.stop,'Value',0);
    handles.choosetype='start';
    set(handles.choose,'Enable','on');
    set(handles.stop,'BackgroundColor',[0.94,0.94,0.94]);
    set(handles.start,'BackgroundColor','green');    
else
    handles.choosetype='';
    set(handles.choose,'Enable','off');
    set(hObject,'BackgroundColor',[0.94,0.94,0.94]);
end
handles=updatepoint(handles);

guidata(hObject, handles);

% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% interplay with two other buttons
if get(hObject,'Value')
    set(handles.start,'Value',0);
    handles.choosetype='stop';
    set(handles.choose,'Enable','on');
    set(handles.start,'BackgroundColor',[0.94,0.94,0.94]);
    set(handles.stop,'BackgroundColor','green');
else
    handles.choosetype='';
    set(handles.choose,'Enable','off');
    set(hObject,'BackgroundColor',[0.94,0.94,0.94]);
end
handles=updatepoint(handles);
guidata(hObject, handles);


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% save data to mat
trials=handles.tempdata;
save(handles.savename,'trials');


% --- Executes during object creation, after setting all properties.
function path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function path_Callback(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% set path by txt
handles.workingpath=get(hObject,'String');
if exist([handles.workingpath filesep 'trials.mat'],'file')
    % the first file is default file
    handles.filename=[handles.workingpath filesep 'trials.mat'];
    set(handles.load,'Enable','on');
else
    set(handles.load,'Enable','off');
end
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of path as text
%        str2double(get(hObject,'String')) returns contents of path as a double

% --- Executes on button press in setpath.
function setpath_Callback(hObject, eventdata, handles)
% hObject    handle to setpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% set path by gui
temp= uigetdir('*.*','Choose a folder');
% ensure temp is not 0
if temp~=0
    % set path
    handles.workingpath=temp;
    set(handles.path,'String',handles.workingpath);
    % filename
    if exist([handles.workingpath filesep 'trials.mat'],'file')
        % the first file is default file
        handles.filename=[handles.workingpath filesep 'trials.mat'];
        set(handles.load,'Enable','on');
    else
        set(handles.load,'Enable','off');
    end
    guidata(hObject, handles);
end

%% load data
% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% load the data
if ~isempty(handles.filename)

    load(handles.filename)
    % store data in handles.tempdata
    handles.tempdata=trials;
    % enable buttons
    handles=setbuttons(handles,'on');
    % set name of the file to be saved
    handles.savename=[handles.filename(1:end-4) '_edited.mat'];
    % find the number of trials
    handles.resnum=size(trials,1);
    handles.channum=size(trials,3);
    % channels to be ploted
    handles.chanplot=1:2;    
    % set the scollbar and textbox
    set(handles.allnum,'String',num2str(handles.resnum));
    set(handles.channel,'String',num2cell(1:handles.channum));    
    set(handles.position,'Max',handles.resnum);
    set(handles.position,'Value',1);
    set(handles.position,'SliderStep',[1/(handles.resnum-1),1]);
    % plotnum is the position to be ploted
    handles.plotnum=1;
    set(handles.currentnum,'String','1');
    handles.curchan=get(handles.channel,'Value');    
    handles.curp='';
    handles.ptype='change';
    % plot
    plotcurrentnum(handles.tempdata(handles.plotnum,:,:),handles.chanplot,handles.curchan,handles.curp);
end
guidata(hObject, handles);

% --- Executes on button press in left.
function left_Callback(hObject, eventdata, handles)
% hObject    handle to left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% move left
if handles.plotnum>1
    handles.plotnum=handles.plotnum-1;
    set(handles.currentnum,'String',num2str(handles.plotnum));
    set(handles.position,'Value',handles.plotnum);
    handles=updatepoint(handles);
end
guidata(hObject, handles);

% --- Executes on button press in right.
function right_Callback(hObject, eventdata, handles)
% hObject    handle to right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% move right
if handles.plotnum<handles.resnum
    handles.plotnum=handles.plotnum+1;
    set(handles.currentnum,'String',num2str(handles.plotnum));
    set(handles.position,'Value',handles.plotnum);
    handles=updatepoint(handles);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function currentnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
%
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function currentnum_Callback(hObject, eventdata, handles)
% hObject    handle to currentnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% edit the number to set position
num=str2num(get(hObject,'String'));
if num>=1 && num <=handles.resnum
    handles.plotnum=num;
    set(handles.position,'Value',handles.plotnum);
    handles=updatepoint(handles);
else
    set(handles.currentnum,'String',num2str(handles.plotnum));
end
guidata(hObject, handles);

% --- Executes on slider movement.
function position_Callback(hObject, eventdata, handles)
% hObject    handle to position (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% use the scollbar to set position
handles.plotnum=ceil(get(hObject,'Value'));
set(handles.position,'Value',handles.plotnum);
set(handles.currentnum,'String',handles.plotnum);
handles=updatepoint(handles);
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% --- Executes during object creation, after setting all properties.
function position_CreateFcn(hObject, eventdata, handles)
% hObject    handle to position (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% clear chosen point
if get(hObject,'Value')
    set(handles.add,'Value',0);
    handles.ptype='clear';
    set(handles.add,'BackgroundColor',[0.94,0.94,0.94]);
    set(handles.clear,'BackgroundColor','green');    
else
    handles.ptype='change';
    set(hObject,'BackgroundColor',[0.94,0.94,0.94]);
end

guidata(hObject, handles);


% --- Executes on button press in add.
function add_Callback(hObject, eventdata, handles)
% hObject    handle to add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% add a respiration
if get(hObject,'Value')
    set(handles.clear,'Value',0);
    handles.ptype='add';
    set(handles.clear,'BackgroundColor',[0.94,0.94,0.94]);
    set(handles.add,'BackgroundColor','green');    
else
    handles.ptype='change';
    set(hObject,'BackgroundColor',[0.94,0.94,0.94]);
end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function plot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate plot

% --- Executes on selection change in data.
function data_Callback(hObject, eventdata, handles)
% hObject    handle to data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% set the listbox
% if click a file in the listbox enable the load button
s = get(hObject,'String');
if isempty(s)
    handles.curp = '';
else
    handles.curp = s{get(hObject,'Value')};
end
plotcurrentnum(handles.tempdata(handles.plotnum,:,:),handles.chanplot,handles.curchan,handles.curp);

guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns data contents as cell array
%        contents{get(hObject,'Value')} returns selected item from data

% --- Executes during object creation, after setting all properties.
function data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in channel.
function channel_Callback(hObject, eventdata, handles)
% hObject    handle to channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=updatepoint(handles);

guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns channel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from channel


% --- Executes during object creation, after setting all properties.
function channel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% other functions
% plot current data
function plotcurrentnum(separated,chan,c,p)
% c and p are channel and point that currently edit
trial_i = 1;
p_data = cat(1,separated{trial_i,1,chan});
p_time = (1:size(p_data,2))-1;
if size(p_data,1)<length(chan)
    plot([1,-1;-1,1],'Color','k')
else
    % plot inhalation    
    for channel_resp = chan
        if channel_resp == c
            color=[0 0.74902 1];
            psize=10;
            lw=2;
        else
            color=[0.5 0.5 0.5];
            psize=5;
            lw=1;
        end
        plot(p_time,p_data(channel_resp,:),'Color',color,'LineWidth',lw);
        hold on;
        onpoint = nan(size(p_data,2),1);
        onpoint(separated{trial_i,2,channel_resp})=p_data(channel_resp,separated{trial_i,2,channel_resp});    
        offpoint = nan(size(p_data,2),1);
        offpoint(separated{trial_i,3,channel_resp})=p_data(channel_resp,separated{trial_i,3,channel_resp});
        plot(onpoint,'>','MarkerFaceColor','g','MarkerSize',psize);
        plot(offpoint,'^','MarkerFaceColor','k','MarkerSize',psize);
    end
    % plot 0
    hh=axis;
    plot([hh(1) hh(2)],[0 0],'k--','LineWidth',1)
    if ~isempty(str2num(p))        
        plot([str2num(p) str2num(p)],[hh(3) hh(4)],'r--','LineWidth',1)
    end
    xlim([p_time(1) p_time(end)]);
    % set major tick
    set(gca,'XTick',p_time(1):1000:p_time(end));
    set(gca,'XGrid','on');
    set(gca,'XMinorGrid','on');
    t = [separated{trial_i,5,1} ': odor-' num2str(separated{trial_i,4,1})];
    title(t,'Interpreter','none','Fontsize',12,'LineWidth',3);
    hold off
end

% choose respiration point
function newhandle=choosepoint(handles)

if get(handles.start,'Value')
    time = 2;
elseif get(handles.stop,'Value')
    time = 3;
else
    time = 0;
end

if time~=0
    points = handles.tempdata{handles.plotnum,time,handles.curchan};
    data = handles.tempdata{handles.plotnum,1,handles.curchan};
    % choose axes
    axes(handles.plot);
    % select point
    [x,~]=ginput(1);
    % use integer
    x=floor(x);
    % display(x);
    xmax = 14000;
    xmin = 0;
    % if the point is in the range
    if x>=1 && x<=xmax-xmin+1
        newx=xmin+x-1;
        % set a range to find min and max
        range=75;
        % get the range, min and max
        left=max(1,newx-range);
        right=min(1+xmax,newx+range);
        % find zero point
        if time == 2
            zero=left-1+find(data(left:right)>0,1,'first')-1;
        else
            zero=left-1+find(data(left:right)>0,1,'last')-1;
        end
        if ~isempty(zero)
            newx = zero;
        end
        % change points
        switch handles.ptype
            case 'change'
                % delete current point
                points(points==str2num(handles.curp))=[];
                % add new
                points=sort([points newx]);
            case 'add'
                if ~ismember(newx,points)
                    points=sort([points newx]);
                end
            case 'clear'
                points(abs(points-newx)==min(abs(points-newx)))=[];
        end
        % change matix to a column
        handles.tempdata{handles.plotnum,time,handles.curchan}=points;
        % plot
        handles=updatepoint(handles);        
    end
    newhandle=handles;
end

% update points
function newhandle=updatepoint(handles)
if get(handles.start,'Value')
    time = 2;
elseif get(handles.stop,'Value')
    time = 3;
else
    time = 0;
end
handles.curchan = get(handles.channel,'Value');
if time~=0
    set(handles.data,'String',num2cell(handles.tempdata{handles.plotnum,time,handles.curchan}));
else
    set(handles.data,'String','');
end
s = get(handles.data,'String');
if isempty(s)
    handles.curp = '';
else
    set(handles.data,'Value',min([get(handles.data,'Value'),length(s)]));
    handles.curp = s{get(handles.data,'Value')};
end
plotcurrentnum(handles.tempdata(handles.plotnum,:,:),handles.chanplot,handles.curchan,handles.curp);
newhandle = handles;



% set button status
function newhandle=setbuttons(handles,status)
set(handles.clear,'Enable',status);
set(handles.add,'Enable',status);
set(handles.save,'Enable',status);
set(handles.start,'Enable',status);
set(handles.stop,'Enable',status);
set(handles.position,'Enable',status);
set(handles.left,'Enable',status);
set(handles.right,'Enable',status);
set(handles.currentnum,'Enable',status);
set(handles.allnum,'Enable',status);
newhandle=handles;
