Select Location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 as "Death Percentage"
From [dbo].[CovidDeaths]
order by 1, 2 desc

--TOTAL DEATH PER TOTAL CASES IN NIGERIA
Select Location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 as "Death Percentage"
From [dbo].[CovidDeaths]
Where location like '%Bulgaria%'
order by [Death Percentage] desc

--TOTAL CASES PER POPULATION

Select continent,date, population, total_cases, (total_cases/population)*100 as "Population Percentage"
From [dbo].[CovidDeaths]
Where continent like '%Africa%'
order by "Population Percentage" desc

--Highest cases of Covid per country

Select location, population, MAX(total_cases) as "Highest cases", MAX((total_cases/population))*100 as "Population Percentage"
From [dbo].[CovidDeaths]
group by location, population
order by "Population Percentage" desc

--Highest cases of Covid per continent

Select continent, population, MAX(total_cases) as "Highest cases", MAX((total_cases/population))*100 as "Population Percentage"
From [dbo].[CovidDeaths]
group by continent, population
order by "Population Percentage" desc

--Higest Death count per country

Select location, MAX(total_deaths) as "Highest Death Count" 
From [dbo].[CovidDeaths]
where continent is not null
Group by location
order by "Highest Death Count" desc

Select continent, MAX(total_deaths) as "Highest Death Count" 
From [dbo].[CovidDeaths]
where continent is not null
Group by continent
order by "Highest Death Count" desc

--Cases across the World per day

Select date, SUM(total_cases) as TOTALCASES, SUM(total_deaths) as TOTALDEATHS, SUM(total_deaths)/ SUM(total_cases)*100 AS "Global Death Percentage"
From [dbo].[CovidDeaths]
where continent is not null
Group by date
order by "Global Death Percentage" desc

--Total cases across the world

Select  SUM(total_cases) as TOTALCASES, SUM(total_deaths) as TOTALDEATHS, SUM(total_deaths)/ SUM(total_cases)*100 AS "Global Death Percentage"
From [dbo].[CovidDeaths]
where continent is not null
--Group by date
order by "Global Death Percentage" desc

--Total Population per Total Vaccinated across the world

Select DEA.continent, DEA.location, DEA. date, DEA.population, VAC.new_vaccinations,
SUM(VAC.new_vaccinations) OVER (Partition By DEA.location order by DEA.location, DEA.date) "Cummulative vaccinations"
From [dbo].[CovidVaccination] as VAC
Join [dbo].[CovidDeaths] as DEA
	On VAC.location= DEA.location
	and VAC.date= DEA.date
	Where DEA.continent is not null
	and VAC.new_vaccinations is not null
order by 2, 3

--Total Population per Total Vaccinated across countries in Africa

Select DEA.continent, DEA.location, DEA. date, DEA.population, VAC.new_vaccinations,
SUM(VAC.new_vaccinations) OVER (Partition By DEA.location order by DEA.location, DEA.date) "Cummulative vaccinations",
From [dbo].[CovidVaccination] as VAC
Join [dbo].[CovidDeaths] as DEA
	On VAC.location= DEA.location
	and VAC.date= DEA.date
	Where VAC.new_vaccinations is not null
	and DEA.continent like'%Africa%'
order by 2, 3

--CTE
WITH  POPSVSVAC (continent, location, date, population, new_vaccinations, "Cummulative vaccination")
as
(
Select DEA.continent, DEA.location, DEA. date, DEA.population, VAC.new_vaccinations,
SUM(VAC.new_vaccinations) OVER (Partition By DEA.location order by DEA.location, DEA.date) "Cummulative vaccination"
From [dbo].[CovidVaccination] as VAC
Join [dbo].[CovidDeaths] as DEA
	On VAC.location= DEA.location
	and VAC.date= DEA.date
	Where DEA.continent is not null
	and VAC.new_vaccinations is not null
)
Select *,("Cummulative vaccination"/population)* 100 as PercentageVaccination
From POPSVSVAC
