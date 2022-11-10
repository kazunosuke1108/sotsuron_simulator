% MAIN.m

% 青色領域を再定義してから計算を回す，ニュースタンダード

dirname="results\1109_path";
mkdir(dirname);


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                     Fundamental preparation                             %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

% clc; clear;
addpath 'C:\Users\hyper\OneDrive\デスクトップ\VSCode\sotsuron_simulator\matlab_ws\tutorial\cartPole'
addpath 'C:\Users\林出和之\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\tutorial\cartPole'
savename=string(dirname+"\"+datestr(now,'yymmdd_hhMMss'));

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                     Defenition of variables                             %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

env=getEnvironmentParams();
rbt=getRobotParams();
hmn=getHumanParams();
sns=getcSensorParams();

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                     Overwrite variables                                 %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

graph_title="Plot path test";




%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                     Set up function handles                             %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

problem.func.dynamics=@(t,z,u)(dynamics(z,u,env,rbt,hmn,sns));
problem.func.pathObj=@(t,z,u)(objF(t,z,u,env,rbt,hmn,sns));

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                     Set up problem bounds                               %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

problem.bounds.initialTime.low = env.tmin;
problem.bounds.initialTime.upp = env.tmin;
problem.bounds.finalTime.low = env.tmax;
problem.bounds.finalTime.upp = env.tmax;


problem.bounds.initialState.low = [rbt.x0;rbt.y0;rbt.th0;rbt.vx0;rbt.vy0;rbt.omg0];
problem.bounds.initialState.upp = [rbt.x0;rbt.y0;rbt.th0;rbt.vx0;rbt.vy0;rbt.omg0];
problem.bounds.finalState.low = [rbt.xF;rbt.yF;rbt.thFmin;rbt.vx0;rbt.vy0;rbt.omg0];
problem.bounds.finalState.upp = [rbt.xF;rbt.yF;rbt.thFmax;rbt.vx0;rbt.vy0;rbt.omg0];

problem.bounds.state.low = [rbt.x0;env.ymin;rbt.thFmin;rbt.vxmin;rbt.vymin;rbt.omgmin];
problem.bounds.state.upp = [rbt.xF;env.ymax;rbt.thFmax;rbt.vxmax;rbt.vymax;rbt.omgmax];

problem.bounds.control.low = [rbt.axmin;rbt.aymin;rbt.aangmin];
problem.bounds.control.upp = [rbt.axmax;rbt.aymax;rbt.aangmax];

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                    Initial guess at trajectory                          %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
problem.guess.time = [env.tmin,env.tmax];
problem.guess.state = [problem.bounds.initialState.low, problem.bounds.finalState.upp];
problem.guess.control = [0,0;0,0;0,0];

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

writeCSV(problem,env,rbt,hmn,sns,soln,savename);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                        Get Solution info                                %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

n = length(soln.grid.time);
t = linspace(soln.grid.time(1), soln.grid.time(end), 15*(n-1)+1);
z = soln.interp.state(t);
u = soln.interp.control(t);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                        Display Solution                                 %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

%%%% Human truth path
hmn_path=getHumanPath(t,hmn);

%%%% Robot observes human's velocity

vel_list=[];
rbt_vel=[rbt.vx0;rbt.vy0];

observed_hmn_old=hmn_path(1:2,1);
for i = 2:5
    observed_hmn=hmn_path(1:2,i);
    vel_list=[vel_list (observed_hmn-observed_hmn_old)/dt-rbt_vel]
    observed_hmn_old=observed_hmn;
end

vel_obs=mean(vel_list,2);
hmn.vx_obs=vel_obs(1);
hmn.vy_obs=vel_obs(2);

%%%% Define ROI

lm=env.roi.xmax-env.roi.xmin;
rbt.vx0=candidate;
rbt.vy0=0;

t0=(hmn_path(1,6)-lm)/(abs(hmn.vx_obs)+abs(rbt.vx0))

env.roi.xmin=rbt.vx0*t0;
env.roi.xmax=env.roi.xmin+lm



%%%% Plots:
figure(1); clf;
pltHistory(t,z,u,env,rbt,hmn,sns,soln,graph_title);
savename_png = savename+".png";
saveas(figure(1),savename_png);

%%%% Animation:

% figure(2); clf;
% title(graph_title)
% drawAnimation(t,z,u,env,rbt,hmn,sns,soln,savename,graph_title);

%%%% Potential map:
% figure(3); clf;
% drawPotential(t,z,u,env,rbt,hmn,sns,soln,savename);

%%%% Path:
figure(4); clf;
drawPath(t,z,u,env,rbt,hmn,sns,soln,savename,graph_title)
savename_path = savename+"path.png";
saveas(figure(4),savename_path);


% clc;clf;
% clearvars -except candidate candidate2 dirname;

git_auto_push()