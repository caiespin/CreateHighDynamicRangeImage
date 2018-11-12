function [Im_Lin, g, scale] = Linearization(I, mean_vals, T)
    fun = @(x,T)x(1)*T.^(1/x(2));
    x0 = [1600,1.5];
    x = lsqcurvefit(fun,x0,T,mean_vals);
    I = double(I);
    g = x(2);
    scale = 255^g/255;
    Im_Lin = I.^g;
end

