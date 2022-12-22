sns=getSensorParams();
env=getEnvironmentParams();
rbt=getRobotParams();
hmn=getHumanParams(sns);

norm_HR=linspace(0,10,1000)
deg_diff=linspace(-pi,pi,1000)


%% r positive
% 上り
r_11=norm_HR>=sns.r1+2*hmn.sizer;
r_12=norm_HR<sns.r1+4*hmn.sizer;
r_1=r_11.*r_12;

score_r1=1/(2*hmn.sizer)*(norm_HR-(sns.r1+2*hmn.sizer)).*r_1;

% 頂上
r_21=norm_HR>=sns.r1+4*hmn.sizer;
r_22=norm_HR<sns.r2-4*hmn.sizer;
r_2=r_21.*r_22;

score_r2=1.*r_2;

% 下り
r_31=norm_HR>=sns.r2-4*hmn.sizer;
r_32=norm_HR<sns.r2-2*hmn.sizer;
r_3=r_31.*r_32;

score_r3=-1/(2*hmn.sizer)*(norm_HR-(sns.r2-2*hmn.sizer)).*r_3;

% まとめ
score_r=score_r1+score_r2+score_r3;
% plot(norm_HR,score_r)

%% phi positive
% 上り
p_11=deg_diff>=-sns.phi;
p_12=deg_diff<-sns.phi+hmn.sizep;
p_1=p_11.*p_12;

score_p1=1/hmn.sizep*(deg_diff+sns.phi).*p_1;

% 頂上
p_21=deg_diff>=-sns.phi+hmn.sizep;
p_22=deg_diff<sns.phi-hmn.sizep;
p_2=p_21.*p_22;

score_p2=1.*p_2;

% 下り
p_31=deg_diff>=sns.phi-hmn.sizep;
p_32=deg_diff<sns.phi;
p_3=p_31.*p_32;

score_p3=-1/hmn.sizep*(deg_diff-sns.phi).*p_3;

% まとめ
score_p=score_p1+score_p2+score_p3;
% plot(deg_diff,score_p)

%% penalty
% 底辺
pe_11=norm_HR>=0;
pe_12=norm_HR<sns.r1;
pe_1=pe_11.*pe_12;

score_pe1=-1.*pe_1;

% 上り
pe_21=norm_HR>=sns.r1;
pe_22=norm_HR<sns.r1+2*hmn.sizer;
pe_2=pe_21.*pe_22;

score_pe2=1/(2*hmn.sizer)*(norm_HR-(sns.r1+2*hmn.sizer)).*pe_2;

% まとめ
score_pe=score_pe1+score_pe2;
score_ans=score_r.*score_p+score_pe;
plot(deg_diff,score_p)