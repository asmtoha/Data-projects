select * from Projects..CovidDeaths
where continent is not  null
order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from Projects..CovidDeaths
where continent is not  null
order by 1,2

--looking at toatal cases vs total deaths at specific country

select location,date,total_cases,total_deaths,(total_deaths/total_cases)
*100 as death_parcentage
from Projects..CovidDeaths
where continent is not  null and location like '%states%'
order by 1,2

--shows the % of population got covid

select location,date,total_cases,population,(total_cases/population)
*100 as infected_percentage_population
from Projects..CovidDeaths
where continent is not  null
order by 1,2

--finding heighst infection rate

select location,population,max(total_cases) as heighest_infection_count,
max(total_cases/population)*100 as infected_percantage_population
from Projects..CovidDeaths
where continent is not  null
group by location,population
order by infected_percantage_population desc

--country's hieghest death per population

select location,max(cast(total_deaths as int)) as total_death_count
from Projects..CovidDeaths
where continent is not  null
group by location
order by total_death_count desc


--heighst death count by contitnent

select continent,max(cast(total_deaths as int)) as total_death_count
from Projects..CovidDeaths
where continent is not null
group by continent
order by total_death_count desc

--global

select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as deatch_percentage
from Projects..CovidDeaths
where continent is not null
--group by date
order by 1,2


-- population vs vaccination
select d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(convert(int, v.new_vaccinations))
over(partition by d.location order by d.location,d.date) as rolling_total_vaccination
from Projects..CovidDeaths d
join Projects..CovidVaccinations v
	on d.location = v.location
	and d.date = v.date
where d.continent is not null
order by 2,3

--using cte to use temp column
-- number of column is diffrent in ctf from following table, it's giving error

with Population_vs_Vaccination 
(continent,location,date,population,new_vaccinations,rolling_total_vaccination)
as (
select d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(convert(int, v.new_vaccinations))
over(partition by d.location order by d.location,d.date) as rolling_total_vaccination
from Projects..CovidDeaths d
join Projects..CovidVaccinations v
	on d.location = v.location
	and d.date = v.date
where d.continent is not null
--order by 2,3
)select *,(rolling_total_vaccination/population)*100 
as rolling_total_vaccination_perentage from Population_vs_Vaccination
where location = 'Bangladesh'


-- use temp table to use temp column

drop table if exists #Vaccinated_Population_Percentage
create table #Vaccinated_Population_Percentage
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_total_vaccination numeric
)

insert into #Vaccinated_Population_Percentage
select d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(convert(int, v.new_vaccinations))
over(partition by d.location order by d.location,d.date) as rolling_total_vaccination
from Projects..CovidDeaths d join Projects..CovidVaccinations v
on d.location = v.location and d.date = v.date
where d.continent is not null 
--and d.location = 'Bangladesh'
select *, (rolling_total_vaccination/population)*100
from #Vaccinated_Population_Percentage


--store data for later visualization

create view Vaccinated_Population_Percentage 
as
select d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(convert(int, v.new_vaccinations))
over(partition by d.location order by d.location,d.date) as rolling_total_vaccination
from Projects..CovidDeaths d join Projects..CovidVaccinations v
on d.location = v.location and d.date = v.date
where d.continent is not null 
--and d.location = 'Bangladesh'

select * from Vaccinated_Population_Percentage
order by 2