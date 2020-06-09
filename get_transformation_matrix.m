function [Lw] = get_transformation_matrix(angle,tilt)
    c_angle = cosd(angle);
    s_angle = sind(angle);
    c_tilt = cosd(tilt);
    s_tilt = sind(tilt);
    
    Lw = [c_tilt*c_angle -c_tilt*s_angle -c_tilt*c_angle  c_tilt*s_angle;
          c_tilt*s_angle -c_tilt*c_angle c_tilt*s_angle -c_tilt*c_angle;
          s_tilt s_tilt -s_tilt -s_tilt;
          ];
end

