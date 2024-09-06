SELECT *
FROM CovidDeaths
ORDER BY 3,4

SELECT *
FROM CovidVaccinations
ORDER BY 3,4

-- Select data we're going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows possibility of death if contacting covid in country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE location LIKE '%spain'
ORDER BY date

-- Looking at Total Cases vs Population
-- Shows what percentage of population got covid
SELECT location, population, date, total_cases, (total_cases/population)*100 AS PopulationPercentageInfected
FROM CovidDeaths
WHERE location LIKE '%spain'
ORDER BY date

-- Looking at Countries with Highest Infection Rates compared to population
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PopulationPercentageInfected
FROM CovidDeaths
GROUP BY location, population
ORDER BY PopulationPercentageInfected DESC

-- Showing countries with highest death count per population
SELECT location, MAX(CAST(total_deaths AS BIGINT)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

--Breaking it down by continent

--Showing continents with highest death count

SELECT continent, MAX(CAST(total_deaths AS BIGINT)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC


-- GLOBAL NUMBERS

SELECT SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths AS INT)) AS TotalDeaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases) * 100 AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2


-- Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

-- USE CTE

WITH PopsvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated/population) *100
FROM PopsvsVac

-- TEMP TABLE
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date time,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *, (RollingPeopleVaccinated/population) *100
FROM #PercentPopulationVaccinated

-- Creating view to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

CREATE VIEW InfectionCountByPopulation AS
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PopulationPercentageInfected
FROM CovidDeaths
GROUP BY location, population

CREATE VIEW TotalCasesPerPopulation AS
SELECT location, population, date, total_cases, (total_cases/population)*100 AS PopulationPercentageInfected
FROM CovidDeaths
