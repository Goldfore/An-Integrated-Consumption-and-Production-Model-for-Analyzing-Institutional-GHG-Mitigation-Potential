function kwh_raw_distribution = KwhRawDistributionCalc(kwh_total)

    days_per_month = [31;28;31;30;31;30;31;31;30;31;30;31];
    kwh_raw_distribution = cell(12,24);
    day_sum=0;

    for i=1:12
        specific_time = zeros(1,days_per_month(i));
        for j=1:24
            day_index=j+day_sum;
            for k=1:days_per_month(i)
                specific_time(1,k) = kwh_total(day_index);
                day_index=day_index+24;
            end
            kwh_raw_distribution{i,j} = specific_time;
        end
        day_sum = day_sum+(24*days_per_month(i));
    end
end

