function [q_r, q_l, t_norm, pos_r, theta_foot_r, human_morphology] = human_walking_gait()

%% Bio-inspiration : Courbe de la marche humaine
% taille de la personne
h_man = 1.80;

% Input courbes experimentales
t_cycle = linspace(0,0.95,20);
hip_y_human = -1 * [32, 32, 31, 29.5, 26, 21, 15, 9, 3.5, -1, -6, -10, -12, -10, -4, 5, 17, 25, 31, 33]; 
knee_y_human = [0, 9, 17, 20, 19, 14, 9, 4, 1, 2, 6, 14, 30, 47, 62, 68, 60, 44, 25, 9];
ankle_y_human = [-4, -5, -7, -6, -3, 0.5, 2, 3.5, 5, 6.5, 7.5, 7, 4.5, -5, -15, -21, -16.5, -8, -3, -1.5];

plot(t_cycle, [hip_y_human; knee_y_human; ankle_y_human])
data = [0   14.1281   -0.9991   -7.6111
    0.0294   16.1090    4.1631   -9.1958
    0.0588   15.8572    6.3209  -10.1990
    0.0882   15.2198   11.4850   -7.1255
    0.1176   15.4901   15.9474   -3.4327
    0.1471   13.8973   16.6006   -0.8141
    0.1765   11.2785   15.5487    0.6386
    0.2059    9.6650   14.4872    1.3785
    0.2353    7.8267   12.6903    1.7776
    0.2647    5.9565   10.3185    2.0546
    0.2941    4.2827    8.0077    2.1651
    0.3235    2.6818    6.1569    2.4269
    0.3529    1.0282    4.8384    2.8732
    0.3824   -0.7463    3.9082    3.2525
    0.4118   -2.4843    3.2672    3.5124
    0.4412   -3.9733    3.3559    3.7684
    0.4706   -5.0346    4.8313    3.6664
    0.5000   -5.6242    7.8445    2.6295
    0.5294   -5.7265   12.4985    0.1779
    0.5588   -5.2353   19.3470   -4.7028
    0.5882   -3.9523   27.3604  -10.6275
    0.6176   -1.7580   38.3577  -16.4420
    0.6471    1.2777   46.9848  -19.7097
    0.6765    4.4350   54.2754  -18.9908
    0.7059    7.5582   57.3954  -15.2163
    0.7353   10.7306   58.1675  -12.2797
    0.7647   13.4134   57.0336   -9.4175
    0.7941   15.5191   53.3462   -7.9305
    0.8235   17.3614   47.6006   -6.4821
    0.8529   18.8125   37.5057   -6.1084
    0.8824   19.4520   26.8758   -6.6422
    0.9118   18.7446   13.5895   -7.7913
    0.9412   16.0055    3.8937   -8.3146
    0.9706   12.9831   -2.5609   -7.7015];

t_cycle = data(:,1)';
hip_y_human = -data(:,2)';
knee_y_human = data(:,3)';
ankle_y_human = data(:,4)';
% 
% hold on 
% plot(t_cycle, [hip_y_human; knee_y_human; ankle_y_human],'-.')

% Creation de la morphologie proportionnée:
human_morphology.l_foot = 0.75 * (0.152 *h_man);
human_morphology.l_heel = 0.25 * (0.152 *h_man);
human_morphology.h_foot = 0.043 * h_man;
human_morphology.l_leg = 0.2420 * h_man ;
human_morphology.l_thigh = 0.2450 * h_man ;
human_morphology.h_hip = 0.05 * h_man;

% Generation de cycles
for i=1:2
    hip_y_human = [hip_y_human, hip_y_human];
    knee_y_human = [knee_y_human, knee_y_human];
    ankle_y_human = [ankle_y_human, ankle_y_human];  
    t_cycle = [t_cycle, t_cycle+t_cycle(end)+diff(t_cycle(1:2))];
end

% Interpolation spline des differents joints
t_interp = 0:0.005:t_cycle(end);
lambda_interp = @(x) smooth(interp1(t_cycle,x,t_interp,'spline'),10)';

hip_y_interp = lambda_interp(hip_y_human); %interp1(t_cycle, hip_y_human, t_interp, 'cubic');
knee_interp =  lambda_interp(knee_y_human);
ankle_interp = lambda_interp(ankle_y_human);
plot(t_interp, [hip_y_interp; knee_interp; ankle_interp])

%% extraction du mouvement pour les deux jambes avec un dephasage de 50%

% jambe droite phase = 0
t0_r = find(t_interp >= 1, 1,'first');
tend_r = find(t_interp >= 2, 1,'first')-2; % on enlève la dernière valeur car 0%==100%

lambda_trunc_r = @(x) x(t0_r:tend_r);

r_hip_y_human     = lambda_trunc_r(hip_y_interp);
r_knee_y_human    = lambda_trunc_r(knee_interp);
r_ankle_y_human   = lambda_trunc_r(ankle_interp);


% jambe gauche phase = 50%
t0_l = find(t_interp >= 1.5, 1,'first');
tend_l = find(t_interp >= 2.5, 1,'first')-1; % on enlève la dernière valeur car 0%==100%

lambda_trunc_l = @(x) x(t0_l:tend_l);

l_hip_y_human     = lambda_trunc_l(hip_y_interp);
l_knee_y_human    = lambda_trunc_l(knee_interp);
l_ankle_y_human   = lambda_trunc_l(ankle_interp);

%% Return forward kinematic

t_norm = linspace(0,1,numel(r_hip_y_human)+1); t_norm = t_norm(1:end-1);
q_r = [r_hip_y_human; r_knee_y_human; r_ankle_y_human];
q_l = [l_hip_y_human; l_knee_y_human; l_ankle_y_human];

%% Return inverse kinematic

addpath('../kinematics_models/functions/')
for i=1:numel(t_norm)
    [pos_r(:,:,i), theta_foot_r(i)] = leg_fkine(q_r(:,i),human_morphology);
end

