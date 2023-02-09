clc;clear;

motherdir="C:\Users\林出和之\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\230121\results\2022h_230122_1800_parameter_study_d455_no_offset";
dirlist=dir(motherdir);

for n = 3:length(dirlist)
    % try
    fullpath = fullfile(dirlist(n).folder, dirlist(n).name);
    matpath = dir(fullpath+"\*.mat");
    fullmatpath=string(matpath.folder)+"\"+string(matpath.name);
    load(fullmatpath)
%    n = length(soln.grid.time);
    t=soln.grid.time;
    z=soln.grid.state;
    z8=getz8(z,0);
    u=soln.grid.control;
    
    if hmn.vx<-1.1 || (hmn.vx<-0.8 && hmn.vx>-1.0) || hmn.vx>-0.7
        if (hmn.y0>0.9 && hmn.y0<1.1) || (hmn.y0>2.4 && hmn.y0<2.6) || (hmn.y0>3.9 && hmn.y0<4.1)
            fig=figure('units','pixels','position',[0 0 400 200]); clf;
            drawPath(t,z,u,env,rbt,hmn,sns,soln,savename,graph_title);
            % if n ~= length(dirlist)
            %     hold on
            % end
            saveas(fig,motherdir+"\path\results_y0"+string(abs(hmn.y0))+"_vx"+string(abs(hmn.vx))+".png");
            clearvars fig
        end
    end
    clearvars -except motherdir dirlist matpath fullmatpath n;
    % catch
        % disp(fullmatpath)
        % continue
    % end
    
end