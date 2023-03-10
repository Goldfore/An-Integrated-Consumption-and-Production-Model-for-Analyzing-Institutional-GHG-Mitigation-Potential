function [] = ProductionPerMonthBySectors(time_period, month_interval, kwh_from_roofs, kwh_from_parking, kwh_from_north_campus)

    electricity_production_per_month_roofs = zeros(1,12);
    electricity_production_per_month_parking = zeros(1,12);
    electricity_production_per_month_north_campus = zeros(1,12);

   for i=1:time_period
        electricity_production_per_month_roofs(month_interval(i)) = electricity_production_per_month_roofs(month_interval(i))+kwh_from_roofs(i);
        electricity_production_per_month_parking(month_interval(i)) = electricity_production_per_month_parking(month_interval(i))+kwh_from_parking(i);
        electricity_production_per_month_north_campus(month_interval(i)) = electricity_production_per_month_north_campus(month_interval(i))+kwh_from_north_campus(i);
   end

   x = (1:12);
   y = [electricity_production_per_month_roofs;electricity_production_per_month_parking;electricity_production_per_month_north_campus];
   bar(x,y,'stacked','FaceColor','flat','EdgeColor','[0.5 0.5 0.5]','LineWidth',1.5);
   legend('Roofs', 'Parking', 'North Campus');
   title('Electricity Production Per Month', 'FontSize', 24);
   xlabel('Months', 'FontSize', 18);
   ylabel('KWH', 'FontSize', 18);

end