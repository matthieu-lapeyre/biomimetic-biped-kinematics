clear all

joint{1}.picture  = 'hip.png';
joint{1}.n_curves = 3;
joint{1}.angles_limits = [-10 20];

joint{2}.picture  = 'knee.png';
joint{2}.n_curves = 3;
joint{2}.angles_limits = [-10 60];

joint{3}.picture  = 'ankle.png';
joint{3}.n_curves = 3;
joint{3}.angles_limits = [-25 10];

for i=1:length(joint)
    [data, scale]= extract_human_kinematics_from_picture(joint{i}.picture, joint{i}.n_curves);
    joint{i}.data = rescale_data(data, scale, joint{i}.angles_limits);
end


save jointtest