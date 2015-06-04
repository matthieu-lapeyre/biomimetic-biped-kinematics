function [data, scale]= extract_human_kinematics_from_picture(picture, n_curves)

%% affichage de l'image
im = imread(picture);
image(im); axis image
hold on

%% Récupération de l'echelle
scale = ginput(4);


%% Dessin des differentes courbes
data = {};
for i = 1:n_curves
    
    xy = [];
    n = 0;
    but = 1;
    c = rand(3,1);
    
    while but == 1
        [xi,yi,but] = ginput(1);
        plot(xi,yi,'r*', 'MarkerSize', 10)
        n = n+1;
        xy(n,:) = [xi yi];
    end
    
    [~, id] = sort(xy(:,1));
    xy = xy(id,:);
    clf
    image(im); axis image
    hold on
    plot(xy(:,1), xy(:,2),'color','cyan','LineWidth',2.5 )
    
    data{i}=xy;
end

hold off