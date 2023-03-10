function [total_irradiation] = IrradiationFollowingPanelPlacement(direct_irradiation, shade_irradiation, zenith_angle, L, tilt_angle, azimuth, row_distance)

        if (direct_irradiation>0 || shade_irradiation>0)
            
            sin_altitude_angle = cosd(zenith_angle);
            tan_altitude_angle = sin_altitude_angle/sqrt(1-sin_altitude_angle^2); % Trigonometric identity to tangents
            H = L * sind(tilt_angle); % Peak height of the panel from the ground
            D = H/tan_altitude_angle * cosd(azimuth); % Length of the Horizontal Shadow that the panel creates
            horizontal_shadow = max(0, D-row_distance); % Length of the Horizontal Shadow that the panel makes on the next row
            tilted_shadow = min(L, horizontal_shadow/cosd(tilt_angle));% Length of the Tilted Shadow that the panel makes on the next row
            shaded_panel_percentage = 1-((L - tilted_shadow)/L);% Percentage of Shaded part from the panel

            total_irradiation = (1-shaded_panel_percentage)*direct_irradiation...
                               + shaded_panel_percentage*shade_irradiation;

        else

            total_irradiation = 0;

        end 
end