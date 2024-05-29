%% My Simulation
clc; clear; close all;clearvars;

sim = 10;
ts = 0.01;
t = 0:ts:sim;
ud = zeros(size(t));
ud(1:101) = 0.3*(1-cos(2*pi*t(1:101)));
uc = zeros(size(t));
u = [uc; ud];

% Physical parameters
m_car = 300;    % kg
m_wheel = 60;   % kg
k_car = 16000 ; % N/m
k_wheel = 190000; % N/m
c_car = 1000;   % N/m/s

% State matrices
A = [ 0 1 0 0; [-k_car -c_car k_car c_car]/m_car ; 0 0 0 1; [k_car c_car (-k_car-k_wheel) -c_car]/m_wheel];
B = [ 0 0; 0 1/m_car ; 0 0 ; [-1 k_wheel]/m_wheel];
C = [1 0 0 0];
D = [0 0];

%subplot(2,1,1);
figure(1);
sys = ss(A,B,C,D);
plot(t,lsim(sys,u,t),t,ud,'k:',LineWidth=4);
legend('System Response');
xlabel('Time(sec)');ylabel('Displacement(m)');
title('With State Space Equation');
grid on;

[b, a] = ss2tf(A,B,C,D,2);

tf_sys = tf(b, a);
%subplot(2,1,2);
figure(2);
plot(t,lsim(tf_sys,ud,t),t,ud,'k:',LineWidth=4);
legend('System Response');
xlabel('Time(sec)');ylabel('Displacement(m)');
title('With Transfer Function');
grid on;






