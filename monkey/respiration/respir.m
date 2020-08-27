function varargout = respir(varargin)
% RESPIR MATLAB code for respir.fig
%      RESPIR, by itself, creates a new RESPIR or raises the existing
%      singleton*.
%
%      H = RESPIR returns the handle to a new RESPIR or the handle to
%      the existing singleton*.
%
%      RESPIR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESPIR.M with the given input arguments.
%
%      RESPIR('Property','Value',...) creates a new RESPIR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before respir_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to respir_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
% GuFei 2020/07/20
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help respir

% Last Modified by GUIDE v2.5 26-Aug-2020 17:44:32

% Begin initialization code - DO NOT EDIT
% 0-allow more than one widow 1-only one window
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @respir_OpeningFcn, ...
                   'gui_OutputFcn',  @respir_OutputFcn, ...
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
%% readme
%
% Important variables in this programm.
% 
% | handles.      | Meaning                                   |
% | ---------     | -------                                   |
% | workingpath   | working directory                         |
% | datatype      | 'acq' or 'mat'                            |
% | choosetype    | which kind of point(start,peak,stop)      |
% | filename      | current filename                          |
% | savename      | filename of the file to be saved          |
% | findpara      | initial(dfault) parameters for findres    |
% | usepara       | parameters saved when use for findres     |
% | plotnum       | index of current respiration(plot)        |
% | resnum        | total number of respirations              |
% | tempdata      | data edited in this GUI                   |
% | points        | a matrix storing respiration points       |
% | guisave       | initial data loaded                       |
% 
% Range to find local minimum values for choosing points manually is 15.
% 
% Objects on the GUI
% 
% | handles.   | Object                       | handles.   | Object                               |
% | ---------  | -------                      | ---------  | -------                              |
% | path       | enter working path           | clear      | delete current respiration           |
% | setpath    | set workingpath with GUI     | add        | add a respiration (start,peak,stop)  |
% | data       | data files in current folder | choose     | choose point manually (press 'v' key)|
% | mat        | toggle data type for .mat    | name       | filename for saving                  |
% | acq        | toggle data type for .acq    | save       | save data (press 's' key)            |
% | load       | load data                    | start      | change mode to find start            |
% | smoothtype | function used to smooth data | peak       | change mode to find peaks            |
% | winsize    | window size for smoothing    | stop       | change mode to find stop             |
% | smooth     | do smooth                    | position   | scroll bar to set position           |
% | seconds    | interval between peaks       | left       | previous respiration (press 'd' key) |
% | rate       | percent of height            | right      | next respiration (press 'f' key)     |
% | chmin      | whether find local minimum   | currentnum | current respiration number           |
% | rangestart | range for finding start      | allnum     | the number of total respiration      |
% | rangestop  | range for finding stop       | plot       | the axes                             |
% | find       | find points automatically    | plotall    | plot all data                        | 
%
%% functions of components
% --- Executes just before respir is made visible.
function respir_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to respir (see VARARGIN)

% change path
workingpath=fileparts(mfilename('fullpath'));
cd(workingpath);
% set workingpath
set(handles.path,'string',workingpath);
handles.workingpath=workingpath;
% set acq as default
handles.datatype='acq';
set(handles.acq,'Value',1);
set(handles.acq,'BackgroundColor','green');
% init list
data=list('.',handles.datatype);
set(handles.data,'string',data);
handles.filename=data{1};
% plot matlab icon
LL=40*membrane(1,25);
surfl(LL)
shading interp
axis off
% disable buttons
handles=setbuttons(handles,'off');
% default parameters for findres
handles.findpara=[3,0.15,1,50,50];
handles.usepara=handles.findpara;
% title('GUI tool for marking respiration','Fontsize',12)
% Choose default command line output for respir
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes respir wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = respir_OutputFcn(hObject, eventdata, handles)
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
        plotcurrentnum(handles.tempdata,handles.plotnum,handles.filename);
        end
    end
    % press f or rightarrow to move right
    case {'rightarrow','f'}
    if strcmp(get(handles.right,'Enable'),'on')
        if handles.plotnum<handles.resnum
        handles.plotnum=handles.plotnum+1;
        set(handles.currentnum,'String',num2str(handles.plotnum));
        set(handles.position,'Value',handles.plotnum);
        plotcurrentnum(handles.tempdata,handles.plotnum,handles.filename);
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
    % press z to restore smooth
    case 'z'
    handles.tempdata(:,1)=handles.nosmooth;
    plotcurrentnum(handles.tempdata,handles.plotnum,handles.filename);
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
    set(handles.peak,'Value',0);
    handles.choosetype='start';
    set(handles.choose,'Enable','on');
    set(handles.stop,'BackgroundColor',[0.94,0.94,0.94]);
    set(handles.peak,'BackgroundColor',[0.94,0.94,0.94]);
    set(handles.start,'BackgroundColor','green');
else
    handles.choosetype='';
    set(handles.choose,'Enable','off');
    set(hObject,'BackgroundColor',[0.94,0.94,0.94]);
end
guidata(hObject, handles);

function peak_Callback(hObject, eventdata, handles)
% hObject    handle to peak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% interplay with two other buttons
if get(hObject,'Value')
    set(handles.stop,'Value',0);
    set(handles.start,'Value',0);
    handles.choosetype='peak';
    set(handles.choose,'Enable','on');
    set(handles.stop,'BackgroundColor',[0.94,0.94,0.94]);
    set(handles.start,'BackgroundColor',[0.94,0.94,0.94]);
    set(handles.peak,'BackgroundColor','green');
else
    handles.choosetype='';
    set(handles.choose,'Enable','off');
    set(hObject,'BackgroundColor',[0.94,0.94,0.94]);
end
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
    set(handles.peak,'Value',0);
    handles.choosetype='stop';
    set(handles.choose,'Enable','on');
    set(handles.start,'BackgroundColor',[0.94,0.94,0.94]);
    set(handles.peak,'BackgroundColor',[0.94,0.94,0.94]);
    set(handles.stop,'BackgroundColor','green');
else
    handles.choosetype='';
    set(handles.choose,'Enable','off');
    set(hObject,'BackgroundColor',[0.94,0.94,0.94]);
end
guidata(hObject, handles);



% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% save data to mat
% guisave stores unedited respiration points
guisave=handles.guisave;
% save the data without smooth
data(:,1)=handles.nosmooth;
% save parameters used to find points
parameters=handles.usepara;
save([handles.workingpath '/' handles.savename '.mat'],'data','guisave','parameters');



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
% get data file list
data=list(handles.workingpath,handles.datatype);
% set display
set(handles.data,'string',data);
if ~isempty(data)
    % the first file is default file
    handles.filename=data{1};
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
    % set display of the listbox
    data=list(handles.workingpath,handles.datatype);
    set(handles.data,'string',data);
    % set the first file as default file if the list is not empty
    if ~isempty(data)
        handles.filename=data{1};
    else
        set(handles.load,'Enable','off');
    end
    guidata(hObject, handles);
end



% --- Executes on button press in acq.
function acq_Callback(hObject, eventdata, handles)
% hObject    handle to acq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% interplay with mat button
if get(hObject,'Value')
    set(handles.mat,'Value',0);
    handles.datatype='acq';
    set(handles.mat,'BackgroundColor',[0.94,0.94,0.94]);
    set(handles.acq,'BackgroundColor','green');
else
    set(handles.mat,'Value',1);
    handles.datatype='mat';
    set(handles.mat,'BackgroundColor','green');
    set(handles.acq,'BackgroundColor',[0.94,0.94,0.94]);
end
% update filename list
data=list(handles.workingpath,handles.datatype);
set(handles.data,'string',data);
% set the first file as defaut file if the list is not empty
if ~isempty(data)
    set(handles.data,'Value',1);
    handles.filename=data{1};
end
guidata(hObject, handles);


% --- Executes on button press in mat.
function mat_Callback(hObject, eventdata, handles)
% hObject    handle to mat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% interplay with acq button
if get(hObject,'Value')
    set(handles.acq,'Value',0);
    handles.datatype='mat';
    set(handles.acq,'BackgroundColor',[0.94,0.94,0.94]);
    set(handles.mat,'BackgroundColor','green');
else
    set(handles.acq,'Value',1);
    handles.datatype='acq';
    set(handles.mat,'BackgroundColor',[0.94,0.94,0.94]);
    set(handles.acq,'BackgroundColor','green');
end
% update filename list
data=list(handles.workingpath,handles.datatype);
set(handles.data,'string',data);
% set the first file as defaut file if the list is not empty
if ~isempty(data)
    set(handles.data,'Value',1);
    handles.filename=data{1};
    % check mat file, if guisave exist then it was created by this gui
    if strcmp(handles.datatype,'mat')
          load([handles.workingpath,'/',handles.filename]);
          % prevent loading it if it is not created by this gui
          if ~exist('guisave','var')
              set(handles.load,'Enable','off');
          end
    end
end
guidata(hObject, handles);

%% load data
% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% load the data
if ~isempty(handles.filename)

    switch handles.datatype
        % load mat data
        case 'mat'
            load([handles.workingpath,'/',handles.filename]);
        % load acq data
        case 'acq'
            alldata=load_acq([handles.workingpath '/' handles.filename]);
            % translate event markers
            [data,error]=marker_trans(alldata.data);
            % find respiration points automatically
            res=findres(data);
            data(:,3)=res;
            % display marker status, 0 means all right
            disp(error);
            % if no error, cut the data by event markers
            if error==0
                % 去掉首尾的部分减少工作量,先找到marker的首位和末位然后延伸
                % cut the data by first and last event marker
                first=find(data(:,2)~=0,1,'first');
                last=find(data(:,2)~=0,1,'last');
                % 前面取到上一个结束位置的后一个点
                % find the next point of nearest stop point at the beginning
                first2=find(data(1:first,3)==3,1,'last')+1;
                % 后面取到下一个开始位置的前一个点
                % find the point just before the start point at the end
                last2=last+find(data(last+1:end,3)==1,1,'first')-1;
                % use the data cut by event marker if could not find more respiration
                if ~isempty(first2)
                    first=first2;
                end
                if ~isempty(last2)
                    last=last2;
                end
                % cut the data
                data=data(first:last,:);
            end
    end
    % store data in handles.tempdata
    handles.tempdata=data;
    % store data without smooth
    handles.nosmooth=data(:,1);
    % enable buttons
    handles=setbuttons(handles,'on');
    % 设置保存的名称部分
    % set name of the file to be saved
    set(handles.name,'String',handles.filename(1:end-4));
    name_Callback(hObject, eventdata, handles)
    handles.savename=get(handles.name,'String');
    % 找到呼吸的数量
    % find the number of respirations-resnum
    handles.resnum=length(find(data(:,3)==2));
    % 初始化时间点的矩阵
    % store respiration points in a matrix
    handles.points=findpoints(data);
    % backup the matix in guisave
    handles.guisave=handles.points;

    % for debug
    % 用来调试转换是否正确
    % d=transmat(handles.points,length(data(:,3)));
    % if isequal(d,data(:,3))
    %     disp('OK');
    % end

    % 设置滚动条和数字显示
    % set the scollbar and textbox
    set(handles.allnum,'String',num2str(handles.resnum));
    set(handles.position,'Max',handles.resnum);
    set(handles.position,'Value',1);
    set(handles.position,'SliderStep',[1/(handles.resnum-1),1]);
    % 设置plot的位置
    % plotnum is the position to be ploted
    handles.plotnum=1;
    set(handles.currentnum,'String','1');
    % plot
    plotcurrentnum(handles.tempdata,handles.plotnum,handles.filename);
    % set start as default
    % set(handles.start,'Value',1);
    % handles.choosetype='start';
    % set(handles.start,'BackgroundColor','green');
end
guidata(hObject, handles);

%% find points automatically
function seconds_Callback(hObject, eventdata, handles)
% hObject    handle to seconds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% edit the number to set seconds for MPD
num=str2num(get(hObject,'String'));
% ensure it is above 0
if num>0
    set(hObject,'String',num);
    handles.findpara(1)=num;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function seconds_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seconds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function rate_Callback(hObject, eventdata, handles)
% hObject    handle to rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% edit the number to set rate of the height
num=str2num(get(hObject,'String'));
% ensure it is between 0 and 1
if num>0 && num <1
    set(hObject,'String',num);
    handles.findpara(2)=num;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in chmin.
function chmin_Callback(hObject, eventdata, handles)
% hObject    handle to chmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.findpara(3)=get(hObject,'Value');
if get(hObject,'Value')
    status='on';
else
    status='off';
end
set(handles.rangestart,'Enable',status);
set(handles.rangestop,'Enable',status);
guidata(hObject, handles);

function rangestart_Callback(hObject, eventdata, handles)
% hObject    handle to rangestart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% edit the number to set range for searching min
num=str2num(get(hObject,'String'));
% ensure it is integer
num=ceil(num);
% ensure it is above 0
if num>=0
    set(hObject,'String',num);
    handles.findpara(4)=num;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function rangestart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rangestart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function rangestop_Callback(hObject, eventdata, handles)
% hObject    handle to rangestop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% edit the number to set range for searching min
num=str2num(get(hObject,'String'));
% ensure it is integer
num=ceil(num);
% ensure it is above 0
if num>=0
    set(hObject,'String',num);
    handles.findpara(5)=num;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function rangestop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rangestop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function find_CreateFcn(hObject, eventdata, handles)
% hObject    handle to find (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in find.
% find respiration points automatically
function find_Callback(hObject, eventdata, handles)
% hObject    handle to find (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
usep=handles.findpara;
% find res points
handles.tempdata(:,3)=findres(handles.tempdata(:,1),usep(1),usep(2),usep(3),usep(4),usep(5));

% 找到呼吸的数量
% find the number of respirations-resnum
handles.resnum=length(find(handles.tempdata(:,3)==2));
% 初始化时间点的矩阵
% store respiration points in a matrix
handles.points=findpoints(handles.tempdata);

% 设置滚动条和数字显示
% set the scollbar and textbox
set(handles.allnum,'String',num2str(handles.resnum));
set(handles.position,'Max',handles.resnum);
set(handles.position,'Value',1);
% 设置plot的位置
% plotnum is the position to be ploted
handles.plotnum=1;
set(handles.currentnum,'String','1');
% plot
plotcurrentnum(handles.tempdata,handles.plotnum,handles.filename);

% save parameters used
handles.usepara=usep;
guidata(hObject, handles);


%% smooth data
% --- Executes on button press in smooth.
function smooth_Callback(hObject, eventdata, handles)
% hObject    handle to smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% smooth the data
win=str2num(get(handles.winsize,'String'));
type=get(handles.smoothtype,'String');
type=type{get(handles.smoothtype,'Value')};
switch type
    % use smooth function
    case 'smooth'
        handles.tempdata(:,1)=smooth(handles.nosmooth,win);
    % use filter function
    case 'filter'        
        b = (1/win)*ones(1,win);
        a = 1;
        handles.tempdata(:,1)=filter(b,a,handles.nosmooth);
    otherwise
        % restore smooth
        handles.tempdata(:,1)=handles.nosmooth;
end
% plot
plotcurrentnum(handles.tempdata,handles.plotnum,handles.filename);   
guidata(hObject, handles);

function winsize_Callback(hObject, eventdata, handles)
% hObject    handle to winsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% edit the number to set window size for smooth
num=str2num(get(hObject,'String'));
% ensure it is integer
num=ceil(num);
% ensure it is above 0
if num>0
    set(hObject,'String',num);    
end

% --- Executes during object creation, after setting all properties.
function winsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to winsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in smoothtype.
function smoothtype_Callback(hObject, eventdata, handles)
% hObject    handle to smoothtype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function smoothtype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smoothtype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% 
% --- Executes on button press in plotall.
function plotall_Callback(hObject, eventdata, handles)
% hObject    handle to plotall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% plot all data points
% plot in a new figure
figure;
set(gcf,'position',[0 150 3500 300])
plot(handles.tempdata(:,1));
% set title, avoid latex
title(handles.filename,'Interpreter','none','Fontsize',12,'LineWidth',3);
hold on
% plot respiration markers
resplot(handles.tempdata);



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
    plotcurrentnum(handles.tempdata,handles.plotnum,handles.filename);
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
    plotcurrentnum(handles.tempdata,handles.plotnum,handles.filename);
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
    plotcurrentnum(handles.tempdata,handles.plotnum,handles.filename);
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
plotcurrentnum(handles.tempdata,handles.plotnum,handles.filename);
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
    plotcurrentnum(handles.tempdata,handles.plotnum,handles.filename);
else
    % restore the respiration
    handles.points(handles.plotnum,4)=1;
    % plot
    plotcurrentnum(handles.tempdata,handles.plotnum,handles.filename);
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
    plotcurrentnum(handles.tempdata,handles.plotnum,handles.filename);
    % set display
    set(handles.allnum,'String',handles.resnum);
    set(handles.position,'Max',handles.resnum);
    set(handles.position,'Value',handles.plotnum);
    set(handles.currentnum,'String',handles.plotnum);
end
guidata(hObject, handles);

function name_Callback(hObject, eventdata, handles)
% hObject    handle to name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% set name of the file to be saved
handles.savename=get(handles.name,'String');
% check if the file already exist
if isempty(dir([handles.workingpath,'/',handles.savename,'.mat']))
    set(handles.save,'BackgroundColor','green');
else
    set(handles.save,'BackgroundColor','red');
end
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of name as text
%        str2double(get(hObject,'String')) returns contents of name as a double


% --- Executes during object creation, after setting all properties.
function name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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
set(handles.load,'Enable','on');
handles.filename=get(hObject,'String');
if ~isempty(handles.filename)
    handles.filename=handles.filename{get(hObject,'Value')};
    % find file numbers
    fnum=length(dir([handles.workingpath,'/',handles.filename(1:end-3) '*']));
    % if exist two files(acq and mat), set color of the load button to red
    switch fnum
        case 1
            set(handles.load,'BackgroundColor','green');
        case 2
            set(handles.load,'BackgroundColor','red');
    end
    % check if the mat file was saved by the gui by guisave
    if strcmp(handles.datatype,'mat')
        load([handles.workingpath,'/',handles.filename]);
        if ~exist('guisave','var')
            set(handles.load,'Enable','off');
        end
    end
end
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



%% other functions
% list files in the folder
function li=list(folder,type)
li=dir([folder '/*.' type]);
li=struct2cell(li);
li=li(1,:);

% plot respiration points
function resplot(data)
res=data(:,3);
%start
timepoint=nan(size(data,1),1);
start=find(res==1);
timepoint(start)=data(start,1);
plot(timepoint,'>','MarkerFaceColor','g','MarkerSize',10);
%stop
timepoint=nan(size(data,1),1);
stop=find(res==3);
timepoint(stop)=data(stop,1);
plot(timepoint,'<','MarkerFaceColor','r','MarkerSize',10);
%peak
timepoint=nan(size(data,1),1);
peak=find(res==2);
timepoint(peak)=data(peak,1);
plot(timepoint,'^','MarkerFaceColor','k','MarkerSize',10);

% 画出当前点的数据的函数
% plot current data
function plotcurrentnum(data,num,t)
% t-title
% 找到当前对应的数据段，以相邻的peak为边界
% cut the data by peaks
peak=find(data(:,3)==2);
len=length(peak);
% 考虑第一个和最后一个是不同的
% deal with the beginning and the end
if num==1
    left=1;
    right=peak(2);
elseif num==len
    left=peak(len-1);
    right=length(data(:,1));
else
    left=peak(num-1);
    right=peak(num+1);
end
% cut data
currentdata=data(left:right,:);
plot(currentdata(:,1),'LineWidth',3,'Color',[0 0.74902 1]);
% 设置坐标轴和标题
% set axis and title
axis([1 length(currentdata(:,1)) min(currentdata(:,1))-0.1 max(currentdata(:,1))+0.1])
% set(gca,'XTick',[]);
set(gca,'FontName','Times New Roman','FontSize',12);
title(t,'Interpreter','none','Fontsize',12,'LineWidth',3);
% 画上呼吸的点
hold on
resplot(currentdata);
hold off

% 初始时记录所有点的位置
% generate a matrix of respiration points
function points=findpoints(data)
allpeak=find(data(:,3)==2);
% 根据peak的数目选择
points=zeros(length(allpeak),4);
% 第四列表示这一组数是否有效
points(:,4)=1;
points(:,2)=allpeak;
% 记录当前的三个点,1-start,2-peak,3-stop
% 没有的点就是0
len=length(allpeak);
for i=1:len
    % 考虑第一个和最后一个是不同的
    % deal with the beginning and the end
    if i==1
        left=1;
        right=allpeak(2);
    elseif i==len
        left=allpeak(len-1);
        right=length(data(:,1));
    else
        left=allpeak(i-1);
        right=allpeak(i+1);
    end
    % find start between two peaks
    current=allpeak(i);
    start=find(data(left:current,3)==1)+left-1;
    % 0 means no start point
    if isempty(start)
        start=0;
    end
    % peak point
    peak=current;
    % find stop between two peaks
    stop=find(data(current:right,3)==3)+current-1;
    if isempty(stop)
    % 0 means no stop point
        stop=0;
    end
    points(i,1:3)=[start peak stop];
end

% 转换矩阵到一列
% change matrix to a column
function data=transmat(points,len)
% use valid data
points=points(points(:,4)~=0,1:3);
data=zeros(len,1);
for i=1:3
    % 去掉0
    % remove zeros
    p0=points(:,i);
    p0(p0==0)=[];
    % write data points
    data(p0)=i;
end

% 选择位置
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
% range of the x axis
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
        case 'peak'
            % find last max in the range
            newx=find(handles.tempdata(left:right,1)==maxdata,1,'first');
            % calculate position in the whole data
            newx=newx+left-1;
            % ensure the position is between start and stop
            if newx<=points(handles.plotnum,1) || newx>=points(handles.plotnum,3)
                newx=points(handles.plotnum,2);
            end
            points(handles.plotnum,2)=newx;
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
    plotcurrentnum(handles.tempdata,handles.plotnum,handles.filename);
    % update handles.points
    handles.points=findpoints(handles.tempdata);
    newhandle=handles;
end

% set button status
function newhandle=setbuttons(handles,status)
set(handles.plotall,'Enable',status);
set(handles.clear,'Enable',status);
set(handles.add,'Enable',status);
set(handles.name,'Enable',status);
set(handles.save,'Enable',status);
set(handles.start,'Enable',status);
set(handles.peak,'Enable',status);
set(handles.stop,'Enable',status);
set(handles.position,'Enable',status);
set(handles.left,'Enable',status);
set(handles.right,'Enable',status);
set(handles.currentnum,'Enable',status);
set(handles.allnum,'Enable',status);
set(handles.seconds,'Enable',status);
set(handles.rate,'Enable',status);
set(handles.chmin,'Enable',status);
set(handles.rangestart,'Enable',status);
set(handles.rangestop,'Enable',status);
set(handles.find,'Enable',status);
set(handles.smoothtype,'Enable',status);
set(handles.winsize,'Enable',status);
set(handles.smooth,'Enable',status);
newhandle=handles;
