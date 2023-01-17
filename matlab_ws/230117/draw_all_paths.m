clc;clear;

motherdir="C:\Users\hayashide\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\230117\final_results";
dirlist=dir(motherdir);

for n = 3:length(dirlist)
    figure(1); clf;
    % try
    fullpath = fullfile(dirlist(n).folder, dirlist(n).name);
    matpath = dir(fullpath+"\*.mat");
    fullmatpath=string(matpath.folder)+"\"+string(matpath.name);
    load(fullmatpath)
    
    if hmn.vx<-1.1
        drawPath(t,z,u,env,rbt,hmn,sns,soln,savename,graph_title);
        % if n ~= length(dirlist)
        %     hold on
        % end
        saveas(figure(1),motherdir+"\path\results_y0"+string(abs(hmn.y0))+"_vx"+string(abs(hmn.vx))+".png");
    end
    clearvars -except motherdir dirlist matpath fullmatpath n;
    % catch
        % disp(fullmatpath)
        % continue
    % end
    
end
