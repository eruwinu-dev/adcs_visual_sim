function [vertices, faces] = construct_sat_model(base_center,base_radius, base_height, stand_height, actuator_angle, actuator_tilt)
    number_actuators = 4;
    % construct base (octagon) first
    number_edges = 8;
    base = nsidedpoly(number_edges, 'Center', base_center(1:2), 'Radius', base_radius);
    base_vertices = [base.Vertices base_center(1,3)*ones(number_edges, 1); flipud([base.Vertices (base_center(1,3) + base_height)*ones(number_edges, 1)])];
    base_faces = [1 2 15 16; 2 3 14 15; 3 4 13 14; 4 5 12 13; 5 6 11 12; 6 7 10 11; 7 8 9 10; 8 1 16 9; 1 2 3 4; 5 6 7 8; 1 4 5 8; 13 14 15 16; 9 10 11 12; 9 12 13 16];    
    
    % find polygon midpoints for actuators
    actuator_bound = nsidedpoly(number_actuators, 'Center', base_center(1:2), 'Radius', base_radius);
    
    stand_centers = zeros(size(actuator_bound.Vertices));
    for x = 1:number_actuators
        if x == number_actuators
            stand_centers(x,:) = (actuator_bound.Vertices(number_actuators,:) + actuator_bound.Vertices(1,:))/2;
        else
            stand_centers(x,:) = (actuator_bound.Vertices(x,:) + actuator_bound.Vertices(x+1,:))/2;            
        end
    end
    stand_centers3 = [stand_centers (base_center(1,3) + base_height)*ones(number_actuators, 1)];
    
    % model 1 actuator, then copy the rest
    stand_length = 0.075*base_radius;
    stand_width = 0.25*base_radius;
    stand_submat = [-1 -1; -1 1; 1 1; 1 -1];
    stand_rect = [stand_length stand_width].*stand_submat;
    flap_submat = [-1 -1; -1 1; 4.5 1; 4.5 -1];
    flap_rect = [stand_length stand_width].*flap_submat;
    
    stand_bot = polyshape(stand_centers(1,:).*ones(size(stand_rect)) + stand_rect);
    stand_bot_vertices  = [stand_bot.Vertices (base_center(1,3) + base_height).*ones(length(stand_bot.Vertices),1)];
    
    flap = polyshape(stand_centers(1,:).*ones(size(flap_rect)) + flap_rect);
    flap_vertices  = [flap.Vertices (base_center(1,3) + base_height + stand_height).*ones(length(flap.Vertices),1)];
    
    [~,p_i] = maxk(sum(flap_vertices.^2,2),2);
    p_i = repmat((flap_vertices(p_i(1),:) + flap_vertices(p_i(2),:))/2, length(flap_vertices), 1);
    flap_tilted = (roty(sign(p_i(1,1))*actuator_tilt)*(flap_vertices - p_i)')' + p_i;
    
    stand_top_vertices  = [stand_bot.Vertices (base_center(1,3) + base_height + stand_height).*ones(length(stand_bot.Vertices),1)];
    
    % do top of actuator
    [piv, p_i] = maxk(flap_tilted(:,3),2);
    top_vertices = stand_top_vertices;
    top_vertices(:,3) = piv(1);
    [~, e1_i] = maxk(sum(top_vertices(:,1:2).^2,2),2);
    hor_offset = pdist([top_vertices(e1_i(1),:);flap_tilted(p_i(1),:)]);
    top_vertices = top_vertices + [hor_offset 0 0];    
    
    % copy 1st actuator to other
    actuator_vertices_i = [stand_bot_vertices;stand_top_vertices;top_vertices];
    actuator_vertices = actuator_vertices_i;
    actuator_faces_i = [1 2 3 4; 5 6 7 8; 1 4 8 5; 2 3 7 6; 3 4 8 7; 1 2 6 5; 9 10 11 12; 5 8 12 9; 6 7 11 10; 7 8 12 11; 5 6 10 9];    
    actuator_faces = actuator_faces_i;
    f_add = max(actuator_faces_i(:));
    actuator_tilt_i = -90;
    for x = 2:number_actuators;
        actuator_vertices = [actuator_vertices; (rotz(actuator_tilt_i)*(actuator_vertices_i - stand_centers3(1,:))')' + stand_centers3(x,:)];
        actuator_tilt_i = actuator_tilt_i - 90;
        actuator_faces = [actuator_faces; actuator_faces_i + (x-1)*f_add];
    end
    
    % rotate 
    actuator_vertices = (rotz(actuator_angle)*(actuator_vertices - base_center)')' + base_center;
   
    % finally, connect the base
    f_add = max(actuator_faces(:));
    
    vertices = [actuator_vertices; base_vertices];
    faces = [actuator_faces; base_faces + f_add];
end