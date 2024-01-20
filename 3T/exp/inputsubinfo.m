function [subject,runnum,order,NoiseColor] = inputsubinfo
prompt={'Enter subject number:','Enter run number:','Enter order number:','Enter dynamic noise color: [1:Red; 2:BlueGreen]'};
name='Experimental Information';
numlines=1;
defaultanswer={'s999','1','1','1'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
subject=answer{1};
runnum=answer{2};
order=answer{3};
NoiseColor=str2num(answer{4});
return