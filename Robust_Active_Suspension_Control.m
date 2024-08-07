%Robust Active Suspension Control
clc; clear; close all;clearvars;
% Physical parameters
m_car = 300;    % kg      mb
m_wheel = 60;   % kg    mw
c_car = 1000;   % N/m/s   bs
k_car = 16000 ; % N/m     ks
k_wheel = 190000; % N/m   kt
% State matrices
A = [ 0 1 0 0; [-k_car -c_car k_car c_car]/m_car ; 0 0 0 1; [k_car c_car -k_car-k_wheel -c_car]/m_wheel];
B = [ 0 0; 0 1e3/m_car ; 0 0 ; [k_wheel -1e3]/m_wheel];
C = [1 0 0 0; 1 0 -1 0; A(2,:)];
D = [0 0; 0 0; B(2,:)];
% A = [0 1 0 0; -(k_car/m_car) -(c_car/m_car) (k_car/m_car) (c_car/m_car); 0 0 0 1; (k_car/m_wheel) (c_car/m_wheel) -((k_car + k_wheel)/m_wheel) -(c_car/m_wheel)];
% B = [0 0; (1/m_car) 0; 0 0; -(1/m_wheel) (k_wheel/ m_wheel)];
% C = [1 0 0 0; 1 0 -1 0; A(2,:)];
% D = [0 0; 0 0; B(2,:)];

model_car = ss(A,B,C,D);  % 
model_car.StateName = {'Body Travel (m)';'Body Velocty (m/s)';'Wheel Travel (m)';'Wheel Velocty (m/s)'};
model_car.InputName = {'Disturbance';'Controller'}; % fs = controller r = disturbance
model_car.OutputName = {'x_car';'susp_defl';'accel_car'}; %x_car: body position,sd: suspension deflection, ab: body accel
tzero(model_car({'x_car','accel_car'},'Controller')); % returns the invariant zeros of MIMO dynamic system, sys. 
zero(model_car('susp_defl','Controller'));

% The hydraulic actuator used for active suspension control is connected between 
% the body mass mb and the wheel assembly mass mw. The nominal actuator dynamics 
% are represented by the first-order transfer function 1/(1+s/60) with a maximum displacement of 0.05 m.

ActNom = tf(1,[1/60 1]);

w_uncertainty = makeweight(0.40,15,3);
uncertainty = ultidyn('unc',[1 1],'SampleStateDim',5);
Act = ActNom*(1 + w_uncertainty*uncertainty);
Act.InputName = 'u';
Act.OutputName = 'Controller';

Wroad = ss(0.07);  Wroad.u = 'd1';   Wroad.y = 'Disturbance';
Wact = 0.8*tf([1 50],[1 500]);  Wact.u = 'u';  Wact.y = 'e1';
Wd2 = ss(0.01);  Wd2.u = 'd2';   Wd2.y = 'Wd2';
Wd3 = ss(0.5);   Wd3.u = 'd3';   Wd3.y = 'Wd3';

HandlingTarget = 0.04 * tf([1/8 1],[1/80 1]);
ComfortTarget = 0.4 * tf([1/0.45 1],[1/150 1]);

Targets = [HandlingTarget ; ComfortTarget];
bodemag(model_car({'susp_defl','accel_car'},'Disturbance')*Wroad,'b',Targets,'r--',{1,1000}), grid
title('Response to road disturbance')
legend('Open-loop','Closed-loop target')

% Three design points
beta = reshape([0.01 0.5 0.99],[1 1 3]);
Wsd = beta / HandlingTarget;
Wsd.u = 'susp_defl';  Wsd.y = 'e3';
Wab = (1-beta) / ComfortTarget;
Wab.u = 'accel_car';  Wab.y = 'e2';

susp_defl_measure  = sumblk('y1 = susp_defl+Wd2');
accel_car_measure = sumblk('y2 = accel_car+Wd3');
ICinputs = {'d1';'d2';'d3';'u'};
ICoutputs = {'e1';'e2';'e3';'y1';'y2'};
qcaric = connect(model_car(2:3,:),Act,Wroad,Wact,Wab,Wsd,Wd2,Wd3,susp_defl_measure,accel_car_measure,ICinputs,ICoutputs);

n_control = 1; % one control signal, u
n_measure = 2; % two measurement signals, sd and ab
K = ss(zeros(n_control,n_measure,3));
gamma = zeros(3,1);
for i=1:3
   [K(:,:,i),~,gamma(i)] = hinfsyn(qcaric(:,:,i),n_measure,n_control);
end

% Road disturbance
t = 0:0.0025:1;
roaddist = zeros(size(t));
roaddist(1:101) = 0.025*(1-cos(8*pi*t(1:101)));

% Closed-loop model
K.u = {'susp_defl','accel_car'};  
K.y = 'u';
SIMK = connect(model_car,Act.Nominal,K,'Disturbance',{'x_car';'susp_defl';'accel_car';'Controller'});

% Simulate
p1 = lsim(model_car(:,1),roaddist,t);
y1 = lsim(SIMK(1:4,1,1),roaddist,t);
y2 = lsim(SIMK(1:4,1,2),roaddist,t);
y3 = lsim(SIMK(1:4,1,3),roaddist,t);

% Plot results
subplot(2,1,1);
plot(t,p1(:,1),'b',t,y1(:,1),'r.',t,y2(:,1),'m.',t,y3(:,1),'k.',t,roaddist,'g');
title('Body travel'), ylabel('x_c_a_r (m)');
legend('Open-loop','Comfort','Balanced','Handling','Road Disturbance','location','NorthEast');
subplot(2,1,2);
plot(t,p1(:,3),'b',t,y1(:,3),'r.',t,y2(:,3),'m.',t,y3(:,3),'k.',t,roaddist,'g');
title('Body acceleration'), ylabel('accel_c_a_r (m/s^2)');
legend('Open-loop','Comfort','Balanced','Handling','Road Disturbance','location','NorthEast');


















