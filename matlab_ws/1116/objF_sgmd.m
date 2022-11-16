function J=objF_sgmd(t,z,u,env,rbt,hmn,sns)


hmn_path=getHumanPath(t,hmn);
rbt_path=z;

vec_HR=[hmn_path(1,:);hmn_path(2,:)]-[rbt_path(1,:);rbt_path(2,:)];
norm_HR=vecnorm(vec_HR,length(vec_HR(1)),1);
norm_HR=norm_HR-(hmn.sizer);

e=[cos(z(3,:));sin(z(3,:))];
naiseki=dot(e,vec_HR,1);

e_vec_th=naiseki./norm_HR;
valid_checker=e_vec_th<=1;
compensate=1-valid_checker;
e_vec_th=e_vec_th.*valid_checker+compensate;
valid_checker=e_vec_th>=-1;
compensate=valid_checker-1;
e_vec_th=e_vec_th.*valid_checker+compensate;
e_vec_th=acos(e_vec_th);
e_vec_th=rem(e_vec_th,2*pi);

r_small_sigmoid=2*(1+exp(-env.objF_sgmd_edge_power_r*(norm_HR-sns.r1))).^(-1)-1;
r_big_sigmoid=1*(exp(env.objF_sgmd_edge_power_r*(norm_HR-sns.r2))).^(-1);

phi_small_sigmoid=(1+exp(env.objF_sgmd_edge_power_phi*(e_vec_th-sns.phi))).^(-1);
phi_big_sigmoid=(1+exp(-env.objF_sgmd_edge_power_phi*(e_vec_th-(2*pi-sns.phi)))).^(-1);

A=r_small_sigmoid+r_big_sigmoid;
B=phi_small_sigmoid+phi_big_sigmoid;
J_kari=A.*B;
% J=-J_kari;
J=(J_kari+env.objF_nonzero).^(-1);

end