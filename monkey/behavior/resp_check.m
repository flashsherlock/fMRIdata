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
% clear the current respiration
% delete temporarily by changing the forth column
handles.points(handles.plotnum,4)=0;
temp=handles.tempdata;
temp(:,3)=transmat(handles.points,length(handles.tempdata(:,3)));
% deal with the end
if handles.plotnum==handles.resnum
   currentnum=handles.plotnum-1;
else
   currentnum=handles.plotnum;
end
% plot
plotcurrentnum(temp,currentnum,handles.filename);

% confirmation
answer=questdlg('Do you confirm？','Clear','Yes','No','No');
if strcmp(answer,'Yes')
    % delete the current respiration and update resnum
    handles.points(handles.plotnum,:)=[];
    handles.tempdata=temp;
    handles.resnum=handles.resnum-1;
    % set resnum
    set(handles.allnum,'String',handles.resnum);
    set(handles.position,'Max',handles.resnum);
    % set currentnum
    handles.plotnum=currentnum;
    set(handles.position,'Value',handles.plotnum);
    set(handles.currentnum,'String',handles.plotnum);
    % plot
    plotcurrentnum(handles.tempdata(handles.plotnum,:,:),handles.chanplot,handles.curchan,handles.curp);
else
    % restore the respiration
    handles.points(handles.plotnum,4)=1;
    % plot
    plotcurrentnum(handles.tempdata(handles.plotnum,:,:),handles.chanplot,handles.curchan,handles.curp);
end
guidata(hObject, handles);


% --- Executes on button press in add.
function add_Callback(hObject, eventdata, handles)
% hObject    handle to add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% add a respiration
% choose the axes
axes(handles.plot);
% select three points
[x,~]=ginput(3);
x=sort(floor(x));
points=handles.points(handles.points(:,4)~=0,:);
% the range of the x axis
% 考虑第一个和最后一个是不同的
% deal with the beginning and the end
if handles.plotnum==1
    xmin=1;
    xmax=points(handles.plotnum+1,2);
elseif handles.plotnum==handles.resnum
    xmin=points(handles.plotnum-1,2);
    xmax=length(handles.tempdata(:,1));
else
    xmin=points(handles.plotnum-1,2);
    xmax=points(handles.plotnum+1,2);
end

% if the point is in the range
if all(x>=1) && all(x<=xmax-xmin+1)
    % calculate the position in the whole data
    x=xmin+x-1;
    % transform to a row
    x=x';
    % campare the old and the new to set plotnum
    oldx=points(handles.plotnum,2);
    % add the points to the end and sortrows by the peaks
    points(end+1,:)=[x 1];
    points=sortrows(points,2);
    handles.points=points;
    % change matrix to a column
    handles.tempdata(:,3)=transmat(handles.points,length(handles.tempdata(:,3)));
    % change resnum, the count of respirations
    handles.resnum=handles.resnum+1;
    % ensure to plot the respiration added
    if x(2)>=oldx
        handles.plotnum=handles.plotnum+1;
    end
    % plot
    plotcurrentnum(handles.tempdata(handles.plotnum,:,:),handles.chanplot,handles.curchan,handles.curp);
    % set display
    set(handles.allnum,'String',handles.resnum);
    set(handles.position,'Max',handles.resnum);
    set(handles.position,'Value',handles.plotnum);
    set(handles.currentnum,'String',handles.plotnum);
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
        else
            color=[0.5 0.5 0.5];
            psize=5;
        end
        plot(p_time,p_data(channel_resp,:),'Color',color,'LineWidth',1.5);
        hold on;
        onpoint = nan(size(p_data,2),1);
        onpoint(separated{trial_i,2,channel_resp})=p_data(channel_resp,separated{trial_i,2,channel_resp});    
        offpoint = nan(size(p_data,2),1);
        offpoint(separated{trial_i,3,channel_resp})=p_data(channel_resp,separated{trial_i,3,channel_resp});
        plot(onpoint,'>','MarkerFaceColor','g','MarkerSize',psize);
        plot(offpoint,'^','MarkerFaceColor','k','MarkerSize',psize);
    end
    if ~isempty(str2num(p))
        hh=axis;
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
% choose axes
axes(handles.plot);
% select point
[x,~]=ginput(1);
% use integer
x=floor(x);
% display(x);
% temporarily store respiration ponts
points=handles.points(handles.points(:,4)~=0,:);

% if the point is in the range
if x>=1 && x<=xmax-xmin+1
    newx=xmin+x-1;
    % set a range to find min and max
    range=15;
    % get the range, min and max
    left=max(1,newx-range);
    right=min(length(handles.tempdata(:,3)),newx+range);
    mindata=min(handles.tempdata(left:right,1));
    maxdata=max(handles.tempdata(left:right,1));
    % change one of the three points
    switch handles.choosetype
        case 'start'
            % find last min in the range
            newx=find(handles.tempdata(left:right,1)==mindata,1,'last');
            % calculate position in the whole data
            newx=newx+left-1;
            % ensure the position is on the left of the peak
            if newx>=points(handles.plotnum,2)
                newx=handles.points(handles.plotnum,1);
            end
            points(handles.plotnum,1)=newx;
        case 'stop'
            % find last min in the range
            newx=find(handles.tempdata(left:right,1)==mindata,1,'first');
            % calculate position in the whole data
            newx=newx+left-1;
            % ensure the position is on the right of the peak
            if newx<=points(handles.plotnum,2)
                newx=handles.points(handles.plotnum,3);
            end
            points(handles.plotnum,3)=newx;
    end
    % change matix to a column
    handles.tempdata(:,3)=transmat(points,length(handles.tempdata(:,3)));
    % plot
    plotcurrentnum(handles.tempdata(handles.plotnum,:,:),handles.chanplot,handles.curchan,handles.curp);
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
    set(handles.data,'Value',min([handles.curp,length(s)]));
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
