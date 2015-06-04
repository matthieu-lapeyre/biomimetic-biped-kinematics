function data = rescale_data(data, scale, angle_limits)

cycle = [min(scale(:,1)) max(scale(:,1))];
position = [max(scale(:,2)) min(scale(:,2))];

p = polyfit(position, angle_limits, 1);
actual_position = @(x) p(1).*x + p(2);

p = polyfit(cycle, [0 1], 1);
time_cycle = @(x) p(1).*x + p(2);

for i=1:numel(data)
    data{i}(:,1) = time_cycle(data{i}(:,1));
    data{i}(:,2) = actual_position(data{i}(:,2));
end