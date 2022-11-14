function env=getEnvironmentParams()

env.tmin=0;
env.tmax=90;

env.xmin=0;
env.xmax=18;
env.ymin=-2.5;
env.ymax=2.5;

env.kabe.ymin=env.ymin;
env.kabe.ymax=env.ymax;

env.L=5;
env.l=1;
env.roi.xmin=10-env.l;
env.roi.xmax=env.roi.xmin+env.L;
env.roi.ymin=env.ymin;
env.roi.ymax=env.ymax;

env.objF_nonzero=1e-3;
env.minus_power=1;
env.objF_sgmd_edge_power_r=3;
env.objF_sgmd_edge_power_phi=10;
env.objF_if_edge_a_r=0.1;
env.objF_if_edge_a_phi=0.5;

env.r_prh=0.8;

end