function J=objF(t,z,u,env,rbt,hmn,sns)
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

mu_A=(sns.r1+sns.r2)/2;
mu_B=0;
sgm_A=1/6*(sns.r2-sns.r1);
sgm_B=1/6*2*norm_HR;

A=pdf('Normal',norm_HR,mu_A,sgm_A);
B=heaviside(naiseki).*pdf('Normal',naiseki,mu_B,sgm_B);

J=A.*B;

end