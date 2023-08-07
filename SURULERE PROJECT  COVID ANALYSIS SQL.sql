Select *
From CovidDeaths$
Where Continent is not Null
Order by 3,4

Select *
From CovidVaccinations$
Where Continent is not Null
Order by 3,4

Select Location, date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths$
Where location like '%states%'
Order by 1,2

Select Location, date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths$
Where location like '%Nigeria%'
Order by 1,2

Select Location, date,Population,total_cases, (total_cases/Population)*100 as PercentPopulationInfected
From CovidDeaths$
Where location like '%Nigeria%'
Order by 1,2

Select Location,Population, Max(total_cases)as HighestInfectionCount, Max(total_cases/Population)*100 as PercentPopulationInfected
From CovidDeaths$
Where Continent is not Null
--Where location like '%Nigeria%'
Group by Population, Location
Order by 4 Desc

Select Location, Max(Cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths$
Where Continent is not Null
Group by Location
Order by 2 Desc

Select Continent, Max(Cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths$
Where Continent is not Null
Group by Continent
Order by 2 Desc

Select location, Max(Cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths$
Where Continent is Null
Group by location
Order by 2 Desc

Select Continent, Max(Cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths$
Where Continent is Not Null
Group by Continent
Order by 2 Desc


Select SUM(New_cases) as Total_Cases, SUM(cast(New_deaths as int)) as total_deaths, SUM(cast(New_deaths as int))/SUM(New_cases)*100 as DeathPercentage
From CovidDeaths$
--Where location like '%states%'
Where continent is not Null
--Group by date
Order by 1,2

With PopVsVac (Continent, location, date, Population, new_vaccinations, SumVaccination)
as 
(
Select dea.Continent, dea.location, dea.date, dea.Population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location order by dea.location, dea.date) SumVaccination
From CovidDeaths$  dea 
Join CovidVaccinations$ vac
  ON dea.location = Vac.location
  AND dea.date = vac.date
Where dea.continent is not NULL
--Order by 2,3
)

Select*, (SumVaccination/Population)*100
From PopVsVac

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
SumVaccination numeric
)

Insert into #PercentPopulationVaccinated
Select dea.Continent, dea.location, dea.date, dea.Population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location order by dea.location, dea.date) SumVaccination
From CovidDeaths$  dea 
Join CovidVaccinations$ vac
  ON dea.location = Vac.location
  AND dea.date = vac.date
Where dea.continent is not NULL
--Order by 2,3

Select*, (SumVaccination/Population)*100
From #PercentPopulationVaccinated

Create view PercentPopulationVaccinated as
Select dea.Continent, dea.location, dea.date, dea.Population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location order by dea.location, dea.date) SumVaccination
From CovidDeaths$  dea 
Join CovidVaccinations$ vac
  ON dea.location = Vac.location
  AND dea.date = vac.date
Where dea.continent is not NULL
--Order by 2,3

Select*
From PercentPopulationVaccinated





