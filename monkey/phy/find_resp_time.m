function [valid_res_plx,resp_points,odor_time]=find_resp_time(front)
%加载数据
respname=[front '.mat'];
plxname=[front '.plx'];
res_data = load(respname);
sample_rate=500;
%plx_event_ts函数：读取打标时间点信息，n为总的打标点数目，ts是每次打标的时间点。"Strobed"为存储打标数据的channel名
[n, ts, sv] = plx_event_ts(plxname, 'Strobed');
%呼吸的标记
points = findpoints(res_data.data);
%气味的标记
marker_time=find(res_data.data(:,2)~=0);
marker_label=res_data.data(marker_time,2);
marker_info=[marker_label(1:2:end) reshape(marker_time,2,[])'];

%找到气味释放区间有效呼吸
p = 1; % mark the index of current loc 
valid_res = cell(6,1);
%test = cell(5,1);
for i = 1:length(marker_info)
    odor = marker_info(i,1);
    odor_start = marker_info(i,2);    
    odor_end = marker_info(i,3);
    for ii = p:length(points)
        res_start = points(ii,1);
        res_high = points(ii,2);
        res_end = points(ii,3);
        if res_start+100>=odor_start && res_high-100<=odor_end
            valid_res{odor,1} = [valid_res{odor,1};[res_start,res_high,res_end]];
            %test{odor}{end+1} = res_data.data(res_start:res_end)';
        elseif res_high-100 > odor_end
            break
        else 
            continue
        end
        p = ii;
    end
end
%取每次气味释放前的一次呼吸作为空气的均线(目前随机取5行）
% valid_res{6,1}=valid_res{6,1}(randperm(length(valid_res{6,1}), 5),:);

%进行数据对齐，电生理与呼吸
plx_time=reshape(ts,7,[]);
plx_time=reshape(plx_time(3:6,:),2,[])';
biop_time=marker_info(:,2:3)/sample_rate;
%计算两个系统的时间差异
bia=mean(mean(plx_time-biop_time));
%将呼吸标记转换为以秒为单位的plx中的时间
valid_res_plx=valid_res;
odor_time= cell(6,1);
 for b =1:6
    valid_res_plx{b,1}(:,:)=valid_res{b,1}(:,:)/sample_rate+bia;
 end
resp_points=points(:,1:3)/sample_rate+bia;
 for b =1:6
    odor_time{b,1}(:,:)=marker_info(marker_info(:,1)==b,2:3)/sample_rate+bia;
 end

end