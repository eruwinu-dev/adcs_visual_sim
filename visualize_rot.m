function visualize_rot(vertices, faces, center, move_angle, move_speed, wheel_speed, time, visual_plot, angle_plot, speed_plot, wheel_plot, window)
    % for 3d visualizeion
    sat_model = patch(visual_plot, 'Vertices', vertices, 'Faces', faces, 'FaceColor',[0 0 1]);
    [maxd, ~] = maxk(sqrt(sum(vertices.^2,2)),1);
    ax_lim = 1.1*[-maxd maxd];

    visual_plot.XLim = ax_lim;
    visual_plot.YLim = ax_lim;
    visual_plot.ZLim = ax_lim;  
    
    initial_angle = move_angle(1,:);
    [axis_vector, axis_angle] = get_rotation(initial_angle(1),initial_angle(2),initial_angle(3));
    if axis_angle ~= 0 
        rotate(sat_model,axis_vector, axis_angle,  center);
    end
    drawnow;
    
    extra = rem(length(move_angle),window);
    levels = (length(move_angle)-extra)/window;
    get_windowth = move_angle(1:window:end,:);
    angle_diff = diff(get_windowth(1:end,:));
    for t = 1:levels+1
        if t == levels+1
            plot(angle_plot, time(1:end), move_angle(1:end,1), 'r' ,time(1:end), move_angle(1:end,2), 'g', time(1:end), move_angle(1:end,3),'b') 
            plot(speed_plot, time(1:end), move_speed(1:end,1), 'r' ,time(1:end), move_speed(1:end,2), 'g', time(1:end), move_speed(1:end,3),'b') 
            plot(wheel_plot, time(1:end), wheel_speed(1:end,1), 'r' ,time(1:end,1), wheel_speed(1:end,2), 'g', time(1:end,1), wheel_speed(1:end,3), 'b', time(1:end,1), wheel_speed(1:end,4), 'm')                
        else
            plot(angle_plot, time(1:window*t), move_angle(1:window*t,1), 'r' ,time(1:window*t), move_angle(1:window*t,2), 'g', time(1:window*t), move_angle(1:window*t,3),'b') 
            plot(speed_plot, time(1:window*t), move_speed(1:window*t,1), 'r' ,time(1:window*t), move_speed(1:window*t,2), 'g', time(1:window*t), move_speed(1:window*t,3),'b') 
            plot(wheel_plot, time(1:window*t,1), wheel_speed(1:window*t,1), 'r' ,time(1:window*t,1), wheel_speed(1:window*t,2), 'g', time(1:window*t,1), wheel_speed(1:window*t,3), 'b', time(1:window*t,1), wheel_speed(1:window*t,4), 'm')
            if t <= length(angle_diff)
                [axis_vector, axis_angle] = get_rotation(angle_diff(t,1),angle_diff(t,2),angle_diff(t,3));
                if(axis_angle ~= 0)
                    rotate(sat_model,axis_vector, axis_angle, center);
                end
            end
            drawnow;
        end
    end

end

