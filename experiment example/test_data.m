close all
clear all

folder = fileparts(which('test_data.m'));
addpath(genpath([folder '\NExT ERA_DC']));
[dataset, damageStates, stateList] = import_3StoryStructure2009_shm;

dt = 1/322.58;

% 1:50 51:100 101:151 
% 151:200 201:250 251:300
% 301:350 351:400 401:451
fd=zeros(450,3); shd=zeros(450,9); fd_shd=zeros(450,12);
for i = [1:50 151:250 351:450]
    dataset1 = squeeze(dataset(:,3:5,i));
    [fd_temp, shd_temp] = Bench_v2(dataset1);
    
    if stateList(i) == 1
        try
            ind = find(fd_temp>29.0 & fd_temp<35.0,1); 
            fd(i,1) = fd_temp(ind); 
            shd(i,1:3) = shd_temp(3*ind-2:3*ind);

            ind = find(fd_temp>50.0 & fd_temp<57.0,1); 
            fd(i,2) = fd_temp(ind); 
            shd(i,4:6) = shd_temp(3*ind-2:3*ind);

            ind = find(fd_temp>70.5 & fd_temp<73.0,1); 
            fd(i,3) = fd_temp(ind); 
            shd(i,7:9) = shd_temp(3*ind-2:3*ind);
        end
        
    elseif stateList(i) == 4
        try
            ind = find(fd_temp>25.0 & fd_temp<35.0,1); 
            fd(i,1) = fd_temp(ind); 
            shd(i,1:3) = shd_temp(3*ind-2:3*ind);

            ind = find(fd_temp>47.0 & fd_temp<57.0,1); 
            fd(i,2) = fd_temp(ind); 
            shd(i,4:6) = shd_temp(3*ind-2:3*ind);

            ind = find(fd_temp>68.0 & fd_temp<73.0,1); 
            fd(i,3) = fd_temp(ind); 
            shd(i,7:9) = shd_temp(3*ind-2:3*ind);
        end
        
    elseif stateList(i) == 5
        try
            ind = find(fd_temp>25.0 & fd_temp<35.0,1); 
            fd(i,1) = fd_temp(ind); 
            shd(i,1:3) = shd_temp(3*ind-2:3*ind);

            ind = find(fd_temp>46.0 & fd_temp<49.0,1); 
            fd(i,2) = fd_temp(ind); 
            shd(i,4:6) = shd_temp(3*ind-2:3*ind);

            ind = find(fd_temp>65.0 & fd_temp<73.0,1); 
            fd(i,3) = fd_temp(ind); 
            shd(i,7:9) = shd_temp(3*ind-2:3*ind);
        end
        
    elseif stateList(i) == 6
        try
            ind = find(fd_temp>25.0 & fd_temp<35.0,1); 
            fd(i,1) = fd_temp(ind); 
            shd(i,1:3) = shd_temp(3*ind-2:3*ind);

            ind = find(fd_temp>52.75 & fd_temp<57.0,1); 
            fd(i,2) = fd_temp(ind); 
            shd(i,4:6) = shd_temp(3*ind-2:3*ind);

            ind = find(fd_temp>66 & fd_temp<73.0,1); 
            fd(i,3) = fd_temp(ind); 
            shd(i,7:9) = shd_temp(3*ind-2:3*ind);
        end
        
    elseif stateList(i) == 7
        try
            ind = find(fd_temp>25.0 & fd_temp<35.0,1); 
            fd(i,1) = fd_temp(ind); 
            shd(i,1:3) = shd_temp(3*ind-2:3*ind);

            ind = find(fd_temp>47.0 & fd_temp<57.0,1); 
            fd(i,2) = fd_temp(ind); 
            shd(i,4:6) = shd_temp(3*ind-2:3*ind);

            ind = find(fd_temp>66.50 & fd_temp<73.0,1); 
            fd(i,3) = fd_temp(ind); 
            shd(i,7:9) = shd_temp(3*ind-2:3*ind);
        end 
        
    elseif stateList(i) == 8
        try
            ind = find(fd_temp>25.0 & fd_temp<35.0,1); 
            fd(i,1) = fd_temp(ind); 
            shd(i,1:3) = shd_temp(3*ind-2:3*ind);

            ind = find(fd_temp>47.0 & fd_temp<57.0,1); 
            fd(i,2) = fd_temp(ind); 
            shd(i,4:6) = shd_temp(3*ind-2:3*ind);

            ind = find(fd_temp>66.0 & fd_temp<73.0,1); 
            fd(i,3) = fd_temp(ind); 
            shd(i,7:9) = shd_temp(3*ind-2:3*ind);
        end
        
    elseif stateList(i) == 9
        try
            ind = find(fd_temp>25.0 & fd_temp<35.0,1); 
            fd(i,1) = fd_temp(ind); 
            shd(i,1:3) = shd_temp(3*ind-2:3*ind);

            ind = find(fd_temp>47.0 & fd_temp<57.0,1); 
            fd(i,2) = fd_temp(ind); 
            shd(i,4:6) = shd_temp(3*ind-2:3*ind);

            ind = find(fd_temp>66.50 & fd_temp<73.0,1); 
            fd(i,3) = fd_temp(ind); 
            shd(i,7:9) = shd_temp(3*ind-2:3*ind);
        end
        
    end
    
end

fd_shd = [fd shd];
fd_shd = [stateList(1:450) fd_shd];

fd_shd_red = fd_shd(all(fd_shd,2),:);

csvwrite('data_4dof.txt',fd_shd_red)
cmap = lines;
h = plot(1:50,fd_shd_red(1:50,2:4),...
    51:99,fd_shd_red(51:99,2:4),...
    100:149,fd_shd_red(100:149,2:4),...
    150:199,fd_shd_red(150:199,2:4),...
    200:244,fd_shd_red(200:244,2:4));
legend([h(1) h(4) h(7) h(10) h(13) h(15)],'1', '4', '5', '8', '9')
h(1).Color= cmap(1,:); h(2).Color= cmap(1,:); h(3).Color= cmap(1,:);
h(4).Color= cmap(2,:); h(5).Color= cmap(2,:); h(6).Color= cmap(2,:);
h(7).Color= cmap(3,:); h(8).Color= cmap(3,:); h(9).Color= cmap(3,:);
h(10).Color= cmap(4,:); h(11).Color= cmap(4,:); h(12).Color= cmap(4,:);
h(13).Color= cmap(5,:); h(14).Color= cmap(5,:); h(15).Color= cmap(5,:);
