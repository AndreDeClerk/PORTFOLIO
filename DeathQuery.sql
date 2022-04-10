Select *
From [Covid-Deaths]
order by 3,4


Select *
From [Covid-Vac]
order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From [Covid-Deaths]
order by 1,2

--Looking at the Total Cases vs Total Deaths
-- shows the likeihood of dying if you contract covid in united states

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Covid-Deaths]
where location like '%states%' and continent is not null
order by 1,2

-- looking at total cases vs population
-- shows what percentage of the population got covid

Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From [Covid-Deaths]
where location like '%states%'
order by 1,2

--looking at countries with highest infection rate compared to population

Select location, population, MAX(total_cases) as highestInfectionCount, (MAX(total_cases)/population)*100 as PercentPopulationInfected
From [Covid-Deaths]
--where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

--By continent with highest death count

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Covid-Deaths]
--where location like '%states%'
where continent is not null
Group by continent
order by TotalDeathCount desc


--showing the countries with the highest death count per population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Covid-Deaths]
--where location like '%states%'
where continent is null
Group by Location
order by TotalDeathCount desc



--Global Numbers

Select --date, 
sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From [Covid-Deaths]
--where location like '%states%' 
where continent is not null
--group by date
order by 1,2

Select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From [Covid-Deaths]
--where location like '%states%' 
where continent is not null
group by date
order by 1,2



--join two tables


Select *
From [Covid-Deaths] dea
join [Covid-Vac] vac
on dea.location = vac.location
and dea.date = vac.date

--Total population vs vaccination
-- vaccination per day

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.Location, dea.Date) as Rolling_Vaccination
From [Covid-Deaths] dea
join [Covid-Vac] vac
	on dea.Location = vac.Location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USE CTE

with PopvsVac (continent, location, date, population, new_vaccinations, Rolling_Vaccination)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.Location, dea.Date) as Rolling_Vaccination
From [Covid-Deaths] dea
join [Covid-Vac] vac
	on dea.Location = vac.Location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (Rolling_Vaccination/population)*100 as PercentVacc
From PopvsVac


-- Temp Table

DROP Table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
Rolling_Vaccination numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.Location, dea.Date) as Rolling_Vaccination
From [Covid-Deaths] dea
join [Covid-Vac] vac
	on dea.Location = vac.Location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (Rolling_Vaccination/population)*100 as PercentVacc
From #PercentPopulationVaccinated


-- crating view to store for later visualization

create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.Location, dea.Date) as Rolling_Vaccination
From [Covid-Deaths] dea
join [Covid-Vac] vac
	on dea.Location = vac.Location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
from PercentPopulationVaccinated