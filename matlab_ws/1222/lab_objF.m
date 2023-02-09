% lab_objF.m

% simulator for objF.m

clc;clear;clf;
sns=getSensorParams();
hmn=getHumanParams(sns);
norm_HR=linspace(0,sns.r2+2,100)



r_11=norm_HR>=sns.r1;
r_12=norm_HR<sns.r1+2*hmn.sizer;
r_1=r_11.*r_12;
score_r1=1/(2*hmn.sizer)*(norm_HR-sns.r1).*r_1;

% 頂上
r_21=norm_HR>=sns.r1+2*hmn.sizer;
r_22=norm_HR<sns.r2-2*hmn.sizer;
r_2=r_21.*r_22;
score_r2=1.*r_2;

% 下り
r_31=norm_HR>=sns.r2-2*hmn.sizer;
r_32=norm_HR<sns.r2;
r_3=r_31.*r_32;
score_r3=-1/(2*hmn.sizer)*(norm_HR-sns.r2).*r_3;

% まとめ
score_r=score_r1+score_r2+score_r3;
plot(norm_HR,score_r)
hold on


a_small=3;
smallside_sigmoid=(1+exp(-a_small*(norm_HR-sns.r1))).^(-1)-1;
a_big=-3;
bigside_sigmoid=(1+exp(-a_big*(norm_HR-sns.r2))).^(-1);

plot(norm_HR,smallside_sigmoid,'r');
hold on
plot(norm_HR,bigside_sigmoid,'b');
hold on
plot(norm_HR,smallside_sigmoid+bigside_sigmoid,'k');
% legend("small-side","big-side","sum");

phi=linspace(0,2*pi,100);

% a_small=10;
% smallside_sigmoid=(1+exp(a_small*(phi-sns.phi))).^(-1);
% a_big=a_small;
% bigside_sigmoid=(1+exp(-a_big*(phi-(2*pi-sns.phi)))).^(-1);

% figure(1),clf;
% plot(phi,smallside_sigmoid,'r');
% hold on
% plot(phi,bigside_sigmoid,'b');
% hold on
% plot(phi,smallside_sigmoid+bigside_sigmoid,'k');
% legend("small-side","big-side","sum");