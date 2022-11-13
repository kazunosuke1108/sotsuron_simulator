% lab_objF.m

% simulator for objF.m

clc;clear;
sns=getSensorParams();

r=linspace(0,sns.r2+2,100)

% a_small=3;
% smallside_sigmoid=2*(1+exp(-a_small*(r-sns.r1))).^(-1)-1.5;
% a_big=-3;
% bigside_sigmoid=(1+exp(-a_big*(r-sns.r2))).^(-1)-0.5;

% figure(1),clf;
% plot(r,smallside_sigmoid,'r');
% hold on
% plot(r,bigside_sigmoid,'b');
% hold on
% plot(r,smallside_sigmoid+bigside_sigmoid,'k');
% legend("small-side","big-side","sum");

phi=linspace(-sns.phi,sns.phi,100);

a_small=30;
smallside_sigmoid=(1+exp(-a_small*(phi+sns.phi))).^(-1)-0.5;
a_big=-30;
bigside_sigmoid=(1+exp(-a_big*(phi-sns.phi))).^(-1)-0.5;

figure(1),clf;
plot(phi,smallside_sigmoid,'r');
hold on
plot(phi,bigside_sigmoid,'b');
hold on
plot(phi,smallside_sigmoid+bigside_sigmoid,'k');
legend("small-side","big-side","sum");