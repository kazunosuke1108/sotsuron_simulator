function data=getFootprint(t,z,u,env,rbt,hmn,sns,soln)
    % 各離散時刻において，人が扇の中に入っていれば1,そうでなければ0を返す．これを[1,n]のリストで与える．

    hmn_path=getHumanPath(t,hmn);
    rbt_path=z;
    
    vec_HR=[hmn_path(1,:);hmn_path(2,:)]-[rbt_path(1,:);rbt_path(2,:)];
    norm_HR=vecnorm(vec_HR,length(vec_HR(1)),1);
    norm_HR=norm_HR-(hmn.sizer);

end