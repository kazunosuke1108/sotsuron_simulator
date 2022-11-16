function J=objF_01(t,z,u,env,rbt,hmn,sns)
% hmn_path: array_like z
% z: [6,n]
% vec_HR: [2,n]
% norm_HR: [1,n]
% A,B: [1,n]


hmn_path=getHumanPath(t,hmn);
rbt_path=z;

vec_HR=[hmn_path(1,:);hmn_path(2,:)]-[rbt_path(1,:);rbt_path(2,:)];
e=[cos(z(3,:));sin(z(3,:))];
vec_HR=(vecnorm(vec_HR,length(vec_HR(1)),1)-hmn.sizer)./vecnorm(vec_HR,length(vec_HR(1)),1).*vec_HR;   
norm_HR=vecnorm(vec_HR,length(vec_HR(1)),1);
% norm_HR=norm_HR-(hmn.sizer);

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
deg_compensate=deg_HR<0;
deg_HR=deg_HR+pi*deg_compensate;
deg_diff=deg_HR-z(3,:);


deg_judge1=deg_diff<=sns.phi;
deg_judge2=deg_diff>=-sns.phi;
deg_judge=deg_judge1.*deg_judge2;

rad_judge1=norm_HR>=sns.r1;
rad_judge2=norm_HR<=sns.r2;
rad_judge_penalty=norm_HR<=sns.r1;
rad_judge_penalty=-1*rad_judge_penalty;

rad_judge=rad_judge1.*rad_judge2+rad_judge_penalty;

J_kari_PW=deg_judge.*rad_judge

% syms norumu kakudo
% judger=piecewise(norumu<env.r_prh,-1,(sns.r1<norumu)&(norumu<sns.r2)&(-sns.phi<kakudo)&(kakudo<sns.phi),1,0);
% J_kari_PW=subs(judger,norumu,norm_HR,kakudo,deg_diff);


% J_kari_PW=piecewise(norm_HR<env.r_prh, -1, (sns.r1<norm_HR) & (norm_HR<sns.r2) & (-sns.phi<deg_diff) & (deg_diff<sns.phi), 1, 0)

J=(J_kari_PW+env.objF_nonzero).^(-1);



end