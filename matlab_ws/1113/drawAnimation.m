function data = drawAnimation(t,z,u,env,rbt,hmn,sns,soln,savename,graph_title)
%%%% Parameters
arrow_scale=5;
arc_resolution=100;
savename_mp4 = savename+".mp4";

%%%% Drawing preparation
fig2 = figure(2); clf;
frames(length(z(1,:))) = struct('cdata',[],'colormap',[]);

%%%% Get path info
plt_xR=z(1,:);
plt_yR=z(2,:);
plt_thR=z(3,:);
plt_vxR=z(4,:);
plt_vyR=z(5,:);
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

%%%% Initial drawing
%%%%% Wall
wall_right = plot([env.xmin,env.xmax],[env.kabe.ymin,env.kabe.ymin],'k');
hold on
wall_right = plot([env.xmin,env.xmax],[env.kabe.ymax,env.kabe.ymax],'k');
hold on

%%%%% ROI borders
roi_rectangle = rectangle('Position', [env.roi.xmin env.roi.ymin env.roi.xmax-env.roi.xmin env.roi.ymax-env.roi.ymin],'EdgeColor','c');

%%%%% Robot
rbt_position = plot(plt_xR(1),plt_yR(1),'ob','MarkerSize',15);
hold on
rbt_direction = quiver(plt_xR(1),plt_yR(1),plt_vxR(1),plt_vyR(1),'b');
hold on
%%%%% Human
hmn_position = plot(plt_xH(1),plt_yH(1),'or','MarkerSize',15);
hold on
hmn_direction = quiver(plt_xH(1),plt_yH(1),plt_vxH(1),plt_vyH(1),'r');
hold on

%%%%% arc
arc_rad = linspace(plt_thR(1)-sns.phi,plt_thR(1)+sns.phi,arc_resolution);
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
arc_right_helper=plot([plt_xR(1),arc_r1_x(1)],[plt_yR(1),arc_r1_y(1)],'--g')
hold on
arc_left_helper=plot([plt_xR(1),arc_r1_x(end)],[plt_yR(1),arc_r1_y(end)],'--g')
hold on
robot_path=plot(plt_xR(1),plt_yR(1),'b');
hold on
human_path=plot(plt_xH(1),plt_yH(1),'r');

title(graph_title);
xlim([env.xmin,env.xmax]);
ylim([env.kabe.ymin-1,env.kabe.ymax+1]);
daspect([1,1,1]);

%%%% Iteration
for i = 1:length(plt_xR)
    set(rbt_position,'XData',plt_xR(i),'YData',plt_yR(i));
    set(hmn_position,'XData',plt_xH(i),'YData',plt_yH(i));
    set(rbt_direction,'XData',plt_xR(i),'YData',plt_yR(i),'UData',plt_vxR(i),'VData',plt_vyR(i));
    set(hmn_direction,'XData',plt_xH(i),'YData',plt_yH(i),'UData',plt_vxH(i),'VData',plt_vyH(i));

    arc_rad = linspace(plt_thR(i)-sns.phi,plt_thR(i)+sns.phi,arc_resolution);
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
    drawnow;
    frames(i)=getframe(fig2);
end

video2=VideoWriter(savename_mp4,'MPEG-4');
open(video2);
writeVideo(video2, frames);
close(video2);
end