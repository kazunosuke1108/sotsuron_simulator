function J=objF_sum_minus(t,z,u,env,rbt,hmn,sns)
% hmn_path: array_like z
% z: [6,n]
% vec_HR: [2,n]
% norm_HR: [1,n]
% A,B: [1,n]


hmn_path=getHumanPath(t,hmn);
rbt_path=z;

vec_HR=[hmn_path(1,:);hmn_path(2,:)]-[rbt_path(1,:);rbt_path(2,:)];
norm_HR=vecnorm(vec_HR,length(vec_HR(1)),1);
norm_HR=norm_HR-(rbt.sizer+hmn.sizer);

e=[cos(z(3,:));sin(z(3,:))];
naiseki=dot(e,vec_HR,1);

e_vec_th=acos(naiseki./norm_HR);
e_vec_th=rem(e_vec_th,2*pi);

mu_A=(sns.r1+sns.r2)/2;
mu_B=0;
sgm_A=1/6*(sns.r2-sns.r1);
sgm_B=1/6*2*sns.phi;

A=pdf('Normal',norm_HR,mu_A,sgm_A);
B=pdf('Normal',e_vec_th,mu_B,sgm_B);

% mu_Am=(0+sns.r1)/2;
mu_Am=0;
mu_B_2pi=2*pi;
sgm_Am=1/6*(sns.r1-0);
sgm_B_2pi=1/6*2*sns.phi;
% sgm_Am=1/6*(sns.r2-0);

Am=pdf('Normal',norm_HR,mu_Am,sgm_Am);
B_2pi=pdf('Normal',e_vec_th,mu_B_2pi,sgm_B_2pi);
J_kari=(A-env.objF_minus_power*Am).*(B+B_2pi);


% J=(J_kari+env.objF_nonzero).^(-1);
J=-J_kari;
end