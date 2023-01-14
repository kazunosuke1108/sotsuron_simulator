function [c, ceq, cGrad, ceqGrad]=constraint(t,z,u,env,rbt,hmn,sns)
    hmn_path=getHumanPath(t,hmn);
    rbt_path=z;

    vec_HR=[hmn_path(1,:);hmn_path(2,:)]-[rbt_path(1,:);rbt_path(2,:)];
    e=[cos(z(3,:));sin(z(3,:))];
    norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);
    vec_HR=(norm_HR-hmn.sizer)./norm_HR.*vec_HR;
    norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);

    % 衝突回避制約1m
    close_HR=norm_HR<sns.r2;
    % c1=-((norm_HR-sns.r1).*close_HR).'-(1*(1-close_HR)).';
    c1=-(norm_HR-hmn.personal_r).';
    % c1=-(norm_HR-0.5).';
    % c1=-1;
    % 速度制約
    v=sqrt(rbt_path(4,:).^2+rbt_path(5,:).^2);
    norm_vel=(v-rbt.vmax).';


    c=[c1;
    norm_vel];
    % c=[norm_vel];
    ceq=[];

    nCst=2;
    nGrad=10;
    nTime=size(z,2);
    cGrad=zeros(nCst,nGrad,nTime);
    cGrad(1,2,:)=(hmn_path(1,:)-rbt_path(1,:))./norm_HR;
    cGrad(1,3,:)=(hmn_path(2,:)-rbt_path(2,:))./norm_HR;
    cGrad(2,5,:)=(rbt_path(4,:))./v;
    cGrad(2,6,:)=(rbt_path(5,:))./v;
    % cGrad=0;
    ceqGrad=[];
end