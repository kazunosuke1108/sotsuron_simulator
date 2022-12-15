function data=drawPath(t,z,u,env,rbt,hmn,sns,soln,savename,graph_title)

%%%% Drawing preparation

%%%% Get path info
plt_xR=z(1,:);
plt_yR=z(2,:);

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
% odom=csvread("C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\scripts\monitor\odom_2022-12-11-18-54-07.csv")
% odom=csvread("/home/hayashide/kazu_ws/sotsuron_experiment/sotsuron_experiment/scripts/monitor/odom_2022-12-11-18-54-07.csv")
% odom_x=odom(:,1);
% odom_y=odom(:,2);
% odom_th=odom(:,3);

% odom_path=plot(odom_x,odom_y,'k')

title(graph_title);
xlim([env.xmin,env.xmax]);
ylim([env.kabe.ymin-1,env.kabe.ymax+1]);
daspect([1,1,1]);


end