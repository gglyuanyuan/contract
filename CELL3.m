% 定义模拟参数
road_length = 100; % 道路长度
spawn_rate = 0.2; % 车辆生成率
num_time_steps = 200; % 模拟时间步数

% 初始化道路矩阵
road = zeros(2, road_length);

% 初始化车辆矩阵
car_positions = [road_length,2];

% 记录车道流量
flow_rates = [1,num_time_steps];

for t = 1:num_time_steps
    % 在道路上行驶的车辆数量
    num_cars_on_road = length(car_positions);
    % 计算当前道路的流量
    if t > 1
        flow_rate = sum(car_positions(:,1) == road_length & car_positions(:,2) == 1);
        flow_rates(t-1) = flow_rate;
    end
    % 判断车辆是否可以换道
    cars_on_left_lane = car_positions(:,2) == 2 & car_positions(:,1) > 1 & ...
        (car_positions(:,1) == road_length-2 | ...
        (car_positions(:,1) < road_length-2 & ...
        ~any(car_positions(:,1) == car_positions(:,1)' + 2 & ...
        abs(car_positions(:,2)-car_positions(:,2)') <= 1, 1)));
    cars_on_right_lane = car_positions(:,2) == 2 & car_positions(:,1) > 1 & ...
        (car_positions(:,1) == road_length-1 | ...
        (car_positions(:,1) < road_length-1 & ...
        ~any(car_positions(:,1) == car_positions(:,1)' + 1 & ...
        abs(car_positions(:,2)-car_positions(:,2)') <= 1, 1)));
    cars_to_change_lane = cars_on_left_lane & rand(size(cars_on_left_lane)) < 0.5 | ...
        cars_on_right_lane & rand(size(cars_on_right_lane)) < 0.5;
    car_positions(cars_to_change_lane,2) = 3 - car_positions(cars_to_change_lane,2);
    % 判断车辆是否可以前进
    cars_on_road = car_positions(:,1) < road_length & ...
        ~any(car_positions(:,1) == car_positions(:,1)' + 1 & ...
        abs(car_positions(:,2)-car_positions(:,2)') <= 1, 1);
    car_positions(cars_on_road,1) = car_positions(cars_on_road,1) + 1;
    % 判断是否要生成新车辆
    cars_to_spawn = rand(num_cars_on_road, 1) < spawn_rate;
    new_car_positions = [ones(sum(cars_to_spawn), 1), ...
        ones(sum(cars_to_spawn), 1)+1];
    car_positions = [car_positions; new_car_positions];
    % 将车辆在道路上的位置更新到道路
    road = zeros(2, road_length);
    for i = 1:length(car_positions)
        road(car_positions(i)) = 1;
    end
    % 显示当前道路情况

clf;
image(road+1);
axis off;
pause(0.1);
end
% 绘制车道流量变化
figure; 
plot(flow_rates);
xlabel('Time step'); 
ylabel('Flow rate');