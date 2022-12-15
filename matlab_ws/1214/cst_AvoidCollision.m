function [c, ceq, cGrad, ceqGrad]=cst_AvoidCollision(t,z,u,env,rbt,hmn,sns)
    hmn_path=getHumanPath(t,hmn);
    rbt_path=z;

    vec_HR=[hmn_path(1,:);hmn_path(2,:)]-[rbt_path(1,:);rbt_path(2,:)];
    e=[cos(z(3,:));sin(z(3,:))];
    norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);
    vec_HR=(norm_HR-hmn.sizer)./norm_HR.*vec_HR;
    norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);

    % 衝突回避制約1m
    c1=-(norm_HR-1).';
    % 速度制約
    norm_vel=sqrt(rbt_path(4,:).^2+rbt_path(5,:).^2).'-rbt.vmax;


    c=[c1;
    norm_vel];
    ceq=[];

    cGrad=0;
    ceqGrad=[];
end