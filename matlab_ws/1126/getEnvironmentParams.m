function env=getEnvironmentParams()

env.init_tmin=0;
env.init_tmax=0;
env.final_tmin=150;
env.final_tmax=150;

env.xmin=-5;
env.xmax=25;
env.ymin=-2.5;
env.ymax=2.5;

env.kabe.ymin=env.ymin;
env.kabe.ymax=env.ymax;


% env.avoid_dist=0;
env.L=20;
env.l=10;
% env.roi.xmin=10-env.l;
env.roi.xmin=0;
env.roi.xmax=env.roi.xmin+env.L;
env.roi.ymin=env.ymin;
env.roi.ymax=env.ymax;

% env.objF_nonzero=1e-3;
% env.objF_minus_power=1;
% env.objF_sgmd_edge_power_r=3;
% env.objF_sgmd_edge_power_phi=10;
% env.objF_if_edge_a_r=0.1;
% env.objF_if_edge_a_phi=0.5;

% env.r_prh=0.8;

end