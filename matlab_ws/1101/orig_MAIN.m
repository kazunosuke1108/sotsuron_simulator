% orig_MAIN.m
%
% Solve the sotsuron problem
% フォルダ実行場所に注意（パスの都合でcsv出力が死にうる）

addpath 'C:\Users\hyper\OneDrive\デスクトップ\VSCode\sotsuron_simulator\matlab_ws\tutorial\cartPole'

clc; clear;%

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                     Defenition of variables                             %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

duration=120;%

xmin=0;%
xmax=18;%

ymin=0;%
ymax=2.5;%

r.x0=10;%
r.y0=1;%
r.th0=0;%
r.x1=15;%
r.y1=1;%
% r.th1=0;%

h.x0=15;%
h.y0=1;%
h.th0=pi;%
h.v=-0.3;%

c.r1=2.4;%
c.r2=3.5;%
c.phi=deg2rad(58)/2;%


vel_max=0.22;%
omg_max=pi/4;%

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                     Set up function handles                             %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

problem.func.dynamics=@(t,x,u)(f(x,u));%
% problem.func.pathObj=@(t,x,u)(objF(x,h,t));
problem.func.pathObj=@(t,x,u)(objF_nd(x,h,t,c));%

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                     Set up problem bounds                               %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

problem.bounds.initialTime.low = 0;
problem.bounds.initialTime.upp = 0;
problem.bounds.finalTime.low = duration;
problem.bounds.finalTime.upp = duration;

problem.bounds.initialState.low = [r.x0;r.y0;r.th0];
problem.bounds.initialState.upp = [r.x0;r.y0;r.th0];
problem.bounds.finalState.low = [r.x1;r.y1;-pi];
problem.bounds.finalState.upp = [r.x1;r.y1;pi];

problem.bounds.state.low = [r.x0;ymin;-pi];
problem.bounds.state.upp = [r.x1;ymax;pi];

problem.bounds.control.low = [-vel_max;-omg_max];
problem.bounds.control.upp = [vel_max;omg_max];


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                    Initial guess at trajectory                          %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

problem.guess.time = [0,duration];
problem.guess.state = [problem.bounds.initialState.low, problem.bounds.finalState.upp];
problem.guess.control = [0 0;0 0];

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                         Solver options                                  %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

problem.options.nlpOpt = optimset(...
'Display','iter',...
'MaxFunEvals',1e6);

% problem.options.method = 'trapezoid'; 
problem.options.method = 'hermiteSimpson';  

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                            Solve!                                       %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

soln = trajOpt(problem);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                        Summarize conditions & results                   %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
addpath results\
now=datetime('now')
filename_csv = string("results\"+datestr(now,'yymmdd_hhMMss')+".csv");

% save(fullfile("C:\Users\hyper\OneDrive\デスクトップ\VSCode\sotsuron_simulator\matlab_ws\1101\results",filename_csv),'-regexp','x');
% save(fullfile("C:\Users\hyper\OneDrive\デスクトップ\VSCode\sotsuron_simulator\matlab_ws\1101\results",filename_png),'-regexp','x');



disp("計算が完了しました．実験条件を表示します．")
disp("初期条件：")
disp("時刻:"+problem.bounds.initialTime.low+" ~ "+problem.bounds.initialTime.upp)
disp("座標:"+problem.bounds.initialState.low+" ~ "+problem.bounds.initialState.upp)
disp("終端条件：")
disp("時刻:"+problem.bounds.finalTime.low+" ~ "+problem.bounds.finalTime.upp)
disp("座標:"+problem.bounds.finalState.low+" ~ "+problem.bounds.finalState.upp)
disp("境界条件：")
disp("状態境界条件:"+problem.bounds.state.low+" ~ "+problem.bounds.state.upp)
disp("制御境界条件:"+problem.bounds.control.low+" ~ "+problem.bounds.control.upp)
disp("計算状況")
disp("soln.info.iterations:"+soln.info.iterations)
disp("soln.info.funcCount:"+soln.info.funcCount)
disp("soln.info.constrviolation:"+soln.info.constrviolation)
disp("soln.info.stepsize:"+soln.info.stepsize)
disp("soln.info.algorithm:"+soln.info.algorithm)
disp("soln.info.firstorderopt:"+soln.info.firstorderopt)
disp("soln.info.cgiterations:"+soln.info.cgiterations)
disp("soln.info.bestfeasible.fval:"+soln.info.bestfeasible.fval)
disp("soln.info.nlpTime:"+soln.info.nlpTime)
disp("soln.info.exitFlag:"+soln.info.exitFlag)


index=["初期時刻";"初期座標 x";"初期座標 y";"初期座標 theta";"終端時刻";"終端座標 x";"終端座標 y";"終端座標 theta";"状態境界 x";"状態境界 y";"状態境界 theta";"制御境界 v";"制御境界 omega";"soln.info.iterations";"soln.info.funcCount";"soln.info.constrviolation";"soln.info.stepsize";"soln.info.algorithm";"soln.info.firstorderopt";"soln.info.cgiterations";"soln.info.bestfeasible.fval";"soln.info.nlpTime";"soln.info.exitFlag"]
value=[problem.bounds.initialTime.low+" ~ "+problem.bounds.initialTime.upp;problem.bounds.initialState.low+" ~ "+problem.bounds.initialState.upp;problem.bounds.finalTime.low+" ~ "+problem.bounds.finalTime.upp;problem.bounds.finalState.low+" ~ "+problem.bounds.finalState.upp;problem.bounds.state.low+" ~ "+problem.bounds.state.upp;problem.bounds.control.low+" ~ "+problem.bounds.control.upp;soln.info.iterations;soln.info.funcCount;soln.info.constrviolation;soln.info.stepsize;soln.info.algorithm;soln.info.firstorderopt;soln.info.cgiterations;soln.info.bestfeasible.fval;soln.info.nlpTime;soln.info.exitFlag]

size(index)
size(value)

T=table(index,value)

writetable(T,filename_csv,'Encoding','UTF-8');

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                        Display Solution                                 %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
filename_png = string("results\"+datestr(now,'yymmdd_hhMMss')+".png");

n = length(soln.grid.time);
t = linspace(soln.grid.time(1), soln.grid.time(end), 15*(n-1)+1);
z = soln.interp.state(t);
u = soln.interp.control(t);

%%%% Plots:
figure(1); clf;
plotAll(t,z,u)

saveas(figure(1),filename_png)


%%%% Animations:

x_plot=z(1,:);
y_plot=z(2,:);
th_plot=z(3,:);
v_plot=u(1,:);

human_x=h.x0+h.v*t;
human_y=h.y0+0*t;
human_theta=h.th0+0*t;
human_v=abs(h.v)+0*t;


arrow_scale=5;
v_plot=arrow_scale*v_plot;
human_v=arrow_scale*human_v;

filename_mp4 = string("results\"+datestr(now,'yymmdd_hhMMss')+".mp4");
fig2 = figure(2); clf;
frames(length(x_plot)) = struct('cdata', [], 'colormap', []);

wall_right=plot([xmin,xmax],[ymin,ymin],'k');
hold on
wall_left=plot([xmin,xmax],[ymax,ymax],'k');
hold on
robot_position = plot(x_plot(1),y_plot(1),'ob','MarkerSize',15);
hold on
arrow = quiver(x_plot(1), y_plot(1), v_plot(1)*cos(th_plot(1)), v_plot(1)*sin(th_plot(1)));
hold on
human_position = plot(human_x(1),human_y(1),'or','MarkerSize',15);
hold on
human_arrow = quiver(human_x(1), human_y(1), human_v(1)*cos(human_theta(1)), human_v(1)*sin(human_theta(1)));
hold on
arc_rad=linspace(th_plot(1)-c.phi,th_plot(1)+c.phi,length(th_plot));
r1_array=c.r1+0*t;
r2_array=c.r2+0*t;
arc_array_r1_x=r1_array.*cos(arc_rad)+x_plot(1);
arc_array_r1_y=r1_array.*sin(arc_rad)+y_plot(1);
arc_array_r2_x=r2_array.*cos(arc_rad)+x_plot(1);
arc_array_r2_y=r2_array.*sin(arc_rad)+y_plot(1);
arc_r1=plot(arc_array_r1_x,arc_array_r1_y,'g');
hold on
arc_r2=plot(arc_array_r2_x,arc_array_r2_y,'g');
hold on
arc_right=plot([arc_array_r1_x(1),arc_array_r2_x(1)],[arc_array_r1_y(1),arc_array_r2_y(1)],'g');
hold on
arc_left=plot([arc_array_r1_x(end),arc_array_r2_x(end)],[arc_array_r1_y(end),arc_array_r2_y(end)],'g');

xlim([xmin,xmax]);
ylim([ymin-2,ymax+2]);
daspect([1,1,1]);



for i = 1:length(x_plot)
    set(robot_position,'XData',x_plot(i),'YData',y_plot(i));
    set(human_position,'XData',human_x(i),'YData',human_y(i));
    set(arrow,'XData',x_plot(i),'YData', y_plot(i),'UData', v_plot(i)*cos(th_plot(i)),'VData', v_plot(i)*sin(th_plot(i)));
    set(human_arrow,'XData',human_x(i),'YData', human_y(i),'UData', human_v(i)*cos(human_theta(i)),'VData', human_v(i)*sin(human_theta(i)));
    arc_rad=linspace(th_plot(i)-c.phi,th_plot(i)+c.phi,length(th_plot));
    arc_array_r1_x=r1_array.*cos(arc_rad)+x_plot(i);
    arc_array_r1_y=r1_array.*sin(arc_rad)+y_plot(i);
    arc_array_r2_x=r2_array.*cos(arc_rad)+x_plot(i);
    arc_array_r2_y=r2_array.*sin(arc_rad)+y_plot(i);
    set(arc_r1,'XData',arc_array_r1_x,'YData',arc_array_r1_y);
    set(arc_r2,'XData',arc_array_r2_x,'YData',arc_array_r2_y);
    set(arc_right,'XData',[arc_array_r1_x(1),arc_array_r2_x(1)],'YData',[arc_array_r1_y(1),arc_array_r2_y(1)]);
    set(arc_left,'XData',[arc_array_r1_x(end),arc_array_r2_x(end)],'YData',[arc_array_r1_y(end),arc_array_r2_y(end)]);
    drawnow;
    frames(i)=getframe(fig2);
end

video=VideoWriter(filename_mp4,'MPEG-4');
open(video)
writeVideo(video, frames);
close(video)

filename_map_mp4 = string("results\"+datestr(now,'yymmdd_hhMMss')+"_map.mp4");
fig3 = figure(3); clf;
frames3(length(x_plot)) = struct('cdata', [], 'colormap', []);
map_x=linspace(xmin,xmax);
map_y=linspace(ymin-2,ymax+2);
[X,Y]=meshgrid(map_x, map_y);

Z=objF_nd_Plot(x_plot(1),y_plot(1),th_plot(1),X,Y,c);
func_map=contourf(X,Y,Z,10);
colormap(bone)
wall_right=plot([xmin,xmax],[ymin,ymin],'k');
hold on
wall_left=plot([xmin,xmax],[ymax,ymax],'k');
xlim([xmin,xmax]);
ylim([ymin-2,ymax+2]);
daspect([1,1,1]);

for i = 1:length(x_plot)
    Z=objF_nd_Plot(x_plot(i),y_plot(i),th_plot(i),X,Y,c);
    func_map=contourf(X,Y,Z,10);
    colormap(bone)
    daspect([1,1,1]);
    drawnow;
    frames3(i)=getframe(fig3);
end
video3=VideoWriter(filename_map_mp4,'MPEG-4');
open(video3)
writeVideo(video3, frames3);
close(video3)