function [] = ProductionPerHourVSConsumptionPerHour(kwh_distribution, consumption_distribution, time_frames)
    
    selectd_month = input("Select Month\nJanuary - 1\nFebruary - 2\nMarch - 3\nApril - 4\nMay - 5\nJune - 6\nJuly - 7\nAugust - 8\nSeptember - 9\nOctober - 10\nNovember - 11\nDecember - 12\n");
    year = 2019;
    selectd_month_str = num2str(selectd_month);
    yearstr = num2str(year);
    title_month = strcat(selectd_month_str,'/',yearstr);
    
    month_kwh_distribution = kwh_distribution(selectd_month,:).';
    month_consumption_distribution = consumption_distribution(selectd_month,:).';

    y = [month_kwh_distribution(:), month_consumption_distribution(:)];
    plot(y,'-o','MarkerIndices',1:1:height(time_frames),'LineWidth',2.5);
    grid on;
    ax = gca;
    ax.FontSize = 22;
    xticklabels(transpose(time_frames));
    xticks(1:1:height(time_frames));
    legend('Average Electricity Production Potential','Average Electricity Consumption','Location','northwest','FontSize',20);
    %title(title_month, 'FontSize', 24);
    xlabel('Time', 'FontSize', 40);
    ylabel('kWh', 'FontSize', 40);
end

