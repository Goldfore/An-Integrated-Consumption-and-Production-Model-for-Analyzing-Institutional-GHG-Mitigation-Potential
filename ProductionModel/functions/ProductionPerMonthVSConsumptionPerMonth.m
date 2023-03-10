function [] = ProductionPerMonthVSConsumptionPerMonth(time_period, month_interval, kwh_total, total_electricity_consumption)

    year = 2019;
    yearstr = num2str(year);
    electricity_production_per_month_total = zeros(1,12);

   for i=1:time_period
        electricity_production_per_month_total(month_interval(i)) = electricity_production_per_month_total(month_interval(i))+kwh_total(i);
   end

   x = (1:12);
   y = [electricity_production_per_month_total;total_electricity_consumption];
   bar(x,y);
   legend('Electricity Production Potential','Electricity Consumption');
   title(yearstr, 'FontSize', 24);
   xlabel('Months', 'FontSize', 18);
   ylabel('KWH', 'FontSize', 18);

end