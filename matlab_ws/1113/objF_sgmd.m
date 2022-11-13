function J=objF_sgmd(t,z,u,env,rbt,hmn,sns,edge_power)

phi_powerup=1;

hmn_path=getHumanPath(t,hmn);
rbt_path=z;

vec_HR=[hmn_path(1,:);hmn_path(2,:)]-[rbt_path(1,:);rbt_path(2,:)];
norm_HR=vecnorm(vec_HR,length(vec_HR(1)),1);

e=[cos(z(3,:));sin(z(3,:))];
naiseki=dot(e,vec_HR,1);

e_vec_th=acos(naiseki./norm_HR);
e_vec_th=rem(e_vec_th,2*pi);

r_small_sigmoid=2*(1+exp(-edge_power*(norm_HR-sns.r1))).^(-1)-1.5;
r_big_sigmoid=1*(exp(edge_power*(norm_HR-sns.r2))).^(-1)-0.5;

phi_small_sigmoid=(1+exp(-edge_power*phi_powerup*(e_vec_th+sns.phi))).^(-1)-0.5;
phi_big_sigmoid=(1+exp(edge_power*phi_powerup*(e_vec_th-sns.phi))).^(-1)-0.5;

A=r_small_sigmoid.*r_big_sigmoid;
B=phi_small_sigmoid.*phi_big_sigmoid;
J_kari=A.*B;
J=(J_kari+env.objF_nonzero).^(-1)

end