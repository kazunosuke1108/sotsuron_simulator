function env=getEnvironmentParams()

env.hz=8; % 制御入力周波数

env.init_tmin=0;
env.init_tmax=0;
env.estim_final_t=150;
env.final_tmin=150;
env.final_tmax=150;

env.xmin=0;
env.xmax=10;
env.ymin=-4;
env.ymax=0;

env.kabe.ymin=env.ymin;
env.kabe.ymax=env.ymax;


% env.avoid_dist=0;
env.L=10;
env.l=5;
% env.roi.xmin=10-env.l;
env.roi.xmin=0;
env.roi.xmax=env.roi.xmin+env.L;
env.roi.ymin=env.ymin;
env.roi.ymax=env.ymax;

env.dist_hsr_zed=15;
env.dist_zed_hmn=1.5;
env.publish_time=10;

end