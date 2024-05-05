%% Quarter Car Suspension Model with only one damper
% car values:
mc_1 = 60; % kg
kc_1 = 23; % N/mm
cc_1 = 30; % N.s/mm

% wheel values:
mw_1 = 12; % kg
kw_1 = 700; % N/mm

%% Quarter Car Suspension Model with second damper
% car values:
mc_2 = 60; % kg
kc_2 = 23; % N/mm
cc_2 = 30; % N.s/mm

% wheel values:
mw_2 = 12; % kg
kw_2 = 700; % N/mm
cw_2 = 10:10:70; % N.s/mm
%% Robust Systems
% car values:
ms_robust = 60; % kg
ks_robust = 23; % N/mm
cs_robust = 70; % N.s/mm

% wheel values:
mu_robust = 12; % kg
ku_robust = 700; % N/mm
cu_robust = 10; % N.s/mm

t = 0:0.1:10; % s

cc = 30; % N.s/mm
Cc_30_ws = get(out,"Yc_1");
Cs_30_ws = get(out,"Yw_1");

%Cc_10_ws = get(out,"Cc_10");
%Cs_10_ws = get(out,"Cs_10");
%Cc_30_ws = get(out,"Cc_30");
%Cs_30_ws = get(out,"Cs_30");
% subplot(4,2,1);
% plot(Cc_10_ws)
% subplot(4,2,2);
% plot(Cs_10_ws)
% subplot(4,2,3);
% plot(Cc_30_ws)
% subplot(4,2,4);
% plot(Cs_30_ws)
% subplot(4,2,5);
% plot(Cc_50_ws)
% subplot(4,2,6);
% plot(Cs_50_ws)
% subplot(4,2,7);
% plot(Cc_70_ws)
% subplot(4,2,8);
% plot(Cs_70_ws)

%plot(cu_robust,t, Cc_10_ws,t);
%%
% M1 = 2500;
% M2 = 320;
% K1 = 80000;
% K2 = 500000;
% b1 = 350;
% b2 = 15020;
% 
% s = tf('s');
% G1 = ((M1+M2)*s^2+b2*s+K2)/((M1*s^2+b1*s+K1)*(M2*s^2+(b1+b2)*s+(K1+K2))-(b1*s+K1)*(b1*s+K1));
% G2 = (-M1*b2*s^3-M1*K2*s^2)/((M1*s^2+b1*s+K1)*(M2*s^2+(b1+b2)*s+(K1+K2))-(b1*s+K1)*(b1*s+K1));

%%
mc_sse = 300; % kg
kc_sse = 16000; % N/m
cc_sse = 1000; % N.s/m

% wheel values:
mw_sse = 60; % kg
kw_sse = 190000; % N/m
%cw_sse = 10; % N.s/m

sim = 1;
ts = 0.0025;
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
sprintf("%d",uc);
xdot = A*x + B*u;
Goal = ss(A,B,C,D);
y = lsim(Goal,u,tsim,x0);



%%





% plot(t,p1(:,1),'b',t,y1(:,1),'r.',t,y2(:,1),'m.',t,y3(:,1),'k.',t,roaddist,'g');
% legend('Open-loop','Comfort','Balanced','Handling','Road Disturbance','location','NorthEast');

plot(t,p1(:,1),'b',t,y1(:,1),'r.',t,y2(:,1),'m.',t,y3(:,1),'k.',t,roaddist,'g',t,y,'y');
legend('Open-loop','Comfort','Balanced','Handling','Road Disturbance','Active System','location','NorthEast');

% % Plot results
% subplot(2,1,1);
% plot(t,p1(:,1),'b',t,y1(:,1),'r.',t,y2(:,1),'m.',t,y3(:,1),'k.',t,roaddist,'g');
% title('Body travel'), ylabel('x_c_a_r (m)');
% legend('Open-loop','Comfort','Balanced','Handling','Road Disturbance','location','NorthEast');
% subplot(2,1,2);
% plot(t,p1(:,3),'b',t,y1(:,3),'r.',t,y2(:,3),'m.',t,y3(:,3),'k.',t,roaddist,'g');
% title('Body acceleration'), ylabel('accel_c_a_r (m/s^2)');
% legend('Open-loop','Comfort','Balanced','Handling','Road Disturbance','location','NorthEast');



%%
t = 0:0.04:8;
u = max(0,min(t-1,1));
sys = tf(3,[1 2 3]);
subplot(2,1,1);
lsim(sys,u,t);
grid on

A = [-3 -1.5; 5 0];
B = [1; 0];
C = [0.5 1.5];
D = 0;
t = 0:0.04:8;
u = max(0,min(t-1,1));
sys = ss(A,B,C,D);
subplot(2,1,2);
lsim(sys,u,t);
grid on

%%

% State Space Equation
A = [0 1 0 0; -(kc_sse/mc_sse) -(cc_sse/mc_sse) (kc_sse/mc_sse) (cc_sse/mc_sse); 0 0 0 1; (kc_sse/mw_sse) (cc_sse/mw_sse) -((kc_sse + kw_sse)/mw_sse) -(cc_sse/mw_sse)];
B = [0 0; (1/mc_sse) 0; 0 0; -(1/mw_sse) (kw_sse/ mw_sse)];
C = [1 0 0 0];
D = [0 0];

subplot(2,1,1);
lsim(sys,u,t);


