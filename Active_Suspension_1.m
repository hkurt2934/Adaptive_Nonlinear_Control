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

% Road Disturbance
c = 0;
a1 = 0.2;
a2 = 0.3;
for i = 0:ts:sim
    c = c + 1;
    if i < 0.5
        ud(c) = a1*(1-cos(4*pi*i));
    elseif i > 2 && i < 2.5
        ud(c) = a2*(1-cos(4*pi*i));
    elseif i > 4 && i < 4.5
        ud(c) = a1*(1-cos(4*pi*i));        
    else
        ud(c) = 0;
    end
end

A = [0 1 0 0; -(kc_sse/mc_sse) -(cc_sse/mc_sse) (kc_sse/mc_sse) (cc_sse/mc_sse); 0 0 0 1; (kc_sse/mw_sse) (cc_sse/mw_sse) -((kc_sse + kw_sse)/mw_sse) -(cc_sse/mw_sse)];
B = [0 0; (1/mc_sse) 0; 0 0; -(1/mw_sse) (kw_sse/ mw_sse)];
C = [1 0 0 0];
D = [0 0];

tsim = 0:ts:sim;
uc = zeros(size(tsim));
u = [uc; ud];

x0 = [0,0,0,0];
x = [1;1;1;1];

sprintf("%d",c);
xdot = A*x + B*u;
Goal = ss(A,B,C,D);
y = lsim(Goal,u,tsim,x0);

i = 0:ts:sim;
plot(i,y,'b',i,ud,'k:','LineWidth',2);
legend('System Response','Road Disturbance');
xlabel('Time(sec)');ylabel('Displacement(m)');
title('Body Car Mass');






