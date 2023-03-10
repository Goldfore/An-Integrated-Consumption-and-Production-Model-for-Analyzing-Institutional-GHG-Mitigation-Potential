function [avg_unused_electricity_per_month, monthly_max_unused_electricity, max_month_number] = AvgStoragePerMonth(kwh_distribution, consumption_distribution)

    avg_unused_electricity_per_hour = zeros(height(kwh_distribution),width(kwh_distribution));

    for i=1:height(kwh_distribution)
        for j=1:width(kwh_distribution)
            avg_unused_electricity_per_hour(i,j) = max(0,kwh_distribution(i,j)-consumption_distribution(i,j));
        end
    end

    avg_unused_electricity_per_month = sum(avg_unused_electricity_per_hour,2);
    [monthly_max_unused_electricity, max_month_number] = max(avg_unused_electricity_per_month(:));
end