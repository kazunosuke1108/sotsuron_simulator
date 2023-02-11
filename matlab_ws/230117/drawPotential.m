clc;clear;
matpath="C:\Users\林出和之\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\230115\results\230115_constraint\230115_142355_1e3times_true\230115_142355_.mat"

load(matpath)

fig=figure(4);clf;
map_x=linspace(0,7);
map_y=linspace(-2,7);
[X,Y]=meshgrid(map_x,map_y);

norm_HR=sqrt((X-0).^2+(Y-2.5).^2);
deg_diff=atan((Y-2.5)./(X));

mu_r=(sns.r1+sns.r2)/2;
sgm_r=1/6*(sns.r2-sns.r1);
score_r=pdf('Normal',norm_HR,mu_r,sgm_r);

mu_phi=0;
sgm_phi=1/6*2*sns.phi;
score_p=pdf('Normal',deg_diff,mu_phi,sgm_phi);

Z=score_r.*score_p;
idx=find(Z>0.01);
scatter3(X(idx),Y(idx),Z(idx),1)
view(3)
hold on
%%%% Initial drawing
%%%%% Wall
wall_right = plot([env.xmin,env.xmax],[env.kabe.ymin,env.kabe.ymin],'k');
hold on
wall_left = plot([env.xmin,env.xmax],[env.kabe.ymax,env.kabe.ymax],'k');
hold on

%%%%% ROI borders
roi_rectangle = rectangle('Position', [env.roi.xmin env.roi.ymin env.roi.xmax-env.roi.xmin env.roi.ymax-env.roi.ymin],'EdgeColor','c');

%%%%% Robot
plt_xR=[0]
plt_yR=[2.5]
plt_thR=[0]
plt_phR=[0]
% rbt_position = plot(plt_xR(1),plt_yR(1),'ob','MarkerSize',15);
rbt_position=plot(plt_xR(1)+rbt.sizer*cos(0:0.01:2*pi),plt_yR(1)+rbt.sizer*sin(0:0.01:2*pi),'b');
hold on
rbt_base_direction = quiver(plt_xR(1),plt_yR(1),cos(plt_thR(1)),sin(plt_thR(1)),'b');
hold on
% rbt_vel_direction = quiver(plt_xR(1),plt_yR(1),plt_vxR(1),plt_vyR(1),'b');
% hold on
%%%%% Human
% hmn_position = plot(plt_xH(1),plt_yH(1),'or','MarkerSize',15);
% hmn_position=plot(plt_xH(1)+hmn.sizer*cos(0:0.01:2*pi),plt_yH(1)+hmn.sizer*sin(0:0.01:2*pi),'r');
% hold on
% hmn_direction = quiver(plt_xH(1),plt_yH(1),plt_vxH(1),plt_vyH(1),'r');
% hold on
% hmn_position_err_fast=plot(plt_xH(1),plt_yH(1),'xr','MarkerSize',15);
% hold on
% hmn_position_err_slow=plot(plt_xH(1),plt_yH(1),'xr','MarkerSize',15);
% hold on
% hmn_personal_area=plot(plt_xH(1)+hmn.personal_r*cos(0:0.01:2*pi),plt_yH(1)+hmn.personal_r*sin(0:0.01:2*pi),'r');
hold on
%%%%% arc
arc_resolution=100
arc_rad = linspace(plt_phR(1)+plt_thR(1)-sns.phi,plt_phR(1)+plt_thR(1)+sns.phi,arc_resolution);
arc_r1_x = sns.r1*cos(arc_rad)+plt_xR(1);
arc_r1_y = sns.r1*sin(arc_rad)+plt_yR(1);
arc_r2_x = sns.r2*cos(arc_rad)+plt_xR(1);
arc_r2_y = sns.r2*sin(arc_rad)+plt_yR(1);


arc_r1 = plot(arc_r1_x,arc_r1_y,'g');
hold on
arc_r2 = plot(arc_r2_x,arc_r2_y,'g');

arc_right = plot([arc_r1_x(1),arc_r2_x(1)],[arc_r1_y(1),arc_r2_y(1)],'g');
hold on
arc_left = plot([arc_r1_x(end),arc_r2_x(end)],[arc_r1_y(end),arc_r2_y(end)],'g');
hold on
arc_right_helper=plot([plt_xR(1),arc_r1_x(1)],[plt_yR(1),arc_r1_y(1)],'--g');
hold on
arc_left_helper=plot([plt_xR(1),arc_r1_x(end)],[plt_yR(1),arc_r1_y(end)],'--g');

pbaspect([1 1 1])
xlim([-2,7])
ylim([-2,7])
xlabel("x (hallway direction) [m]")
ylabel("y [m]")
zlabel("value of object function")
exportgraphics(fig,"C:\Users\林出和之\OneDrive - keio.jp\4年秋 研究室\[06] 卒論\potential.png",'Resolution',300)
% function data=drawPotential(t,z,u,env,rbt,hmn,sns,soln,savename)

% %%%% Parameters
% savename_map_mp4 = savename+".mp4";

% %%%% Drawing preparation
% fig3 = figure(3); clf;
% frames3(length(z(1,:))) = struct('cdata',[],'colormap',[]);
% map_x=linspace(env.roi.xmin,env.roi.xmax);
% map_y=linspace(env.roi.ymin,env.roi.ymax);
% [X,Y]=meshgrid(map_x,map_y);

% %%%% Get path info
% plt_xR=z(1,:);
% plt_yR=z(2,:);
% plt_thR=z(3,:);
% plt_vxR=z(4,:);
% plt_vyR=z(5,:);
% plt_vR=sqrt(plt_vxR.^2+plt_vyR.^2);

% hmn_path=getHumanPath(t,hmn);

% plt_xH=hmn_path(1,:);
% plt_yH=hmn_path(2,:);
% plt_thH=hmn_path(3,:);
% plt_vxH=hmn_path(4,:);
% plt_vyH=hmn_path(5,:);
% plt_vH=sqrt(plt_vxH.^2+plt_vyH.^2);


% %%%% Get map info
% Z=objFPlot(plt_xR(1),plt_yR(1),plt_thR(1),X,Y,sns);
% func_map=contourf(X,Y,Z,10);

% %%%% drawing option
% xlim([env.roi.xmin,env.roi.xmax]);
% ylim([env.roi.ymin-1,env.roi.ymax+1]);
% daspect([1,1,1]);
% drawnow;

% for i = 1:length(plt_xR)
%     Z=objFPlot(plt_xR(i),plt_yR(i),plt_thR(i),X,Y,sns);
%     func_map=contourf(X,Y,Z,10);
%     ylim([env.roi.ymin-1,env.roi.ymax+1]);
%     daspect([1,1,1]);
%     daspect([1,1,1]);
%     drawnow;
%     frames3(i)=getframe(fig3);
% end
% video3=VideoWriter(savename_map_mp4,'MPEG-4');
% open(video3);
% writeVideo(video3,frames3);
% close(video3);
% end