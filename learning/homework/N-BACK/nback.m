function varargout = nback(varargin)
% NBACK MATLAB code for nback.fig
%      NBACK, by itself, creates a new NBACK or raises the existing
%      singleton*.
%
%      H = NBACK returns the handle to a new NBACK or the handle to
%      the existing singleton*.
%
%      NBACK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NBACK.M with the given input arguments.
%
%      NBACK('Property','Value',...) creates a new NBACK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nback_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nback_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nback

% Last Modified by GUIDE v2.5 12-Jun-2016 17:02:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nback_OpeningFcn, ...
                   'gui_OutputFcn',  @nback_OutputFcn, ...
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


% --- Executes just before nback is made visible.
function nback_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to nback (see VARARGIN)
Path_cur=fileparts(mfilename('fullpath'));
cd(Path_cur);      %切换工作目录
handles.valn=1;
handles.valm=10;%初始值
set(handles.text1,'string','+');
%set(0,'RecursionLimit',500);
% Choose default command line output for nback
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes nback wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = nback_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.valn = get(hObject, 'Value');
%set(handles.text6,'string',['难度是' num2str(handles.valn)]);
% set(handles.text5,'style','pushbutton');
% set(handles.text5,'string','开始请按此处');
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.valm = 10*get(hObject, 'Value');
%set(handles.text7,'string',['数量是是' num2str(handles.valm)]);
% set(handles.text5,'style','pushbutton');
% set(handles.text5,'string','开始请按此处');
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%生成刺激矩阵

function [qian,Matrix1]=generate(obj,eventdata,handles)
n=handles.valn;%难度nback
m=handles.valm;%题目数量

shu=[1 2 3 4 5 6 7 8 9 0];
xuhao=[1:m];
qian=[];%前n个
now=[];%当前的数字
back=[];%前面的数字
answer=[];%回答相同是0（F），不同是1(J)
for i=1:n
    r=randperm(10);
    qian=[qian shu(r(1))];
end
for i=1:m
    r=randperm(10);
    now=[now shu(r(1))];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%增加相同的，否则相同的比较少
for i=1:(m*0.3)
    r=randperm(10);
    k=randperm(m-n);
    k=k(1)+n;
    now(k)=shu(r(1));
    now(k-n)=now(k);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
back=[qian,now(1:m-n)];
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%% 判断回答
for i=1:m
    if (now(i)==back(i))
        answer=[answer 0];
    else
        answer=[answer 1];
    end
end
Matrixt=[xuhao' now' back' answer'];     %最终矩阵生成
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%计算相同的数量
count=0;
for i=1:m
    if Matrixt(i,4)==0
        count=count+1;
    end
end
if count<=0.6*m&&count>=0.4*m
    Matrix1=Matrixt;
else
   [p,t]=generate(obj,eventdata,handles);
     Matrix1=t;
     qian=p;%更新qian
end
%save('Stimuli1.mat','Matrix1');




% --- Executes on button press in text5.
function text5_Callback(hObject, eventdata, handles)
% hObject    handle to text5 (see GCBO)
n=handles.valn;
m=handles.valm;
[qian,Matrix1]=generate(hObject, eventdata, handles);
%save('Stimuli1.mat','Matrix1');
set(handles.text5,'style','text');
set(handles.text5,'string','结果将出现在此处');
pause(0.5);
% set(handles.text1,'string','+');
% pause(0.5);
%---正式实验---
for i=1:n
    set(handles.text1,'string','+');
    pause(0.5);
    set(handles.text1,'string',num2str(qian(i)));    
    pause(1);
end
out_File=fopen([pwd '\\Result' num2str(n) '-back' '.txt'],'a+');       %打开输出文件
fprintf(out_File,'————%s————\r\n',datestr(now));
for j=1:m
    set(handles.text1,'string','+');
    pause(0.5);
    set(handles.text1,'string',num2str(Matrix1(j,2)));    
   pause ;
   key = get(handles.figure1,'CurrentKey');
 while 1
if strcmp(key,'f')|| strcmp(key,'j')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
break;
else
    pause;
    key = get(handles.figure1,'CurrentKey');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % a=compare(hObject, eventdata, handles,i,Matrix1);
  % else
   % set(handles.text5,'string','无反应');
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
end
 
 end
switch key
    case 'j'
        c=1;
    case 'f'
        c=0;
end
if c==Matrix1(j,4);
    set(handles.text5,'string','正确');
    acc=1;
else
    set(handles.text5,'string','错误');
    acc=0;       
end
out=[Matrix1(j,:) acc];     %正确率写入矩阵
    out_Line=sprintf('%.0f\t%.0f\t%.0f\t%.0f\t%.0f',out(1:5));      %输出单个Trial信息
    fprintf(out_File,'%s\r\n',out_Line);        %写入文件
end
fclose(out_File);       %关闭输出文件
pause(0.2);
set(handles.text1,'string',''); 
set(handles.text5,'style','pushbutton');
set(handles.text5,'string','重新开始请按此处');
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function a=compare(hObject, eventdata, handles,i,Matrix1)
%     key = get(handles.figure1,'CurrentKey');
% if strcmp(key,'f')||strcmp(key,'j')
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% switch key
%     case 'j'
%         c=0;
%     case 'f'
%         c=1;
% end
% if c==Matrix1(i,4);
%     set(handles.text5,'string','正确');a=1;
% else
%     set(handles.text5,'string','错误');a=0;
% end
% else a=compare(hObject, eventdata, handles,i,Matrix1);
% end
