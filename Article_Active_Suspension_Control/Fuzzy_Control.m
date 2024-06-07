% clc;
% model = 'comparepidcontrollers';
% load_system(model)
% 
% C = 0.85;
% L = 0.6;
% T = 0.6;
% G = tf(C,[T 1],'Outputdelay',L);
% 
% out5 = sim(model);
% plotTitle = ['Nominal: C=' num2str(C) ', L='  num2str(L) ', T=' num2str(T)];
% plotOutput(out5,plotTitle)

%%
clc;
sim = 10;
ts = 0.01;
t = 0:ts:sim;
number_of_sample = 1001;
ud = zeros(size(t));
t_new = t(1:number_of_sample);
ud(1:number_of_sample) = 0.02*sin(2*pi*t_new);
ud_diff = diff(ud);
ud_diff(end + 1) = 0;

input_labels = ["Error","Change_In_Error"];
output_labels = "Control";
rule_labels = ["NB","NS","Z","PS","PB"];

my_fis_1 = mamfis("Name","Active_Controller_FIS");
my_fis_1 = addInput(my_fis_1,[-1,1],"Name",input_labels(1));
my_fis_1 = addInput(my_fis_1,[-0.1,0.1],"Name",input_labels(2));
my_fis_1 = addOutput(my_fis_1,[-4000 4000],"Name",output_labels);

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

result = evalfis(my_fis_1,[ud;ud_diff]);
disp(result);
plot(t_new, result, t_new,10000*ud);

%%








%%