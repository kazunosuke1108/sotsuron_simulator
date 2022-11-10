function J=objF_01(t,z,u,env,rbt,hmn,sns)
% hmn_path: array_like z
% z: [6,n]
% vec_HR: [2,n]
% norm_HR: [1,n]
% A,B: [1,n]


hmn_path=getHumanPath(t,hmn);
rbt_path=z;

vec_HR=[hmn_path(1,:);hmn_path(2,:)]-[rbt_path(1,:);rbt_path(2,:)];
norm_HR=vecnorm(vec_HR,length(vec_HR(1)),1);



e=[cos(z(3,:));sin(z(3,:))];
naiseki=dot(e,vec_HR,1);

e_vec_th=acos(naiseki/norm_HR);
e_vec_th=rem(e_vec_th,2*pi);




J_kari_PW=piecewise(norm_HR<env.r_prh, -1, (sns.r1<norm_HR) & (norm_HR<sns.r2) & (-sns.phi<e_vec_th) & (e_vec_th<sns.phi), 1, 0)
J=(J_kari_PW+env.objF_nonzero).^(-1);

end