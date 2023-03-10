%% Read Data

    addpath("raw_data");
    addpath("functions");

    meteorological_data = readmatrix('meteorological_data_2019.csv','Range','E2:J8761');
    month_interval = readmatrix('meteorological_data_2019.csv','Range','B2:B8761');
    time_frames = readtable('meteorological_data_2019.csv','Range','D1:D25','ReadVariableNames',true);
    time_frames=table2array(time_frames);

    roofs_area = readmatrix('potential_areas.csv','Range','B2:B53');
    parking_area = readmatrix('potential_areas.csv','Range','D2:D9');
    north_campus_area = readmatrix('potential_areas.csv','Range','F2:F3');
    
    monthly_electricity_consumption = readmatrix('monthly_consumption_2019.csv','Range','AX2:BI2');
    hourly_electricity_consumption = readmatrix('hourly_consumption_2019.csv','Range','C2:C8761');
    
    coefficients = readmatrix('coefficients.csv','Range','B2:B6');

    panel_parameters = readmatrix('panel_parameters.csv','Range','B2:B6');

    model_parameters = readmatrix('model_parameters.csv','Range','B2:B15');

%% Coefficients
    
    emmission_coefficient = coefficients(1); % Co2 Kg/KWh (Dorad)
    kwh_price_coefficient = coefficients(2); % NIS/KWh (Dorad)
    kwh_storage_price = coefficients(3); % NIS/KWh (Storage)
    basic_kwh_peak_price = coefficients(4); % Installation Price
    complex_kwh_peak_price = coefficients(5); % Installation Price

%% Model Parameters
    
    latitude = model_parameters(1); % Be'er Sheva Meteorological Data (NREL)
    longitude = model_parameters(2); % Be'er Sheva Meteorological Data (NREL)
    UTC = model_parameters(3); % Israel Meteorological Data (NREL)
    inverter_efficiency = model_parameters(4); % SolarEdge Inverters
    azimuth = model_parameters(5); % South
    tilt_angle = model_parameters(6); % 22
    row_distance = model_parameters(7); % Millimeters
    frame_size = model_parameters(8); % Panels on top of each other

%% Panel Specifications

    initial_vmpp = panel_parameters(1);
    initial_impp = panel_parameters(2);
    temperature_coefficient_pmax = panel_parameters(3);
    panel_width = panel_parameters(4); % Millimeters
    panel_height = panel_parameters(5); % Millimeters

    peak_power = initial_vmpp*initial_impp;
    panel_size = (panel_height/1000)*(panel_width/1000); % Meters^2
    initial_panel_efficiency = peak_power/(panel_size*1000); % STC

%% Create Tables

    time_period = height(month_interval); % Number of Hours each Month

    temperature_interval = meteorological_data(:,1); % Temperature at any Hour of the Year
    GHI_interval = meteorological_data(:,2); % GHI at any Hour of the Year
    DNI_interval = meteorological_data(:,3); % DNI at any Hour of the Year
    DHI_interval = meteorological_data(:,4); % DHI at any Hour of the Year
    wind_speed_interval = meteorological_data(:,5); % Wind Speed at any Hour of the Year
    albedo_interval = meteorological_data(:,6); % Albedo at any Hour of the Year

    module_temperature = zeros(1,time_period);
    zenith_angle = zeros(1,time_period);
    direct_irradiation = zeros(1,time_period);
    shade_irradiation = zeros(1,time_period);
    total_irradiation = zeros(1,time_period);
    temperature_factor = zeros(1,time_period);
    module_efficiency = zeros(1,time_period);

    kwh_from_roofs = zeros(1,time_period);
    kwh_from_parking = zeros(1,time_period);
    kwh_from_north_campus = zeros(1,time_period);
    kwh_total = zeros(1,time_period);
    
    sum_area_roofs = sum(roofs_area);
    sum_area_parking = sum(parking_area);
    sum_area_north_campus = sum(north_campus_area);

    GCR_roofs = (panel_width*frame_size*cosd(tilt_angle))/(panel_width*frame_size*cosd(tilt_angle)+row_distance);
    GCR_parking = (panel_width*frame_size*cosd(tilt_angle))/(panel_width*frame_size*cosd(tilt_angle)+row_distance);
    GCR_north_campus = (panel_width*frame_size*cosd(tilt_angle))/(panel_width*frame_size*cosd(tilt_angle)+row_distance);

%% Calculations

    for i=1:time_period

        day_in_year = ceil(i/24);
        hour_in_day = mod(i,24);
        
        [direct_irradiation(i), shade_irradiation(i), zenith_angle(i)]  = IrradiationOnTiltedSurface(GHI_interval(i), DNI_interval(i), DHI_interval(i), albedo_interval(i), day_in_year, hour_in_day, tilt_angle, azimuth, latitude, longitude, UTC);
        total_irradiation(i) = IrradiationFollowingPanelPlacement(direct_irradiation(i), shade_irradiation(i), zenith_angle(i), panel_width*frame_size, tilt_angle, azimuth, row_distance);

        module_temperature(i) = temperature_interval(i) + (total_irradiation(i)/(25+(6.84*wind_speed_interval(i)))); % Feiman

        temperature_factor(i) = 1+(module_temperature(i)-25)*temperature_coefficient_pmax;
        
        module_efficiency(i) = initial_panel_efficiency*temperature_factor(i)*inverter_efficiency;

        kwh_from_roofs(i) = module_efficiency(i)*GCR_roofs*sum_area_roofs*total_irradiation(i)/1000;
        kwh_from_parking(i) = module_efficiency(i)*GCR_parking*sum_area_parking*total_irradiation(i)/1000;
        kwh_from_north_campus(i) = module_efficiency(i)*GCR_north_campus*sum_area_north_campus*total_irradiation(i)/1000;
        kwh_total(i) = kwh_from_roofs(i)+kwh_from_parking(i)+kwh_from_north_campus(i);
    end

    kwh_raw_distribution = KwhRawDistributionCalc(kwh_total);
    kwh_distribution = KwhMeanCalc(kwh_raw_distribution);

    consumption_raw_distribution = KwhRawDistributionCalc(hourly_electricity_consumption);
    consumption_distribution = KwhMeanCalc(consumption_raw_distribution);

%% Graphs

index = -1;
     
while(index~=0)

    index = input("\nMAIN\n\nProduction Per Month Organized by Sectors - 1\n" + ...
        "Production vs. Consumption Per Month - 2\nProduction vs. Consumption Per Hour - 3\n" + ...
        "Unused Energy Per Month - 4\nDesired Storage Amount - 5\nSaving Per Year - 6\n" + ...
        "Project Price - 7\n\nFINISH - 0\n");

    switch index

         case 1
            ProductionPerMonthBySectors(time_period, month_interval, kwh_from_roofs, kwh_from_parking, kwh_from_north_campus);
            index=0;

        case 2
            ProductionPerMonthVSConsumptionPerMonth(time_period, month_interval, kwh_total, monthly_electricity_consumption);
            index=0;

        case 3
            ProductionPerHourVSConsumptionPerHour(kwh_distribution, consumption_distribution, time_frames);
            index=0;

        case 4
            [electricity_production_per_month_total, unused_electricity_per_month_total] = UnusedElectricityPerMonth(time_period, month_interval, hourly_electricity_consumption, kwh_total);
            disp("Production Electricity: "+sum(electricity_production_per_month_total)+" Unused Electricity: "+sum(unused_electricity_per_month_total));
            index=0;

        case 5
            [avg_unused_electricity_per_month, monthly_max_unused_electricity, max_month_number] = AvgStoragePerMonth(kwh_distribution, consumption_distribution);
            battery_price = monthly_max_unused_electricity*kwh_storage_price;
            disp(max_month_number+" is the month in which we need to store the most electricity, we will need to store "+monthly_max_unused_electricity+" kWh at the peak");
            disp("A battery that can hold such an amount of electricity will cost "+battery_price+" Dollar");
            index=0;

        case 6
            [saving_carbon_emissions_per_year, saving_money_per_year] = SavingPerMonth(time_period, month_interval, emmission_coefficient, kwh_price_coefficient, hourly_electricity_consumption, kwh_total);
            disp("The Carbon Emissions in this Scenario were Reduced by "+saving_carbon_emissions_per_year+" Tons per Year");
            disp("The Money Saved in this Scenario is "+saving_money_per_year+" NIS per Year (without calculating the cost of the battery)");
            index=0;

        case 7

            tilted_panel_area = panel_size*frame_size*cosd(tilt_angle); 
            
            kw_peak_roofs = (floor((sum_area_roofs*GCR_roofs)/tilted_panel_area)*peak_power*frame_size)/1000;
            kw_peak_parking = (floor((sum_area_parking*GCR_parking)/tilted_panel_area)*peak_power*frame_size)/1000;
            kw_peak_north_campus = (floor((sum_area_north_campus*GCR_north_campus)/tilted_panel_area)*peak_power*frame_size)/1000;

            total_kw_peak = kw_peak_roofs + kw_peak_parking + kw_peak_north_campus;

            kwh_to_kw_peak = sum(kwh_total)/total_kw_peak;
            area_to_kw_peak = (sum_area_roofs + sum_area_parking + sum_area_north_campus)/total_kw_peak;

            roofs_price = kw_peak_roofs*basic_kwh_peak_price;
            parking_price = kw_peak_parking*complex_kwh_peak_price;
            north_campus_price = kw_peak_north_campus*basic_kwh_peak_price;
            total_price = roofs_price + parking_price + north_campus_price;

            disp("Roofs Price: "+roofs_price);
            disp("Parking Price: "+parking_price);
            disp("North Campus Price: "+north_campus_price);
            disp("Total Price: "+total_price);
            index=0;
    end
end