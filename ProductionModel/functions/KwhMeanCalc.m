function kwh_distribution = KwhMeanCalc(kwh_raw_distribution)

    kwh_distribution = zeros(height(kwh_raw_distribution),width(kwh_raw_distribution));
    for i=1:height(kwh_raw_distribution)
        for j=1:width(kwh_raw_distribution)
            kwh_distribution(i,j) = mean(kwh_raw_distribution{i,j});
        end
    end
end

