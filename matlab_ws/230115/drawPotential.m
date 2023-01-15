clc;clear;
matpath="C:\Users\hayashide\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\230115\results\230115_constraint\230115_105306_1e3times_true\230115_105306_.mat"

load(matpath)

fig=figure(4);clf;
map_x=linspace(-1,7);
map_y=linspace(-3,3);
[X,Y]=meshgrid(map_x,map_y);

norm_HR=sqrt(X.^2+Y.^2);
deg_diff=atan(Y./X);

mu_r=(sns.r1+sns.r2)/2;
sgm_r=1/6*(sns.r2-sns.r1);
score_r=pdf('Normal',norm_HR,mu_r,sgm_r);

mu_phi=0;
sgm_phi=1/6*2*sns.phi;
score_p=pdf('Normal',deg_diff,mu_phi,sgm_phi);

Z=score_r.*score_p;

surface(X,Y,Z)
view(3)
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