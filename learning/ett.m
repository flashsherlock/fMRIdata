function ettport = ett(command, port, number)
%Control the ETT Olfactometer C
%   command-string,can be 'init','set','open', 'close' or 'read'.
%           init-Initialize the olfactometer. It must be run before others.
%           set-set valves.
%           open-open the port if it is closed when the serial port object.
%           has already been created. Otherwise, use 'init'.
%           close-close the port (all valves will be closed).
%           read-read all the unread feedback from the olfactometer.
%   port-the port name (e.g. 'COM1', only for 'init') 
%        or object (created by 'init'). Do nothing if it is 'test'.
%   number-matrix(only needed in 'set') that contains the number of 
%          valves to open, 0 means close all the valves.
% Gu Fei, 2020/07/18.

if nargin==2
    number=[];
end

% for debug
if strcmp(port,'test')
    ettport=port;
    return
end

% valve assignments (crucial)
init='@100,3,4,5,6,7,8,9,10,11,12,14,15,16!';

switch command
    case 'init'
        % delete(instrfindall('Type','serial'));
        
        ettport = serial(port,'BaudRate',19200);
        fopen(ettport);
        % wait for opening port
        pause(2);
        
        fwrite(ettport,init);
%         disp('Init done');
        
    case 'set'
        setvalve(port,number);
    case 'open'
        if ~strcmp(port.status,'open')
            fopen(port);
            pause(2);
        end
        fwrite(port,init);
    case 'close'
        fclose(port);
%         delete(port);
%         disp([inputname(2) ' has been closed and deleted.']);
    case 'read'
        if strcmp(port.status,'open')
            while port.BytesAvailable
            disp(fscanf(port));
            end
        end
    otherwise
        error(['undefined command: ' command]);
end

% function for setting valves
function setvalve(port,number)
    data='0,0,0,0,0,0,0,0,0,0,0,0';
    if number==0
        % write data        
        data=['@1,0,' data '!'];
        % fprintf(port,data);
        fwrite(port,data);
    else
        % change data
        for i=1:12
            if ismember(i,number);
                data(2*i-1)='1';
            end            
        end
        % write data        
        data=['@1,0,' data '!'];
        % fprintf(port,data);
        fwrite(port,data);
    end
end

end
