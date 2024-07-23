mf_gauss_raod_1 = load("MF_5_Road_1.mat");
mf_tri_gauss_raod_1 = load("MF_6_Road_1.mat");
mf_tri_equ_raod_1 = load("MF_7_Road_1.mat");
mf_trape_raod_1 = load("MF_8_Road_1.mat");

mf_gauss_raod_2 = load("MF_5_Road_2.mat");
mf_tri_gauss_raod_2 = load("MF_6_Road_2.mat");
mf_tri_equ_raod_2 = load("MF_7_Road_2.mat");
mf_trape_raod_2 = load("MF_8_Road_2.mat");

accel_1_1 = mf_gauss_raod_1.out.Accleration;
accel_1_2 = mf_tri_gauss_raod_1.out.Accleration;
accel_1_3 = mf_tri_equ_raod_1.out.Accleration;
accel_1_4 = mf_trape_raod_1.out.Accleration;
road_2 = mf_gauss_raod_2.out.Road_Disturbance;
figure(1);
xlabel('Time (seconds)', 'FontWeight','bold');
ylabel('Car Body Acceleration (m/s^2)', 'FontWeight','bold');
grid( 'on');
hold( 'on');
plot(accel_1_2, 'LineWidth' , 2, 'Color', 'Red');
plot(accel_1_4, 'LineWidth' , 2, 'Color', 'Green');
plot(accel_1_3, 'LineWidth' , 2, 'Color', 'Black');
plot(accel_1_1, 'LineWidth' , 2, 'Color', 'Blue');
legend("Triangular Gaussion", "Trapezoidal", "Triangular Equal","Gaussian", 'FontWeight','bold');

accel_2_1 = mf_gauss_raod_2.out.Accleration;
accel_2_2 = mf_tri_gauss_raod_2.out.Accleration;
accel_2_3 = mf_tri_equ_raod_2.out.Accleration;
accel_2_4 = mf_trape_raod_2.out.Accleration;

figure(2);
xlabel('Time (seconds)', 'FontWeight','bold');
ylabel('Car Body Acceleration (m/s^2)', 'FontWeight','bold');
grid( 'on');
hold( 'on');
plot(accel_2_2, 'LineWidth' , 2, 'Color', 'Red');
plot(accel_2_4, 'LineWidth' , 2, 'Color', 'Green');
plot(accel_2_3, 'LineWidth' , 2, 'Color', 'Black');
plot(accel_2_1, 'LineWidth' , 2, 'Color', 'Blue');
legend("Triangular Gaussion", "Trapezoidal", "Triangular Equal","Gaussian", 'FontWeight','bold');

z_1_1 = mf_gauss_raod_1.out.Car_Displacement;
z_1_2 = mf_tri_gauss_raod_1.out.Car_Displacement;
z_1_3 = mf_tri_equ_raod_1.out.Car_Displacement;
z_1_4 = mf_trape_raod_1.out.Car_Displacement;
road_1 = mf_gauss_raod_1.out.Road_Disturbance;

figure(3);
xlabel('Time (seconds)', 'FontWeight','bold');
ylabel('Car Body Displacement (m)', 'FontWeight','bold');
grid( 'on');
hold( 'on');
plot(z_1_2, 'LineWidth' , 2, 'Color', 'Red');
plot(road_1, 'LineWidth' , 2, 'Color', 'Yellow');
plot(z_1_4, 'LineWidth' , 2, 'Color', 'Green');
plot(z_1_3, 'LineWidth' , 2, 'Color', 'Black');
plot(z_1_1, 'LineWidth' , 2, 'Color', 'Blue');
legend("Triangular Gaussion", "Road Disturbance", "Trapezoidal", "Triangular Equal","Gaussian", 'FontWeight','bold');
xlim([0,10]);
ylim([-0.05,0.15]);

z_2_1 = mf_gauss_raod_2.out.Car_Displacement;
z_2_2 = mf_tri_gauss_raod_2.out.Car_Displacement;
z_2_3 = mf_tri_equ_raod_2.out.Car_Displacement;
z_2_4 = mf_trape_raod_2.out.Car_Displacement;
road_2 = mf_gauss_raod_2.out.Road_Disturbance;

figure(4);
xlabel('Time (seconds)', 'FontWeight','bold');
ylabel('Car Body Displacement (m)', 'FontWeight','bold');
grid('on');
hold('on');
plot(z_2_2, 'LineWidth' , 2, 'Color', 'Red');
plot(road_2, 'LineWidth' , 2, 'Color', 'Yellow');
plot(z_2_4, 'LineWidth' , 2, 'Color', 'Green');
plot(z_2_3, 'LineWidth' , 2, 'Color', 'Black');
plot(z_2_1, 'LineWidth' , 2, 'Color', 'Blue');
legend("Triangular Gaussion", "Road Disturbance", "Trapezoidal", "Triangular Equal","Gaussian", 'FontWeight','bold');
xlim([0,10]);
ylim([-0.05,0.05]);

figure(5);
xlabel('Time (seconds)', 'FontWeight','bold');
ylabel('Car Body Acceleration (m/s^2)', 'FontWeight','bold');
grid( 'on');
hold( 'on');
plot(accel_2_2, 'LineWidth' , 2, 'Color', 'Red');
plot(accel_2_4, 'LineWidth' , 2, 'Color', 'Green');
plot(accel_2_3, 'LineWidth' , 2, 'Color', 'Black');
plot(accel_2_1, 'LineWidth' , 2, 'Color', 'Blue');
legend("Triangular Gaussion", "Trapezoidal", "Triangular Equal","Gaussian", 'FontWeight','bold');
xlim([0,10]);
ylim([-1,1]);
%%
figure(6);
road_2_1 = road_2;
road_2_1.Data = 0;
xlabel('Time (seconds)', 'FontWeight','bold');
ylabel('Road Disturbance (m)', 'FontWeight','bold');
grid( 'on');
hold( 'on');
plot(road_1, 'LineWidth' , 3, 'Color', 'Red');
xlim([0,10]);
ylim([-0.05,0.15]);

%%
figure(7);
road_2_1 = road_2;
road_2_1.Data = 0;
xlabel('Time (seconds)', 'FontWeight','bold');
ylabel('Road Disturbance (m)', 'FontWeight','bold');
grid('on');
hold('on');
plot(road_2_1, 'LineWidth' , 1.5, 'Color', 'Black');
plot(road_2, 'LineWidth' , 3, 'Color', 'Red');
xlim([0,10]);
ylim([-0.05,0.15]);





