function K_dlqr = compute_k_lqr(coefficients)
    p = coefficients(1);
    Q = coefficients(2);
    R = coefficients(3);    
    zero_mtrx = zeros([3 3]);
    I = 2.5*eye(3);
    I_inv = inv(I);
    A = [zero_mtrx, 0.5*I; zero_mtrx,zero_mtrx];
    B = [zero_mtrx;I_inv];
    C = eye(6);
    Qmat = p*Q*C*C';
    Rmat = R*10*eye(3);

    K_dlqr = lqr(A,B,Qmat,Rmat);
end

