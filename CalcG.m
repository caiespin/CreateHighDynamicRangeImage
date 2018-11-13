function [g] = CalcG(mean_vals, T)
    fun = @(x,T)x(1)*T.^(1/x(2));
    x0 = [1600,1.5];
    x = lsqcurvefit(fun,x0,T,mean_vals);
    g = x;
end
