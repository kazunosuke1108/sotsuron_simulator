clc;clear;
matpath="C:\Users\hayashide\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\230121\results\230121_no_geta\230121_124038_y0_1\230121_124038_.mat";

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

pbaspect([1 1 0.5])
xlim([-2,7])
ylim([-2,7])
xlabel("x (hallway direction) [m]")
ylabel("y [m]")
zlabel("value of object function")
exportgraphics(fig,"C:\Users\hayashide\OneDrive - keio.jp\4年秋 研究室\[06] 卒論\本文\potential.png",'Resolution',300)

fig=figure(5);clf;
r=0:0.01:8;
score_r=pdf('Normal',r,mu_r,sgm_r);
phi=-pi/2:0.01:pi/2;
score_p=pdf('Normal',phi,mu_phi,sgm_phi);

fig=figure(5);clf;
plot(r,score_r);
xlabel("distance r [m]");
ylabel("Object function F_r[k]");
daspect([1 1 1]);
exportgraphics(fig,"C:\Users\hayashide\OneDrive - keio.jp\4年秋 研究室\[06] 卒論\本文\F_r.png",'Resolution',300)
fig=figure(5);clf;
plot(phi,score_p);
xlabel("direction phi [rad]");
ylabel("Object function F_{phi}[k]");
daspect([1 1 1]);
exportgraphics(fig,"C:\Users\hayashide\OneDrive - keio.jp\4年秋 研究室\[06] 卒論\本文\F_p.png",'Resolution',300)
