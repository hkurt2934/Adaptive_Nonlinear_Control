%% My Simulation
clc; clear; close all;clearvars;

sim = 10;
ts = 0.01;
t = 0:ts:sim;
number_of_sample = 1001;
ud = zeros(size(t));
t_new = t(1:number_of_sample);
% ud(1:101) = 0.3*(1-cos(2*pi*t(1:101)));
% ud(1:1001) = 0.01*sin(15*pi*t_new) + 0.02*sin(10*pi*t_new + pi/2) + 0.03*sin(pi*t_new);
ud(1:number_of_sample) = 0.02*sin(2*pi*t_new);
uc = zeros(size(t));
u = [uc; ud];

% Physical parameters
m_car = 320;    % kg
m_wheel = 40;   % kg
k_car = 18000 ; % N/m
k_wheel = 200000; % N/m
c_car = 1000;   % N/m/s
% c_wheel = 60;   % N/m/s

% State matrices
A = [ 0 1 0 0; [-k_car -c_car k_car c_car]/m_car ; 0 0 0 1; [k_car c_car (-k_car-k_wheel) -c_car]/m_wheel];
B = [ 0 0; 0 1/m_car ; 0 0 ; [-1 (k_wheel)]/m_wheel];
C = [1 0 0 0];
D = [0 0];

% subplot(2,1,1);
figure();
sys = ss(A,B,C,D);
disp(sys);
[b, a] = ss2tf(A,B,C,D,2);
sys_tf = tf(b, a);
disp(sys_tf);
% plot(t,lsim(sys,u,t),t,ud,'k:',LineWidth=1);
plot(t,lsim(sys,u,t),t,ud,LineWidth=2);
legend('System Response','Road Disturbance');
xlabel('Time(sec)');ylabel('Displacement(m)');
title('With State Space Equation');
grid on;


figure();
k_p = 0.01;
k_d = 10000;
c_pd = pid(k_p,0,k_d);
sys_feedback = feedback(c_pd*sys_tf,1);
disp(sys_feedback);
% [c_pi,info] = pidtune(sys_feedback,'PI');
step(sys_feedback);
figure();
margin(sys_feedback);

figure();
plot(t,lsim(sys_feedback,ud,t),t,ud);
legend('System Response','Road Disturbance');
xlabel('Time(sec)');ylabel('Displacement(m)');
title('With State Space Equation');
grid on;

%% Fuzzy:
clc;
input_labels = ["Error","Change_In_Error"];
output_labels = ["Control"];
rule_labels = ["NB","NS","Z","PS","PB"];

my_fis_1 = mamfis("Name","Active_Controller_FIS");
my_fis_1 = addInput(my_fis_1,[-1,1],"Name",input_labels(1));
my_fis_1 = addInput(my_fis_1,[-0.1,0.1],"Name",input_labels(2));
my_fis_1 = addOutput(my_fis_1,[-4000 4000],"Name",output_labels(1));

my_fis_1 = addMF(my_fis_1,input_labels(1),"trapmf", [-1, -1, -0.5, -0.2],"Name",rule_labels(1));
my_fis_1 = addMF(my_fis_1,input_labels(1),"gaussmf", [0.08, -0.15],"Name",rule_labels(2));
my_fis_1 = addMF(my_fis_1,input_labels(1),"gaussmf", [0.04, 0],"Name",rule_labels(3));
my_fis_1 = addMF(my_fis_1,input_labels(1),"gaussmf", [0.08, 0.15],"Name",rule_labels(4));
my_fis_1 = addMF(my_fis_1,input_labels(1),"trapmf", [0.2, 0.5, 1, 1],"Name",rule_labels(5));

my_fis_1 = addMF(my_fis_1,input_labels(2),"trapmf", [-0.1, -0.1, -0.05, -0.02],"Name",rule_labels(1));
my_fis_1 = addMF(my_fis_1,input_labels(2),"gaussmf", [0.008, -0.015],"Name",rule_labels(2));
my_fis_1 = addMF(my_fis_1,input_labels(2),"gaussmf", [0.004, 0],"Name",rule_labels(3));
my_fis_1 = addMF(my_fis_1,input_labels(2),"gaussmf", [0.008, 0.015],"Name",rule_labels(4));
my_fis_1 = addMF(my_fis_1,input_labels(2),"trapmf", [0.02, 0.05, 0.1, 0.1],"Name",rule_labels(5));

my_fis_1 = addMF(my_fis_1,output_labels(1),"trapmf", [-4000, -4000, -3000, -2500],"Name",rule_labels(1));
my_fis_1 = addMF(my_fis_1,output_labels(1),"gaussmf", [600, -2000],"Name",rule_labels(2));
my_fis_1 = addMF(my_fis_1,output_labels(1),"trimf", [-80, 0, 80],"Name",rule_labels(3));
my_fis_1 = addMF(my_fis_1,output_labels(1),"gaussmf", [600, 2000],"Name",rule_labels(4));
my_fis_1 = addMF(my_fis_1,output_labels(1),"trapmf", [2500, 3000, 4000, 4000],"Name",rule_labels(5));


ruleList = [1 1 1 1 1; 1 2 1 1 1; 1 3 2 1 1; 1 4 2 1 1; 1 5 3 1 1
            2 1 1 1 1; 2 2 2 1 1; 2 3 2 1 1; 2 4 3 1 1; 2 5 4 1 1
            3 1 2 1 1; 3 2 2 1 1; 3 3 3 1 1; 3 4 4 1 1; 3 5 4 1 1
            4 1 2 1 1; 4 2 3 1 1; 4 3 4 1 1; 4 4 4 1 1; 4 5 5 1 1
            5 1 3 1 1; 5 2 4 1 1; 5 3 4 1 1; 5 4 5 1 1; 5 5 5 1 1];
my_fis_1 = addRule(my_fis_1,ruleList);






%%

% [b, a] = ss2tf(A,B,C,D,2);
% 
% tf_sys = tf(b, a);
% %subplot(2,1,2);
% figure(2);
% plot(t,lsim(tf_sys,ud,t),t,ud,'k:',LineWidth=4);
% legend('System Response');
% xlabel('Time(sec)');ylabel('Displacement(m)');
% title('With Transfer Function');
% grid on;


% Test:



% https://www.mathworks.com/help/fuzzy/fuzzy-pid-control-with-type-2-fis.html
% https://www.mathworks.com/help/fuzzy/working-from-the-command-line.html