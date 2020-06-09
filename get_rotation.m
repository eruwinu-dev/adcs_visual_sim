function [axis_vec, angle] = get_rotation(roll, pitch, yaw)
    q_vec = convert_quaternion(roll, pitch, yaw);
    qw = q_vec(1);
    qx = q_vec(2);
    qy = q_vec(3);
    qz = q_vec(4);
    axis_vec = q_vec(2:4)/norm(q_vec(2:4));
    angle = 2*atan2d(norm(q_vec(2:4)),q_vec(1));
end

