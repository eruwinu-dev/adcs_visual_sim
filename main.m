 close;
format short g;

% declares the tags for user inputs
visual_tag = ["init_phi", "init_theta", "init_psi", "base_center_x", "base_center_y", "base_center_z", "base_radius", "base_height", "stand_height", "actuator_angle", "actuator_tilt"];
visual_tag_default = [0 0 0 0 0 0 5 0.5 2.5 45 35.264];

control_tag = ["Ip","I_motor", "I_wheel", "Kv", "Kt", "des_phi", "des_theta", "des_psi", "omega_i_x", "omega_i_y", "omega_i_z", "Tmax", "Ts"];
control_tag_default = [2.5 0.00725 25 0.07 0.07 80 40 60 0 0 0 500 10];

import_tag = ["desired_angle_x_im", "desired_angle_y_im", "desired_angle_z_im", "Ts_im", "Tmax_im"];
import_tag_default = [0 0 0 1 50];

lqr_tag = ["p", "Q", "R"];
lqr_tag_default = [1 1 10];

smc_tag = ["Ksmc", "G", "thickness"];
smc_tag_default = [0.3 0.1 0.1];

ib_tag = ["K1", "K2"];
ib_tag_default = [0.001 5];

% declares the variable names to be saved in the work space
var_list = ["time", "platform_angle", "platform_speed", "wheel_speed", "power"];
ui = figure('Name', 'ADCS 3D Simulation and Visualization Tool', 'Toolbar', 'none', 'Menubar', 'none','Resize','off','Position',get(0, 'Screensize'),'Visible', 'off');

% start of user inputs

panel_platform_actuator = uipanel('Title', 'Platform and Actuator Configuration', 'Position', [0.01 0.675 0.25 0.3]);

uicontrol('Parent', panel_platform_actuator, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.9 0.5 0.075],'String','Initial Attitude (roll,pitch,yaw)', 'HorizontalAlignment', 'left');
uicontrol('Parent', panel_platform_actuator, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.500 0.9 0.1250 0.075], 'String', visual_tag_default(1), 'Tag', visual_tag(1));
uicontrol('Parent', panel_platform_actuator, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.650 0.9 0.1250 0.075], 'String', visual_tag_default(2), 'Tag', visual_tag(2));
uicontrol('Parent', panel_platform_actuator, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.800 0.9 0.1250 0.075], 'String', visual_tag_default(3), 'Tag', visual_tag(3));

uicontrol('Parent', panel_platform_actuator, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.8 0.5 0.075],'String','Base Center (x,y,z)', 'HorizontalAlignment', 'left');
uicontrol('Parent', panel_platform_actuator, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.500 0.8 0.1250 0.075], 'String', visual_tag_default(4), 'Tag', visual_tag(4));
uicontrol('Parent', panel_platform_actuator, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.650 0.8 0.1250 0.075], 'String', visual_tag_default(5), 'Tag', visual_tag(5));
uicontrol('Parent', panel_platform_actuator, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.800 0.8 0.1250 0.075], 'String', visual_tag_default(6), 'Tag', visual_tag(6));

uicontrol('Parent', panel_platform_actuator, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.7 0.5 0.075],'String','Base Radius', 'HorizontalAlignment', 'left');
uicontrol('Parent', panel_platform_actuator, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.500 0.7 0.1250 0.075], 'String', visual_tag_default(7), 'Tag', visual_tag(7));

uicontrol('Parent', panel_platform_actuator, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.6 0.5 0.075],'String','Base Height', 'HorizontalAlignment', 'left');
uicontrol('Parent', panel_platform_actuator, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.500 0.6 0.1250 0.075], 'String', visual_tag_default(8), 'Tag', visual_tag(8));

uicontrol('Parent', panel_platform_actuator, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.5 0.5 0.075],'String','Stand Height', 'HorizontalAlignment', 'left');
uicontrol('Parent', panel_platform_actuator, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.500 0.5 0.1250 0.075], 'String', visual_tag_default(9), 'Tag', visual_tag(9));

uicontrol('Parent', panel_platform_actuator, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.4 0.5 0.075],'String','Actuator Angle (degrees)', 'HorizontalAlignment', 'left');
uicontrol('Parent', panel_platform_actuator, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.500 0.4 0.1250 0.075], 'String', visual_tag_default(10), 'Tag', visual_tag(10));

uicontrol('Parent', panel_platform_actuator, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.3 0.5 0.075],'String','Actuator Tilt (degrees)', 'HorizontalAlignment', 'left');
uicontrol('Parent', panel_platform_actuator, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.500 0.3 0.1250 0.075], 'String', visual_tag_default(11), 'Tag', visual_tag(11));

uicontrol('Parent', panel_platform_actuator, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.20 0.5 0.075],'String','Platform MMOI', 'HorizontalAlignment', 'left');
uicontrol('Parent', panel_platform_actuator, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.500 0.2 0.1250 0.075], 'String', control_tag_default(1), 'Tag', control_tag(1));

uicontrol('Parent', panel_platform_actuator, 'Units', 'normalized', 'Style', 'pushbutton', 'Position', [0 0.075 0.4 0.1], 'String', 'View 3D Model', 'Callback', {@view_3d,visual_tag}, 'Tag', 'run_simulator');

panel_motor = uipanel('Title', 'Actuator Electrical Model', 'Position', [0.01 0.525 0.25 0.15], 'Tag', 'panel_motor');

uicontrol('Parent', panel_motor, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.80 0.5 0.175],'String','Motor MMOI', 'HorizontalAlignment', 'left');
uicontrol('Parent', panel_motor, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.500 0.80 0.25 0.175], 'String', control_tag_default(2), 'Tag', control_tag(2));

uicontrol('Parent', panel_motor, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.6 0.5 0.175],'String','Wheel MMOI', 'HorizontalAlignment', 'left');
uicontrol('Parent', panel_motor, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.500 0.6 0.25 0.175], 'String', control_tag_default(3), 'Tag', control_tag(3));

uicontrol('Parent', panel_motor, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.4 0.5 0.175],'String','Voltage Constant', 'HorizontalAlignment', 'left');
uicontrol('Parent', panel_motor, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.500 0.4 0.25 0.175], 'String', control_tag_default(4), 'Tag', control_tag(4));

uicontrol('Parent', panel_motor, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.2 0.5 0.175],'String','Torque Constant', 'HorizontalAlignment', 'left');
uicontrol('Parent', panel_motor, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.500 0.2 0.25 0.175], 'String', control_tag_default(5), 'Tag', control_tag(5));

panel_des_time = uipanel('Title', 'Desired Attitude and Simulation Time', 'Position', [0.01 0.275 0.25 0.25], 'Tag', 'panel_des_time');
uicontrol('Parent', panel_des_time, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.85 0.5 0.1],'String','Desired Attitude (roll,pitch,yaw)', 'HorizontalAlignment', 'left');
uicontrol('Parent', panel_des_time, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.500 0.85 0.1250 0.1], 'String', control_tag_default(6), 'Tag', control_tag(6));
uicontrol('Parent', panel_des_time, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.650 0.85 0.1250 0.1], 'String', control_tag_default(7), 'Tag', control_tag(7));
uicontrol('Parent', panel_des_time, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.800 0.85 0.1250 0.1], 'String', control_tag_default(8), 'Tag', control_tag(8));

uicontrol('Parent', panel_des_time, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.725 0.5 0.1],'String','Initial Velocity (roll, pitch, yaw)', 'HorizontalAlignment', 'left');
uicontrol('Parent', panel_des_time, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.500 0.725 0.1250 0.1], 'String', control_tag_default(9), 'Tag', control_tag(9));
uicontrol('Parent', panel_des_time, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.650 0.725 0.1250 0.1], 'String', control_tag_default(10), 'Tag', control_tag(10));
uicontrol('Parent', panel_des_time, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.800 0.725 0.1250 0.1], 'String', control_tag_default(11), 'Tag', control_tag(11));

uicontrol('Parent', panel_des_time, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.60 0.5 0.1],'String','Sampling Time (s)', 'HorizontalAlignment', 'left');
uicontrol('Parent', panel_des_time, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.500 0.60 0.25 0.1], 'String', control_tag_default(12), 'Tag', control_tag(12));

uicontrol('Parent', panel_des_time, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.475 0.5 0.1],'String','Frame Speed', 'HorizontalAlignment', 'left');
uicontrol('Parent', panel_des_time, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.500 0.475 0.25 0.1], 'String', control_tag_default(13), 'Tag', control_tag(13));

panel_controller = uitabgroup('Position', [0.01 0.015 0.25 0.25], 'Tag', 'panel_controller');

tab_lqr = uitab('Parent', panel_controller, 'Title', 'Linear Quadratic');

uicontrol('Parent', tab_lqr, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.80 0.5 0.1],'String','Weighting Factor', 'HorizontalAlignment', 'left');
uicontrol('Parent', tab_lqr, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.500 0.80 0.25 0.1], 'String', lqr_tag_default(1), 'Tag', lqr_tag(1));

uicontrol('Parent', tab_lqr, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.675 0.5 0.1],'String','State-Cost Coefficient', 'HorizontalAlignment', 'left');
uicontrol('Parent', tab_lqr, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.500 0.675 0.25 0.1], 'String', lqr_tag_default(2), 'Tag', lqr_tag(2));

uicontrol('Parent', tab_lqr, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.550 0.5 0.1],'String','Control Matrix Coefficient', 'HorizontalAlignment', 'left');
uicontrol('Parent', tab_lqr, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.500 0.550 0.25 0.1], 'String', lqr_tag_default(3), 'Tag', lqr_tag(3));

uicontrol('Parent', tab_lqr, 'Units', 'normalized', 'Style', 'pushbutton', 'Position', [0 0.325 0.4 0.125], 'String', 'Simulate Using LQR', 'Callback', {@simulate_controller,lqr_tag, control_tag, visual_tag, var_list}, 'Tag', 'run_sim_lqr');

tab_smc = uitab('Parent', panel_controller, 'Title', 'Sliding Mode');

uicontrol('Parent', tab_smc, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.8 0.5 0.1],'String','SMC Constant', 'HorizontalAlignment', 'left');
uicontrol('Parent', tab_smc, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.500 0.8 0.25 0.1], 'String', smc_tag_default(1), 'Tag', smc_tag(1));

uicontrol('Parent', tab_smc, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.675 0.5 0.1],'String','Gain', 'HorizontalAlignment', 'left');
uicontrol('Parent', tab_smc, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.500 0.675 0.25 0.1], 'String', smc_tag_default(2), 'Tag', smc_tag(2));

uicontrol('Parent', tab_smc, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.550 0.5 0.1],'String','Thickness', 'HorizontalAlignment', 'left');
uicontrol('Parent', tab_smc, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.500 0.550 0.25 0.1], 'String', smc_tag_default(3), 'Tag', smc_tag(3));

uicontrol('Parent', tab_smc, 'Units', 'normalized', 'Style', 'pushbutton', 'Position', [0 0.325 0.4 0.125], 'String', 'Simulate Using SMC ', 'Callback', {@simulate_controller,smc_tag, control_tag, visual_tag, var_list}, 'Tag', 'run_sim_smc');

tab_ib = uitab('Parent', panel_controller, 'Title', 'Integrator Backstepping');

uicontrol('Parent', tab_ib, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.8 0.5 0.1],'String','IB Constant 1', 'HorizontalAlignment', 'left');
uicontrol('Parent', tab_ib, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.500 0.8 0.25 0.1], 'String', ib_tag_default(1), 'Tag', ib_tag(1));

uicontrol('Parent', tab_ib, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.675 0.5 0.1],'String','IB Constant 2', 'HorizontalAlignment', 'left');
uicontrol('Parent', tab_ib, 'Units', 'normalized', 'Style', 'edit', 'Position', [0.500 0.675 0.25 0.1], 'String', ib_tag_default(2), 'Tag', ib_tag(2));

uicontrol('Parent', tab_ib, 'Units', 'normalized', 'Style', 'pushbutton', 'Position', [0 0.325 0.4 0.125], 'String', 'Simulate Using IB', 'Callback', {@simulate_controller,ib_tag, control_tag, visual_tag, var_list}, 'Tag', 'run_sim_ib');


% constructs the satelite adcs model from user inputs
[vertices, faces] = construct_sat_model(visual_tag_default(4:6),visual_tag_default(7), visual_tag_default(8), visual_tag_default(9), visual_tag_default(10), visual_tag_default(11));
% connect the vertices and lay out the faces
visual_plot = axes('Units', 'normalized', 'Position', [0.2 0.4 0.5 0.5], 'Tag', 'visual_plot');
sat_model = patch(visual_plot, 'Vertices', vertices, 'Faces', faces, 'FaceColor',[0 0 1]);
[axis_vector, axis_angle] = get_rotation(visual_tag_default(1),visual_tag_default(2),visual_tag_default(3));
if axis_angle ~= 0 
    rotate(sat_model,axis_vector, axis_angle,  visual_tag_default(4:6));
end
title('3D Visualization');
grid on;
view(3);
axis equal;    

[max_d, max_d_p] = maxk(sqrt(sum(vertices.^2,2)),1);
ax_lim = 1.1*[-max_d, max_d];
xlim(ax_lim)
ylim(ax_lim)
zlim(ax_lim)
xlabel('x axis')
ylabel('y axis')
zlabel('z axis')
view(3)
drawnow;

panel_response = uipanel('Title', 'Response Parameters', 'Position', [0.325 0.015 0.25 0.25], 'Tag', 'panel_response', 'Visible', 'off');    
ui.Visible = 'on';


% Callbacks ~ interrupts
function view_3d(~,~, tag_list) 
    % from clicking the View 3D Model button
    angle_plot = findobj(gcf, 'Tag', 'angle_plot');
    if ~isempty(angle_plot)
        delete(angle_plot);
    end
    speed_plot = findobj(gcf, 'Tag', 'speed_plot');
    if ~isempty(speed_plot)
        delete(speed_plot);
    end   
    wheel_plot = findobj(gcf, 'Tag', 'wheel_plot');
    if ~isempty(wheel_plot)
        delete(wheel_plot);
    end        
    panel_response = findobj(gcf, 'Tag', 'panel_response');
    if strcmp(panel_response.Visible, 'on')
        panel_response.Visible = 'off';
    end

    visual_plot = findobj(gcf, 'Tag', 'visual_plot');
    cla(visual_plot);
    
    form_val = form2val(tag_list);
    
    [vertices, faces] = construct_sat_model(form_val(4:6),form_val(7), form_val(8), form_val(9), form_val(10), form_val(11)); 
    
    [maxd, ~] = maxk(sqrt(sum(vertices.^2,2)),1);
    ax_lim = 1.1*[-maxd maxd];
    
    visual_plot.XLim = ax_lim;
    visual_plot.YLim = ax_lim;
    visual_plot.ZLim = ax_lim;    
    
    patch(visual_plot, 'Vertices', vertices, 'Faces', faces, 'FaceColor',[0 0 1]);
    drawnow;
end
function simulate_controller(src,~, coeff_tag, control_tag, visual_tag, var_list)
    % calls simulink to implement the chosen controller
    % shows the attitude, angular velocity, and wheel speed plots
    % shows the rotation of the model in 3D space
    angle_plot = findobj(gcf, 'Tag', 'angle_plot');
    if ~isempty(angle_plot)
        delete(angle_plot);
    end
    speed_plot = findobj(gcf, 'Tag', 'speed_plot');
    if ~isempty(speed_plot)
        delete(speed_plot);
    end    
    wheel_plot = findobj(gcf, 'Tag', 'wheel_plot');
    if ~isempty(wheel_plot)
        delete(wheel_plot);
    end     
    panel_response = findobj(gcf, 'Tag', 'panel_response');
    panel_response.Visible = 'off';
    platform_c = form2val(visual_tag);
    control_c = form2val(control_tag);
    coeff_c = form2val(coeff_tag);
    
    % save workspace variables for Simulink
    for a=1:3
        assignin('base', visual_tag(a), platform_c(a));        
    end
    for a=1:length(control_c)
        assignin('base', control_tag(a), control_c(a));                
    end
    for a=1:length(coeff_c)
        assignin('base', coeff_tag(a), coeff_c(a));
    end
    assignin('base', 'Lw', get_transformation_matrix(platform_c(end-1),platform_c(end)));
   % runs the simulink model for the chosen controller algorithm
    if strcmp(src.Tag, "run_sim_lqr")
        assignin('base', 'K_lqr', compute_k_lqr(coeff_c));
        sim_output = sim('lqr_c.slx', 'ReturnWorkspaceOutputs', 'on');
    elseif strcmp(src.Tag, "run_sim_smc")
        sim_output = sim('smc.slx', 'ReturnWorkspaceOutputs', 'on');        
    elseif strcmp(src.Tag, "run_sim_ib")
        sim_output = sim('backstepping.slx', 'ReturnWorkspaceOutputs', 'on');                
    end
    time = sim_output.t;
    assignin('base', var_list(1), time);   
    platform_angle = sim_output.euler;
    assignin('base', var_list(2), platform_angle); 
    platform_speed = sim_output.p_speed;
    assignin('base', var_list(3), platform_speed); 
    wheel_speed = sim_output.wheel_speed;
    assignin('base', var_list(4), wheel_speed);   
    power = sim_output.power;
    assignin('base', var_list(5), power);    
    
    % makes the satellite model
    desired_angle = control_c(6:8);
    [vertices, faces] = construct_sat_model(platform_c(4:6),platform_c(7), platform_c(8), platform_c(9), platform_c(10), platform_c(11)); 
    
    visual_plot = findobj(gcf, 'Tag', 'visual_plot');
    
    % shows attitude, angula velocity, and wheel speed graphs
    angle_plot = axes('Units', 'normalized', 'Position', [0.65 0.7 0.325 0.25], 'Tag', 'angle_plot');    
    grid on;
    title('Platform Attitude');
    xlim([0,time(end)]);
    ylim([min(min( platform_angle))-5 max(max( platform_angle))+5]);
    xlabel('time (s)');
    ylabel('degrees'); 
    hold on;

    speed_plot = axes('Units', 'normalized', 'Position', [0.65 0.375 0.325 0.25], 'Tag', 'speed_plot');    
    grid on;
    title('Platform Angular Velocity');
    xlim([0,time(end)]);
    ylim([min(min( platform_speed)) max(max( platform_speed))]);
    xlabel('time (s)');
    ylabel('degrees/s'); 
    hold on;  
    
    wheel_plot = axes('Units', 'normalized', 'Position', [0.65 0.05 0.325 0.25], 'Tag', 'wheel_plot');    
    grid on;
    title('Wheel Speed');
    xlim([0,time(end)]);
    ylim([min(min(wheel_speed)) max(max(wheel_speed))]);
    xlabel('time (s)');
    ylabel('rad/s'); 
    hold on;  
    
    cla(angle_plot);
    cla(speed_plot);
    cla(wheel_plot);
    cla(visual_plot);
   % 3d rotation
     visualize_rot(vertices, faces, platform_c(4:6), platform_angle, platform_speed, wheel_speed, time, visual_plot, angle_plot, speed_plot, wheel_plot, control_c(16));
     legend(angle_plot, {'roll','pitch','yaw'},'Location','northwest')
     legend(speed_plot, {'roll','pitch','yaw'},'Location','northeast')
     legend(wheel_plot, {'Wheel 1','Wheel 2','Wheel 3', 'Wheel 4'},'Location','northeast')

    % shows the response parameters 
    panel_response = findobj(gcf, 'Tag', 'panel_response');
    panel_response.Visible = 'on';
    
    platform_angle_params = stepinfo(platform_angle, time, platform_angle(end,:));
       
    uicontrol('Parent', panel_response, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.9 0.5 0.085],'String','Controller', 'HorizontalAlignment', 'center');
    uicontrol('Parent', panel_response, 'Units', 'normalized', 'Style', 'text', 'Position', [0.5 0.9 0.4 0.085],'String','(roll, pitch, yaw)', 'HorizontalAlignment', 'center', 'Tag', 'ss_error');
    ss_error_string = strjoin(string(round(abs((desired_angle - platform_angle(end,:))),2)),', ');   
    uicontrol('Parent', panel_response, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.8 0.5 0.085],'String','Steady State Error (deg)', 'HorizontalAlignment', 'center');
    uicontrol('Parent', panel_response, 'Units', 'normalized', 'Style', 'text', 'Position', [0.5 0.8 0.4 0.085],'String',ss_error_string, 'HorizontalAlignment', 'center', 'Tag', 'ss_error');

    rise_time = zeros(1,3);
    for x=1:3
        rise_time(x) = platform_angle_params(x,1).RiseTime;
    end
    rise_time_string = string(round(max(rise_time),2));
    
    uicontrol('Parent', panel_response, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.7 0.5 0.085],'String','Rise Time (s)', 'HorizontalAlignment', 'center');
    uicontrol('Parent', panel_response, 'Units', 'normalized', 'Style', 'text', 'Position', [0.5 0.7 0.4 0.085],'String',rise_time_string, 'HorizontalAlignment', 'center', 'Tag', 'rise_time');

    settling_time = zeros(1,3);
    for x=1:3
        settling_time(x) = platform_angle_params(x,1).SettlingTime;
    end
    settling_time_string = string(round(max(settling_time),2));
    
    uicontrol('Parent', panel_response, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.6 0.5 0.085],'String','Settling Time (s)', 'HorizontalAlignment', 'center');
    uicontrol('Parent', panel_response, 'Units', 'normalized', 'Style', 'text', 'Position', [0.5 0.6 0.4 0.085],'String',settling_time_string, 'HorizontalAlignment', 'center', 'Tag', 'settling_time');

    overshoot = zeros(1,3);
    for x=1:3
        overshoot(x) = platform_angle_params(x,1).Overshoot;
    end
    overshoot_string = string(round(max(overshoot),2));
    
    uicontrol('Parent', panel_response, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.5 0.5 0.085],'String','Overshoot (%)', 'HorizontalAlignment', 'center');
    uicontrol('Parent', panel_response, 'Units', 'normalized', 'Style', 'text', 'Position', [0.5 0.5 0.4 0.085],'String',overshoot_string, 'HorizontalAlignment', 'center', 'Tag', 'overshoot');

    power_string = string(round(max(power),3));
    
    uicontrol('Parent', panel_response, 'Units', 'normalized', 'Style', 'text', 'Position', [0 0.4 0.5 0.085],'String','Max Power (W)', 'HorizontalAlignment', 'center');
    uicontrol('Parent', panel_response, 'Units', 'normalized', 'Style', 'text', 'Position', [0.5 0.4 0.4 0.085],'String',power_string, 'HorizontalAlignment', 'center', 'Tag', 'overshoot');
    
    panel_response.Visible = 'on';
    
end
