%% Active Suspension Systems
clc; clear; close all;clearvars;

mc_sse = 300; % kg
kc_sse = 16000; % N/m
cc_sse = 1000; % N.s/m

% wheel values:
mw_sse = 60; % kg
kw_sse = 190000; % N/m
%cw_sse = 10; % N.s/m

sim = 10;
ts = 0.01;
t = 0:ts:sim;
ud = zeros(size(t));
ud(1:101) = 0.025*(1-cos(2*pi*t(1:101)));

% State Space Equation
A = [0 1 0 0; -(kc_sse/mc_sse) -(cc_sse/mc_sse) (kc_sse/mc_sse) (cc_sse/mc_sse); 0 0 0 1; (kc_sse/mw_sse) (cc_sse/mw_sse) -((kc_sse + kw_sse)/mw_sse) -(cc_sse/mw_sse)];
B = [0 0; (1/mc_sse) 0; 0 0; -(1/mw_sse) (kw_sse/ mw_sse)];
C = [1 0 0 0];
D = [0 0];

tsim = 0:ts:sim;
uc = zeros(size(tsim));
u = [uc; ud];
x0 = [0,0,0,0];
x = [1;1;1;1];
xdot = A*x + B*u;
Goal = ss(A,B,C,D);
y = lsim(Goal,u,tsim,x0);

i = 0:ts:sim;
subplot(2,1,1);
plot(i,y,'b',i,ud,'k:','LineWidth',2);
legend('System Response','Road Disturbance');
xlabel('Time(sec)');ylabel('Displacement(m)');
title('Body Car Mass');

subplot(2,1,2);
sys = ss(A,B,C,D);
lsim(sys,u,i);



