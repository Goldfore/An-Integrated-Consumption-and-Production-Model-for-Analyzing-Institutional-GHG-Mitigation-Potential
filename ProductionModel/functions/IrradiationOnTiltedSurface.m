function [direct_irradiation, shade_irradiation, zenith_angle] = IrradiationOnTiltedSurface(GHI, DNI, DHI, albedo, day_in_year, hour_in_day, tilt_angle, azimuth, latitude, longitude, UTC)
        
        if (GHI>0 || DNI>0 || DHI>0)

        % POA Ground Reflected Calculation

            x1 = (360/365)*(284+day_in_year);
            lambda_angle = 23.45*sind(x1);

            Eg = max(0,GHI*albedo*((1-cosd(tilt_angle))/2));

        % POA Beam Calculation
            
            switch day_in_year
                case num2cell(1:106)
                    EQT = -14.2*sin(pi*(day_in_year+7)/111);
                case num2cell(107:166)
                    EQT = 4*sin(pi*(day_in_year-106)/59);
                case num2cell(167:246)
                    EQT = -6.5*sin(pi*(day_in_year-166)/80);
                case num2cell(247:365)
                    EQT = 16.4*sin(pi*(day_in_year-247)/113);
            end

            T_solar = hour_in_day + EQT/60 + (longitude-(UTC*15))/15;
            hour_angle = pi*(12-T_solar)/12;
            angle_of_incidence = acosd(sind(lambda_angle)*sind(latitude)*cosd(tilt_angle)...
                               -sind(lambda_angle)*cosd(latitude)*sind(tilt_angle)*cosd(azimuth)...
                               +cosd(lambda_angle)*cosd(latitude)*cosd(tilt_angle)*cos(hour_angle)...
                               +cosd(lambda_angle)*sind(latitude)*sind(tilt_angle)*cosd(azimuth)*cos(hour_angle)...
                               +cosd(lambda_angle)*sind(tilt_angle)*sind(azimuth)*sin(hour_angle)); % AOI

            Eb = DNI*cosd(angle_of_incidence);
            
        % POA Sky Diffuse Calculation (Perez Model)

            zenith_angle = acosd(sind(latitude)*sind(lambda_angle)+cosd(latitude)*cosd(lambda_angle)*cos(hour_angle));

            x2 = 2*pi*day_in_year/365;
            Io = 1361*(1.00011+0.034221*cos(x2)+0.00128*sin(x2)+0.000719*cos(2*x2)+0.000077*sin(2*x2)); % Extraterrestrial Radiation
            air_mass = 1/cosd(zenith_angle); % AMa
            delta = DHI*air_mass/Io;

            x3 = max(0, cosd(angle_of_incidence)); % a
            x4 = max(cosd(85), cosd(zenith_angle)); % b 
            x5 = 5.535*power(10,-6)*power(cosd(zenith_angle),3);

            epsilon = (((DHI+DNI)/DHI)+x5)/(1+x5);

            [f11, f12, f13, f21, f22, f23] = PerezModelfParmas(epsilon);
            F1 = max(0, f11+f12*delta+pi*(zenith_angle/180)*f13);
            F2 = f21+f22*delta+pi*(zenith_angle/180)*f23;

            Ed = DHI*((1-F1)*((1+cosd(tilt_angle))/2)+(F1*(x3/x4))+(F2*sind(tilt_angle)));
            
            % Total Irradiation

            direct_irradiation = Eg + Eb + Ed;
            shade_irradiation = Eg + Ed;

        else
            
            zenith_angle = 0;
            direct_irradiation = 0;
            shade_irradiation = 0;

        end
end