function [electricity_production_per_month_total,unused_electricity_per_month_total] = UnusedElectricityPerMonth(time_period, month_interval, hourly_electricity_consumption, kwh_total)

    year = 2019;
    yearstr = num2str(year);
    unused_electricity_per_month_total = zeros(1,12);
    electricity_production_per_month_total = zeros(1,12);

   for i=1:time_period

        electricity_production_per_month_total(month_interval(i)) = electricity_production_per_month_total(month_interval(i))+kwh_total(i);

       if (hourly_electricity_consumption(i) < kwh_total(i))
            unused_electricity_per_month_total(month_interval(i)) = unused_electricity_per_month_total(month_interval(i)) + kwh_total(i) - hourly_electricity_consumption(i);
       end

   end

   x = (1:12);
   y =  [electricity_production_per_month_total;unused_electricity_per_month_total];
   bar(x,y);
   ylim([1 5000000]);
   legend('Electricity Production Potential', 'Unused Electricity');
   title(yearstr, 'FontSize', 24);
   xlabel('Months', 'FontSize', 18);
   ylabel('KWH', 'FontSize', 18);

end