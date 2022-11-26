function J=objF_sum_minus(t,z,u,env,rbt,hmn,sns)
% hmn_path: array_like z
% z: [6,n]
% vec_HR: [2,n]
% norm_HR: [1,n]
% A,B: [1,n]


hmn_path=getHumanPath(t,hmn);
rbt_path=z;

vec_HR=[hmn_path(1,:);hmn_path(2,:)]-[rbt_path(1,:);rbt_path(2,:)];
e=[cos(z(3,:));sin(z(3,:))];
% norm_HR=vecnorm(vec_HR,length(vec_HR(1)),1);
norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);
vec_HR=(norm_HR-hmn.sizer)./norm_HR.*vec_HR;
norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);

naiseki=dot(e,vec_HR,1);

e_vec_th=naiseki./norm_HR;
% valid_checker=e_vec_th<=1;
% compensate=1-valid_checker;
% e_vec_th=e_vec_th.*valid_checker+compensate;
% valid_checker=e_vec_th>=-1;
% compensate=valid_checker-1;
% e_vec_th=e_vec_th.*valid_checker+compensate;

% deg_diff=acos(e_vec_th) % 入力:-1~1, 出力:0~pi
deg_HR=atan(vec_HR(2,:)./vec_HR(1,:));
% deg_compensate=deg_HR<0;
deg_compensate=vec_HR(1,:)<0;
deg_HR=deg_HR+pi*deg_compensate;
deg_diff=deg_HR-z(3,:);

mu_A=(sns.r1+sns.r2)/2;
mu_B=0;
sgm_A=1/6*(sns.r2-sns.r1);
sgm_B=1/6*2*sns.phi;

A=pdf('Normal',norm_HR,mu_A,sgm_A);
B=pdf('Normal',deg_diff,mu_B,sgm_B);

% mu_Am=(0+sns.r1)/2;
mu_Am=0;
% mu_B_pi=pi;
sgm_Am=1/6*(sns.r1-0);
% sgm_B_pi=1/6*2*sns.phi;
% sgm_Am=1/6*(sns.r2-0);

Am=pdf('Normal',norm_HR,mu_Am,sgm_Am);
% B_pi=pdf('Normal',deg_diff,mu_B_pi,sgm_B_pi);
J_kari=(A-env.objF_minus_power*Am).*B;
% J_kari=(A-env.objF_minus_power*Am).*(B+B_pi);


% J=(J_kari+env.objF_nonzero).^(-1);
J=-J_kari;
end