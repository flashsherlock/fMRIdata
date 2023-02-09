function testchamber(i)
port = 'EFF0';

ioObject = io64;
status = io64(ioObject);
disp(status);
%if status = 0, the driver is working

address = hex2dec(port);
% data_out = 3;
% data_out is the trigger number
if i==0
io64(ioObject,address,0);
end
SmellTrigger(1,:) = [1 0 0]; % Chamber 1
SmellTrigger(2,:) = [0 1 0]; % Chamber 2
SmellTrigger(3,:) = [1 1 0]; % Chamber 3
SmellTrigger(4,:) = [0 0 1]; % Chamber 4
SmellTrigger(5,:) = [1 0 1]; % Chamber 5
SmellTrigger(6,:) = [0 1 1]; % Chamber 6
if i~=0
    if i<7
        Chamber=[SmellTrigger(i,:) 0 0 0]; % A
    elseif i<13
        Chamber=[0 0 0 SmellTrigger(i-6,:)]; % B
    end
    ChamberNum=bin2dec(num2str(Chamber(end:-1:1)));
    disp([i ChamberNum]);
    io64(ioObject,address,ChamberNum);
end 
end
