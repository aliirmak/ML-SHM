function [fd, shd] = Bench_v2(filename)
warning off

%% Load data
fs=200;
delimiter = ' ';
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'EmptyValue', NaN,  'ReturnOnError', false);
fclose(fileID);
data_blwn = [dataArray{1:end-1}];
data_blwn_red = data_blwn(:,2:end);
clearvars filename delimiter formatSpec fileID dataArray ans;

%% Identifying modal properties
% This is done here using all possible free responses (using all sensors as
% reference channels in NExT to obtain free responses)
np = 12 ;    % number of poles to be determined
references  = 1:39 ;
fdt = [] ; sht = [] ; ztt = [] ;
parfor cnt1 = references
    [Y,~] = next(data_blwn_red,fs,cnt1,2048) ;
    [fd,zt,sh,pf]=era_dc(Y,fs,400,300,2,3,np) ;
    [fd,sh,zt] = eliminate(fd,sh,zt,65,cnt1,pf) ;
    fdt = [ fdt ; fd ] ; sht = [ sht   sh ] ; ztt = [ ztt ; zt ] ;
end
[fd,sh,zt,rf] = stabilize(fdt,sht,ztt) ;
del = find(rf<3) ;
fd(del) = [] ; zt(del) = [] ; rf(del) = [] ; sh(:,del) = [] ;
fd = fd';
if length(fd) >= 6
    sh = complexmodesh(sh);
end
shd=transpose(sh(:));
