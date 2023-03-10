function [saving_carbon_emissions_per_year, saving_money_per_year] = SavingPerMonth(time_period, month_interval, emmission_coefficient, kwh_price_coefficient, hourly_electricity_consumption, kwh_total)

   saving_electricity_per_month = zeros(1,12);
   
   flag = input("\nWith Energy Storage - 1\nWithout Energy Storage - 0\n");
   
   if (flag == 0)
       for i=1:time_period
           if (hourly_electricity_consumption(i) < kwh_total(i))
                saving_electricity_per_month(month_interval(i)) = saving_electricity_per_month(month_interval(i)) + hourly_electricity_consumption(i);
           else
                saving_electricity_per_month(month_interval(i)) = saving_electricity_per_month(month_interval(i)) + kwh_total(i);
           end
       end
   else
       for i=1:time_period
           saving_electricity_per_month(month_interval(i)) = saving_electricity_per_month(month_interval(i)) + kwh_total(i);
       end
   end

   saving_carbon_emissions_per_month = saving_electricity_per_month*emmission_coefficient;
   saving_carbon_emissions_per_year = sum(saving_carbon_emissions_per_month)/1000;% KG to Ton

   saving_money_per_month = saving_electricity_per_month*kwh_price_coefficient;
   saving_money_per_year = sum(saving_money_per_month);

end