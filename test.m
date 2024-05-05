%% State Space Equations
% car values:
clc;
mc_sse = 300; % kg
kc_sse = 16000; % N/m
cc_sse = 1000; % N.s/m

% wheel values:
mw_sse = 60; % kg
kw_sse = 190000; % N/m
%cw_sse = 10; % N.s/m
sim = 10;
ts = 0.01;

% Road Disturbance
t = 0:0.01:10;
ud = zeros(size(t));
ud(1:101) = 0.3*(1-cos(2*pi*t(1:101)));

A = [0 1 0 0; -(kc_sse/mc_sse) -(cc_sse/mc_sse) (kc_sse/mc_sse) (cc_sse/mc_sse); 0 0 0 1; (kc_sse/mw_sse) (cc_sse/mw_sse) -((kc_sse + kw_sse)/mw_sse) -(cc_sse/mw_sse)];
B = [0 0; (1/mc_sse) 0; 0 0; -(1/mw_sse) (kw_sse/ mw_sse)];
C = [1 0 0 0];
D = [0 0];

tsim = 0:ts:sim;
uc = zeros(size(tsim));
u = [uc; ud];
%%u1 = [1; a1];
x0 = [0,0,0,0];
x = [1;1;1;1];
sprintf("%d",uc);
xdot = A*x + B*u;
Gol = ss(A,B,C,D);
y = lsim(Gol,u,tsim,x0);

i = 0:ts:sim;
plot(i,y,'b',i,ud,'k:','LineWidth',2);
legend('System Response','Road Disturbance');
xlabel('Time(sec)');ylabel('Displacement(m)');
title('Body Car Mass');