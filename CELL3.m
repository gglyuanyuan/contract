% ����ģ�����
road_length = 100; % ��·����
spawn_rate = 0.2; % ����������
num_time_steps = 200; % ģ��ʱ�䲽��

% ��ʼ����·����
road = zeros(2, road_length);

% ��ʼ����������
car_positions = [road_length,2];

% ��¼��������
flow_rates = [1,num_time_steps];

for t = 1:num_time_steps
    % �ڵ�·����ʻ�ĳ�������
    num_cars_on_road = length(car_positions);
    % ���㵱ǰ��·������
    if t > 1
        flow_rate = sum(car_positions(:,1) == road_length & car_positions(:,2) == 1);
        flow_rates(t-1) = flow_rate;
    end
    % �жϳ����Ƿ���Ի���
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
    % �жϳ����Ƿ����ǰ��
    cars_on_road = car_positions(:,1) < road_length & ...
        ~any(car_positions(:,1) == car_positions(:,1)' + 1 & ...
        abs(car_positions(:,2)-car_positions(:,2)') <= 1, 1);
    car_positions(cars_on_road,1) = car_positions(cars_on_road,1) + 1;
    % �ж��Ƿ�Ҫ�����³���
    cars_to_spawn = rand(num_cars_on_road, 1) < spawn_rate;
    new_car_positions = [ones(sum(cars_to_spawn), 1), ...
        ones(sum(cars_to_spawn), 1)+1];
    car_positions = [car_positions; new_car_positions];
    % �������ڵ�·�ϵ�λ�ø��µ���·
    road = zeros(2, road_length);
    for i = 1:length(car_positions)
        road(car_positions(i)) = 1;
    end
    % ��ʾ��ǰ��·���

clf;
image(road+1);
axis off;
pause(0.1);
end
% ���Ƴ��������仯
figure; 
plot(flow_rates);
xlabel('Time step'); 
ylabel('Flow rate');