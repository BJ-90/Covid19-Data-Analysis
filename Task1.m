%% EN2106 - 2020 - Coursework
% Load and analyse data on coronavirus cases by country.
% Data was obtained from 
% https://www.ecdc.europa.eu/en/publications-data/download-todays-data-geographic-distribution-covid-19-cases-worldwide
% (accessed 19/11/20)

clear
close all
clc

% We could load the .csv file using the 'importdata' function as we met in
% the worksheets - but because of the mix of text and numeric datatypes
% within the spreadsheet of data, it is most convenient to load it into
% MATLAB as a 'table' datatype, which we can do with the 'readtable'
% function:
coviddata = readtable('ecdc_covid_data.csv');
% We can now access each column of the spreadsheet data by using a '.'
% followed by the column title. The easiest way to check the column titles
% is to double-click on the 'coviddata' variable in the Workspace and view
% the table in the Variable viewer.
% For example, we can access the 'population' column by typing:
%     coviddata.popData2019
% We will need to create plots with coviddata.dateRep along the x-axis, and in MATLAB
% the easiest way to do this is to use the 'datetime' datatype which is
% designed for this purpose. We can convert the first column of our table
% to this datatype with the following line:
coviddata.dateRep = datetime(coviddata.dateRep);

% We want to work mainly with the column of data which is titled:
% Cumulative_number_for_14_days_of_COVID_19_cases_per_100000/
% notification_rate_per_100000_population_14_days
% - this is rather a cumbersome variable-name to work with, so let's create
% a copy with a simpler name:
coviddata.cumul14 = coviddata.notification_rate_per_100000_population_14_days;

% Some of the country/territory names have underscores in them, so replace with spaces
coviddata.countriesAndTerritories = replace(coviddata.countriesAndTerritories,'_',' ');

% Create a list of the different countries/territories:
countries = unique(coviddata.countriesAndTerritories);
% Notice that the 'countries' variable is listed as a 'cell array' in the
% Workspace - and remember that we can access individual parts of a cell
% array using curly braces '{}' instead of round brackets '()'.
% E.g. 
% >>  countries{201}
%
%   ans = 
%
%       'United Kingdom'
%
% We will also see later that it can be useful sometimes to preserve the
% output in cell array format, which we can do using the round brackets:
% E.g.
% >> countries(201)
%
%  ans =
%
%    1x1 cell array
%
%     {'United Kingdom'}


%% Plot for a particular country

% double-clicking on 'countries' in the Workspace reveals that
% 
% 43 = China
% 201 = United Kingdom
% 204 = United States of America

iC = 1; % <- Change this manually to explore the curves for different countries
% Create a logical condition (1 = true, 0 = false) for whether each row of
% the table corresponds to this particular country or not. We need to use
% the 'strcmp' (i.e. 'string compare') function to test if two strings are equal, 
% because the double equals ('==') that we would use for numbers is not
% defined for strings/character arrays.
areRowsForThisCountry = strcmp(coviddata.countriesAndTerritories, countries{iC});
figure
plot(coviddata.dateRep(areRowsForThisCountry),coviddata.cumul14(areRowsForThisCountry),'linewidth',2);
grid on
title("Cumul14 value for country/territory: " + countries{iC})
ylabel('Cumulative cases over 14 days per 100,000')


%%
% You can complete Task 1 of the coursework by adding code below - making sure
% you use comments to indicate which sub-task each part of the code is used for

%% Task 1(a) – Find the 10 most populated countries
% Create an empty vector
Country_Population = zeros(size(countries));
for i = 1:size(countries)
    % Find population for country i in coviddata
    areRowsForThisCountry = strcmp(coviddata.countriesAndTerritories, countries{i});
    Population = coviddata.popData2019(areRowsForThisCountry);
    % Add population value in vector 
    Country_Population(i) = Population(1);
end
% Convert NaN with 0
Country_Population(isnan(Country_Population))=0;
% Change Country_Population into dscenndig order and record individual
% indices
[Pop_desc, I_pop] = sort(Country_Population, 'desc');
% Display Top10 countries with highest population
fprintf("Top10 Countries with Highest Population \n")
for j = 1:10
    % Create a vector to dispaly
    X = [countries(I_pop(j)),' population is ',Pop_desc(j)];
    disp(X)
end    
%% Task 1(b) – Create curves for the 5 most populous countries
figure
while true
    for k = 1:5
        areRowsForThisCountry = strcmp(coviddata.countriesAndTerritories, countries{I_pop(k)});
        hold on
        plot(coviddata.dateRep(areRowsForThisCountry),coviddata.popData2019(areRowsForThisCountry),'linewidth',2);
        grid on
        title("5 most Populous Countries")
        ylabel('Population')
        Legend{k} = countries{I_pop(k)}; % A vector that keeps individual country in each loop
    end
    legend(Legend,'Location','northwest')
    break
end
hold off

%% Task 1(c) – Find the countries with the highest maximum of cumulative cases per 14-days and create curves for the 5 highest
% Create an empty vector
cumul14_max = zeros(size(countries));
for i = 1:size(countries)
    % Find population for country i in coviddata
    areRowsForThisCountry = strcmp(coviddata.countriesAndTerritories, countries{i});
    Max_Cases = coviddata.popData2019(areRowsForThisCountry);
    % Add population value in vector 
    cumul14_max(i) = max(Max_Cases);
end
% Convert NaN with 0
cumul14_max(isnan(cumul14_max)) = 0;
% Remove countries with less than 1 million population from this comparison
Less_Populous_Countries = find(Country_Population < 1000000);
cumul14_max(Less_Populous_Countries) = 0;
% Change cumul14_max into dscenndig order and record individual
% indices
[cumul14_desc, I_cum] = sort(cumul14_max, 'desc');
% Display Top10 countries with highest cumul14
fprintf("Top10 countries with highest cumul14 \n")
for j = 1:10
    % Create a vector to dispaly
    Y = [countries(I_cum(j)),' has maximum cumulative cases per 14-days ',cumul14_desc(j)];
    disp(Y)
end

% Plot 5 countries with maximum of cumulative cases per 14-days
figure
while true
    for k = 1:5
        areRowsForThisCountry = strcmp(coviddata.countriesAndTerritories, countries{I_cum(k)});
        hold on
        plot(coviddata.dateRep(areRowsForThisCountry),coviddata.cumul14(areRowsForThisCountry),'linewidth',2);
        grid on
        title("5 Countries with highest maximum of Cumulative Cases")
        ylabel('Cumulative cases over 14 days per 100,000')
        Legend{k} = countries{I_cum(k)};
    end
    % Add graph for United Kingdom #201
    areRowsForThisCountry = strcmp(coviddata.countriesAndTerritories, countries{201});
    plot(coviddata.dateRep(areRowsForThisCountry),coviddata.cumul14(areRowsForThisCountry),'linewidth',2);
    Legend{6} = countries{201};
    legend(Legend,'Location','northwest')
    break
end
hold off

%% Task 1(d) – Find the first new countries that might have been added to a quarantine list
% Create a vector to store date 
Date = NaT(length(coviddata.dateRep),1);
% A vector to identify rows for cumul14 > 100 and date > 8th June 2020
Condition1 = (coviddata.cumul14 > 100) & (coviddata.dateRep > '08/06/2020');
disp_countries = 0;
has_displayed = 0; % condition that will avoid to repeat the loop
% countries that might have been added to a quarantine list
Q = [];
for i = 1:size(countries)
    % Identify rows for country i
    areRowsForThisCountry = strcmp(coviddata.countriesAndTerritories, countries{i});
    % Check if cumul14 > 100 on 08/06/2020
    Condition2 = (coviddata.cumul14 > 100) & (coviddata.dateRep == '08/06/2020');
    all_conditions = Condition1 & ~Condition2 & areRowsForThisCountry;
    % Add entries for the country that meet all conditions
    Date(all_conditions) = coviddata.dateRep(all_conditions);
    % Display 10 countries and add new countries on quarantine list Q
    if Date(all_conditions)~= NaT
        Q = [Q i];
        if disp_countries < 10
           disp_countries = disp_countries + 1;
           Date_to_display = Date(all_conditions);
           X = ['On ', char(Date_to_display(1)), ',  ', countries{i}, ' added to quarantien list'];
           disp(X)
        end
    end
    % Plot graph for 5/10 countries
%     if disp_countries == 5 & Date(all_conditions)~= NaT
    if disp_countries == 10 & Date(all_conditions)~= NaT & has_displayed == 0
        figure
        while true
%             for k = 1:5
            for k = 1:10
                areRowsForThisCountry = strcmp(coviddata.countriesAndTerritories, countries{Q(k)});
                hold on
                plot(coviddata.dateRep(areRowsForThisCountry),coviddata.cumul14(areRowsForThisCountry),'linewidth',2);
                grid on
%                 title("5 Countries added to quarantine list")
                title("10 Countries added to quarantine list")
                ylabel('Cumulative cases over 14 days per 100,000')
                QC{k} = countries{Q(k)};
            end
            legend(QC,'Location','northwest')
            hold off
            has_displayed = 1;
            break
        end

    end
    
end


