
-- Tableau Vizulization 

select *
from [Covid-Deaths]
order by 3,4

-------
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [Covid-Deaths]
where continent is not null 
order by 1,2

--------
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
from [Covid-Deaths]
Where continent is null 
and location not in ('World', 'European Union', 'International', 'Low income', 'Lower middle income', 'High income','Upper middle income')
Group by location
order by TotalDeathCount desc

--------
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
from [Covid-Deaths]
Group by Location, Population
order by PercentPopulationInfected desc

---------
Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
from [Covid-Deaths]
Group by Location, Population, date
order by PercentPopulationInfected desc