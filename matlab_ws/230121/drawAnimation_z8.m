function data = drawAnimation_z8(t,z,z8,u,env,rbt,hmn,sns,soln,savename,graph_title)
%%%% Parameters
arrow_scale=5;
arc_resolution=100;
savename_mp4 = savename+".mp4";
savename_avi = savename+".avi";

%%%% Drawing preparation
fig2 = figure('units','pixels','position',[0 0 400 200]); clf;
% fig2 = figure('units','pixels','position',[0 0 800,400]); clf;
frames(length(z(1,:))) = struct('cdata',[],'colormap',[]);

%%%% Get path info
plt_xR=z8(1,:);
plt_yR=z8(2,:);
plt_thR=z8(3,:);
plt_phR=z8(4,:);
plt_vxR=z8(5,:);
plt_vyR=z8(6,:);
plt_vR=sqrt(plt_vxR.^2+plt_vyR.^2);

hmn_path=getHumanPath(t,hmn);

plt_xH=hmn_path(1,:);
plt_yH=hmn_path(2,:);
plt_thH=hmn_path(3,:);
plt_vxH=hmn_path(4,:);
plt_vyH=hmn_path(5,:);
plt_vH=sqrt(plt_vxH.^2+plt_vyH.^2);

plt_vxR=arrow_scale*plt_vxR;
plt_vyR=arrow_scale*plt_vyR;
plt_vxH=arrow_scale*plt_vxH;
plt_vyH=arrow_scale*plt_vyH;
plt_vR=arrow_scale*plt_vR;
plt_vH=arrow_scale*plt_vH;

%%%% footprint
footprint=getFootprint(t,z,u,env,rbt,hmn,sns);
success_xH=plt_xH.*footprint;
success_yH=plt_yH.*footprint;
roi_checker11=plt_xH>=env.roi.xmin;
roi_checker12=plt_xH<=env.roi.xmax;
roi_checker1=roi_checker11.*roi_checker12;
fp_ratio=nnz(footprint)/nnz(roi_checker1);

%%%%% how long measured?
try
    success_list=find(footprint>0,nnz(footprint));
    first_success_idx=success_list(1);
    last_success_idx=success_list(end);
    i=1;
    for success = success_list(1:end-1)
        if success+1==success_list(i+1)
            last_success_idx=success;
        else
            last_success_idx=success;
            break
        end
        i=i+1;
    end
catch
    first_success_idx=1;
    last_success_idx=1;
end
continuous_check=all(footprint(first_success_idx:last_success_idx)>0);
measured_length=abs(hmn_path(1,first_success_idx)-hmn_path(1,last_success_idx));

%%%% minimum norm_HR
vec_HR=[hmn_path(1,:);hmn_path(2,:)]-[z(1,:);z(2,:)];
e=[cos(z(3,:));sin(z(3,:))];
norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);
vec_HR=(norm_HR-hmn.sizer)./norm_HR.*vec_HR;
norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);


%%%% Initial drawing
%%%%% Wall
wall_right = plot([env.xmin,env.xmax],[env.kabe.ymin,env.kabe.ymin],'k');
hold on
wall_right = plot([env.xmin,env.xmax],[env.kabe.ymax,env.kabe.ymax],'k');
hold on

%%%%% ROI borders
roi_rectangle = rectangle('Position', [env.roi.xmin env.roi.ymin env.roi.xmax-env.roi.xmin env.roi.ymax-env.roi.ymin],'EdgeColor','c');

%%%%% Robot
% rbt_position = plot(plt_xR(1),plt_yR(1),'ob','MarkerSize',15);
rbt_position=plot(plt_xR(1)+rbt.sizer*cos(0:0.01:2*pi),plt_yR(1)+rbt.sizer*sin(0:0.01:2*pi),'b');
hold on
rbt_base_direction = quiver(plt_xR(1),plt_yR(1),cos(plt_thR(1)),sin(plt_thR(1)),'k');
hold on
rbt_vel_direction = quiver(plt_xR(1),plt_yR(1),plt_vxR(1),plt_vyR(1),'b');
hold on
%%%%% Human
% hmn_position = plot(plt_xH(1),plt_yH(1),'or','MarkerSize',15);
hmn_position=plot(plt_xH(1)+hmn.sizer*cos(0:0.01:2*pi),plt_yH(1)+hmn.sizer*sin(0:0.01:2*pi),'r');
hold on
hmn_direction = quiver(plt_xH(1),plt_yH(1),plt_vxH(1),plt_vyH(1),'r');
hold on
% hmn_position_err_fast=plot(plt_xH(1),plt_yH(1),'xr','MarkerSize',15);
% hold on
% hmn_position_err_slow=plot(plt_xH(1),plt_yH(1),'xr','MarkerSize',15);
% hold on
hmn_personal_area=plot(plt_xH(1)+hmn.personal_r*cos(0:0.01:2*pi),plt_yH(1)+hmn.personal_r*sin(0:0.01:2*pi),'m');
hold on
%%%%% arc
arc_rad = linspace(plt_phR(1)+plt_thR(1)-sns.phi,plt_phR(1)+plt_thR(1)+sns.phi,arc_resolution);
arc_r1_x = sns.r1*cos(arc_rad)+plt_xR(1);
arc_r1_y = sns.r1*sin(arc_rad)+plt_yR(1);
arc_r2_x = sns.r2*cos(arc_rad)+plt_xR(1);
arc_r2_y = sns.r2*sin(arc_rad)+plt_yR(1);


arc_r1 = plot(arc_r1_x,arc_r1_y,'g','LineWidth',2.5);
arc_r2 = plot(arc_r2_x,arc_r2_y,'g','LineWidth',2.5);

arc_right = plot([arc_r1_x(1),arc_r2_x(1)],[arc_r1_y(1),arc_r2_y(1)],'g','LineWidth',2.5);
hold on
arc_left = plot([arc_r1_x(end),arc_r2_x(end)],[arc_r1_y(end),arc_r2_y(end)],'g','LineWidth',2.5);
hold on
arc_right_helper=plot([plt_xR(1),arc_r1_x(1)],[plt_yR(1),arc_r1_y(1)],'--g','LineWidth',2.5);
hold on
arc_left_helper=plot([plt_xR(1),arc_r1_x(end)],[plt_yR(1),arc_r1_y(end)],'--g','LineWidth',2.5);
hold on
robot_path=plot(plt_xR(1),plt_yR(1),'b','LineWidth',5);
hold on
human_path=plot(plt_xH(1),plt_yH(1),'r');

% title(graph_title);
xlim([env.xmin,env.xmax]);
ylim([env.kabe.ymin-1,env.kabe.ymax+1]);
xlabel("x [m]")
ylabel("y [m]")
daspect([1,1,1]);
% odom=readmatrix("C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\scripts\monitor\20230117_d_060_1_Hayashide.csv")
% % odom=csvread("C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\scripts\monitor\odom_2022-12-16-19-32-43.csv")
% % odom=csvread("/home/hayashide/kazu_ws/sotsuron_experiment/sotsuron_experiment/scripts/monitor/odom_2022-12-11-18-54-07.csv")
% odom_x=odom(:,1)-odom(1,1);
% odom_y=odom(:,2)-odom(1,2)+0.5;
% odom_th=odom(:,3)-odom(1,3);

% odm_idx=find(odom_x<8);
% ratio=3%length(odom_x)/length(plt_xR);
% hold on
% odom_path=plot(odom_x(1),odom_y(1),'k','LineWidth',5)
%%%% Iteration

saveas(fig2,savename+"_"+string(t(1))+".png")

for i = 1:length(plt_xR)
    % title("frame: "+i+" "+graph_title+" L="+measured_length+"m"+" continuous="+continuous_check+" min gap"+min(norm_HR)+" m")
    set(rbt_position,'XData',plt_xR(i)+rbt.sizer*cos(0:0.01:2*pi),'YData',plt_yR(i)+rbt.sizer*sin(0:0.01:2*pi));
    set(hmn_position,'XData',plt_xH(i)+hmn.sizer*cos(0:0.01:2*pi),'YData',plt_yH(i)+hmn.sizer*sin(0:0.01:2*pi));
    % set(hmn_position_err_fast,'XData',plt_xH(i)-hmn.vx_err*t(i),'YData',plt_yH(i))
    % set(hmn_position_err_slow,'XData',plt_xH(i)+hmn.vx_err*t(i),'YData',plt_yH(i))
    set(rbt_base_direction,'XData',plt_xR(i),'YData',plt_yR(i),'UData',cos(plt_thR(i)),'VData',sin(plt_thR(i)));
    set(rbt_vel_direction,'XData',plt_xR(i),'YData',plt_yR(i),'UData',plt_vxR(i),'VData',plt_vyR(i));
    set(hmn_direction,'XData',plt_xH(i),'YData',plt_yH(i),'UData',plt_vxH(i),'VData',plt_vyH(i));
    set(hmn_personal_area,'XData',plt_xH(i)+hmn.personal_r*cos(0:0.01:2*pi),'YData',plt_yH(i)+hmn.personal_r*sin(0:0.01:2*pi));
    % set(odom_path,'XData',odom_x(1:round(i*ratio)),'YData',odom_y(1:round(i*ratio)))

    arc_rad = linspace(plt_phR(i)+plt_thR(i)-sns.phi,plt_phR(i)+plt_thR(i)+sns.phi,arc_resolution);
    arc_r1_x = sns.r1*cos(arc_rad)+plt_xR(i);
    arc_r1_y = sns.r1*sin(arc_rad)+plt_yR(i);
    arc_r2_x = sns.r2*cos(arc_rad)+plt_xR(i);
    arc_r2_y = sns.r2*sin(arc_rad)+plt_yR(i);
    set(arc_r1,'XData',arc_r1_x,'YData',arc_r1_y);
    set(arc_r2,'XData',arc_r2_x,'YData',arc_r2_y);
    set(arc_right,'XData',[arc_r1_x(1),arc_r2_x(1)],'YData',[arc_r1_y(1),arc_r2_y(1)]);
    set(arc_left,'XData',[arc_r1_x(end),arc_r2_x(end)],'YData',[arc_r1_y(end),arc_r2_y(end)]);
    set(arc_right_helper,'XData',[plt_xR(i),arc_r1_x(1)],'YData',[plt_yR(i),arc_r1_y(1)]);
    set(arc_left_helper,'XData',[plt_xR(i),arc_r1_x(end)],'YData',[plt_yR(i),arc_r1_y(end)]);
    % path
    set(robot_path,'XData',plt_xR(1:i),'YData',plt_yR(1:i));
    set(human_path,'XData',plt_xH(1:i),'YData',plt_yH(1:i));
    if footprint(i)==1
        hold on
        if success_yH(i)>0.1
            plot(success_xH(i),success_yH(i),'or','MarkerSize',5);
        end
    end
    if (rem(i,30)==0 & i<=240) |i==1 | i==300 | i==400 | i==600 % rem(i,50)==0;
        hold on
        quiver(plt_xR(i),plt_yR(i),cos(plt_phR(i)+plt_thR(i)),sin(plt_phR(i)+plt_thR(i)),'g','LineWidth',0.5);
        % hold on
        % plot(arc_r1_x,arc_r1_y,'g');
        % hold on
        % plot(arc_r2_x,arc_r2_y,'g');
        % hold on
        % plot([arc_r1_x(1),arc_r2_x(1)],[arc_r1_y(1),arc_r2_y(1)],'g');
        % hold on
        % plot([arc_r1_x(end),arc_r2_x(end)],[arc_r1_y(end),arc_r2_y(end)],'g');
        % hold on
        % plot([plt_xR(1),arc_r1_x(1)],[plt_yR(1),arc_r1_y(1)],'--g');
        % hold on
        % plot([plt_xR(1),arc_r1_x(end)],[plt_yR(1),arc_r1_y(end)],'--g');
    end
    drawnow;
    frames(i)=getframe(fig2);
    % if (rem(i,30)==0 & i<=240) |i==1 | i==300 | i==400 | i==600
    %     saveas(fig2,savename+"_"+string(t(i))+".png")
    % end
end

video2=VideoWriter(savename_mp4,'MPEG-4');
% video2=VideoWriter(savename_avi);
video2.FrameRate=length(t)/fix(soln.grid.time(end));
open(video2);
writeVideo(video2, frames);
close(video2);
end