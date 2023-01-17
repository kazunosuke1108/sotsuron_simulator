function data=drawPath(t,z,u,env,rbt,hmn,sns,soln,savename,graph_title)

%%%% Drawing preparation
arrow_scale=10;
arc_resolution=100;

%%%% Get path info
plt_xR=z(1,:);
plt_yR=z(2,:);
z8=getz8(z,0);
plt_thR=z8(3,:);
plt_phR=z8(4,:);

hmn_path=getHumanPath(t,hmn);

plt_xH=hmn_path(1,:);
plt_yH=hmn_path(2,:);

footprint=getFootprint(t,z,u,env,rbt,hmn,sns);
success_xH=plt_xH.*footprint;
success_yH=plt_yH.*footprint;

success_array=[success_xH;success_yH];
% idx=success_array(1,:)==0 & success_array(2,:)==0;
% success_array=success_array(:,~idx);

%%%%% Wall
wall_right = plot([env.xmin,env.xmax],[env.kabe.ymin,env.kabe.ymin],'k');
hold on
wall_right = plot([env.xmin,env.xmax],[env.kabe.ymax,env.kabe.ymax],'k');
hold on

%%%%% ROI borders
roi_rectangle = rectangle('Position', [env.roi.xmin env.roi.ymin env.roi.xmax-env.roi.xmin env.roi.ymax-env.roi.ymin],'EdgeColor','c');
hold on

%%%%% Human
hmn_position = plot(plt_xH,plt_yH,'r');
hold on

%%%%% footprint
hmn_footprint = plot(success_array(1,:),success_array(2,:),'or');
hold on

%%%%% Robot path
rbt_position = plot(plt_xR,plt_yR,'b');

% % read odometory
% odom=csvread("C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\scripts\monitor\odom_2022-12-14-16-08-40.csv")
% odom=csvread("C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\scripts\monitor\odom_2022-12-16-19-32-43.csv")
% odom=csvread("/home/hayashide/kazu_ws/sotsuron_experiment/sotsuron_experiment/scripts/monitor/odom_2022-12-11-18-54-07.csv")
% odom_x=odom(:,1);
% odom_y=odom(:,2);
% odom_th=odom(:,3);

% odom_path=plot(odom_x,odom_y,'k')

%%%%% arc
arc_rad = linspace(plt_phR(1)+plt_thR(1)-sns.phi,plt_phR(1)+plt_thR(1)+sns.phi,arc_resolution);
arc_r1_x = sns.r1*cos(arc_rad)+plt_xR(1);
arc_r1_y = sns.r1*sin(arc_rad)+plt_yR(1);
arc_r2_x = sns.r2*cos(arc_rad)+plt_xR(1);
arc_r2_y = sns.r2*sin(arc_rad)+plt_yR(1);


arc_r1 = plot(arc_r1_x,arc_r1_y,'g');
arc_r2 = plot(arc_r2_x,arc_r2_y,'g');

arc_right = plot([arc_r1_x(1),arc_r2_x(1)],[arc_r1_y(1),arc_r2_y(1)],'g');
hold on
arc_left = plot([arc_r1_x(end),arc_r2_x(end)],[arc_r1_y(end),arc_r2_y(end)],'g');
hold on
arc_right_helper=plot([plt_xR(1),arc_r1_x(1)],[plt_yR(1),arc_r1_y(1)],'--g');
hold on
arc_left_helper=plot([plt_xR(1),arc_r1_x(end)],[plt_yR(1),arc_r1_y(end)],'--g');
hold on
robot_path=plot(plt_xR(1),plt_yR(1),'b');
hold on
human_path=plot(plt_xH(1),plt_yH(1),'r');

for i = 1:length(plt_xR)

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
        plot(success_xH(i),success_yH(i),'or','MarkerSize',5);
    end
    if rem(i,50)==0;
        hold on
        quiver(plt_xR(i),plt_yR(i),cos(plt_phR(i)+plt_thR(i)),sin(plt_phR(i)+plt_thR(i)),'g','LineWidth',1);
    end
end

title(graph_title);
xlim([env.xmin,env.xmax]);
ylim([env.kabe.ymin-1,env.kabe.ymax+1]);
daspect([1,1,1]);


end