clc;
clear
load('order.mat');
block=1;

f=fopen('VID_20190813_123537.srt','a+');
odor={'ßÅßá','ÒìÎìËá£¨µÍÅ¨¶È£©','ÒìÎìËá£¨¸ßÅ¨¶È£©','ÌÒ','Ïã½¶'};
air='¿ÕÆø';
starttime=[2019,8,13,0,8,8];
con=0;
for i=1:15
con=con+1;
fprintf(f,'\r\n%d\r\n',con);    
endtime=starttime;
endtime(6)=starttime(6)+7.7;
t1=datestr(starttime,13);
t2=datestr(endtime,13);
fprintf(f,'%s --> %s\r\n',t1,t2);
fprintf(f,'%s\r\n',odor{order(block,i)});

con=con+1;
fprintf(f,'\r\n%d\r\n',con);    
starttime=endtime;
endtime(6)=starttime(6)+13.7;
t1=datestr(starttime,13);
t2=datestr(endtime,13);
starttime=endtime;
fprintf(f,'%s --> %s\r\n',t1,t2);
fprintf(f,'%s\r\n',air);
end
fclose(f);