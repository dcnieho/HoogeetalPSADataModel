function [slope] = fitline(xdata,ydata)      	  

qnan            = isnan(xdata) | isnan(ydata);      % remove NaN
xdata           = xdata(~qnan);                     % remove NaN
ydata           = ydata(~qnan);                     % remove NaN
coeffs          = polyfit(xdata,ydata,1);
slope           = coeffs(1);
offset          = coeffs(2);
