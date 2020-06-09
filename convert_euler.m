function [roll pitch yaw] = convert_euler(qvec)
    qw = qvec(1);
    qx = qvec(2);
    qy = qvec(3);
    qz = qvec(4);
    sinr_cosp = 2*(qw*qx + qy*qz);
    cosr_cosp = 1-2*(qx*qx + qy*qy);
    roll = atan2d(sinr_cosp, cosr_cosp);
        
    sinp = 2*(qw*qy-qz*qx);
    if(abs(sinp) >= 1)
        pitch = sign(sinp)*90;
    else
        pitch = asind(sinp);
    end
    
    siny_cosp = 2*(qw*qz + qx*qy);
    cosy_cosp = 1-2*(qy*qy +qz*qz);
    yaw = atan2d(siny_cosp, cosy_cosp);
end

