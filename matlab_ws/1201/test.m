hmn_path=getHumanPath(t,hmn);
rbt_path=z;

vec_HR=[hmn_path(1,:);hmn_path(2,:)]-[rbt_path(1,:);rbt_path(2,:)];
e=[cos(z(3,:));sin(z(3,:))];
norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);
vec_HR=(norm_HR-hmn.sizer)./norm_HR.*vec_HR;
norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);

min(norm_HR)
% 229~532