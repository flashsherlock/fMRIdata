function [subject,runnum] = inputsubinfo
prompt={'Enter subject number:','Enter run number:'};
name='Experimental Information';
numlines=1;
defaultanswer={'s999','1'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
subject=answer{1};
runnum=str2double(answer{2});
return