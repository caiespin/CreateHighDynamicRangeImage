function pix_lin = pixel_fit(alpha,color_index,r,g,b)

    if color_index == 1
        pix_lin = alpha * r(1)+r(2)*alpha + r(3)*alpha^2 +r(4)*alpha^3;
    elseif color_index == 2
        pix_lin = alpha * b(1)+b(2)*alpha + b(3)*alpha^2 +b(4)*alpha^3;
    elseif color_index == 3
        pix_lin = alpha * g(1)+g(2)*alpha + g(3)*alpha^2 +g(4)*alpha^3;
    end
end