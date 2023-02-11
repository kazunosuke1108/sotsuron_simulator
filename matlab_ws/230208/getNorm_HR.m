function norm_HR=getNorm_HR(t,z,u,env,rbt,hmn,sns)
    hmn_path=getHumanPath(t,hmn);
    rbt_path=z;

    % footprint=getFootprint(t,z,u,env,rbt,hmn,sns); % 各時刻で足跡を取得出来たら1,ダメだったら0が返される
    % if nnz(footprint)>0
    %     success_list=find(footprint>0,nnz(footprint));
    %     first_success_idx=success_list(1);
    %     last_success_idx=success_list(end);
    %     continuous_check=all(footprint(first_success_idx:last_success_idx)>0);
    %     measured_length=abs(hmn_path(1,first_success_idx)-hmn_path(1,last_success_idx));
    % else
    %     measured_length=0;
    % end    
    vec_HR=[hmn_path(1,:);hmn_path(2,:)]-[rbt_path(1,:);rbt_path(2,:)];
    e=[cos(z(3,:));sin(z(3,:))];
    norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);
    vec_HR=(norm_HR-hmn.sizer)./norm_HR.*vec_HR;
    norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);
end