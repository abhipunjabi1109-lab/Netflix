use net-flix;
select * from netflix_titles;
-- 1. FInd the top 5 countries producing the most content
select country, count(*) as Total_titles from netflix_titles
group by country
order by total_titles desc
limit 5;

-- 2. find shows with rating PG
select * from netflix_titles where rating ="PG";

-- 3.count shows per country
select country, count(*) from netflix_titles 
group by country; 

-- 4. convert titles to UPPERCASE
select upper(title) from netflix_titles;
 
 -- 5. ROund average release year
 select round(AVG(release_year),2) from netflix_titles;
 
 -- 6. check even/odd release year
 select title, MOD(release_year,2) as remainder from netflix_titles;
 
 -- 7.  categorize show usig case
 select title, 
 case 
 when release_year >= 2020 then "NEW"
 when release_year BETWEEN 2010 and 2019 then "MID"
 ELSE "OLD"
 end as category from netflix_titles;
 
 -- 8. Replace Null directors
 select IFNULL(director, "Unknown") from netflix_titles;
 
 -- 9. Find rows where directors are null 
 select * from netflix_titles where director = NULL;
 
 -- 10. find latest released content
 select * from netflix_titles
 where release_year = (Select MAX(release_year) from netflix_titles);
 
 -- 11. Rank shows by release year
 select title, release_year,
 rank() over (order by release_year desc) as rank_no from netflix_titles;

-- 12.  row number for each show
select title, row_number() over (order by release_year desc) as row_num from netflix_titles;

-- 13. Top 5 countries with most content
select country, count(*) as total from netflix_titles
group by country
order by total desc
limit 5;

-- 14. Percentage of each type
select type,
round(count(*) * 100 / (select count(*) from netflix_titles),2) as percentage
from netflix_titles
group by type;

-- 15. most common rating
select rating, count(*) as total from netflix_titles
group by rating
order by total desc;

-- 16. find longest movie (basic)
select * from netflix_titles
where type ="Movie"
order by duration desc limit 3;

-- 17.count shows per year
select release_year, count(*) from netflix_titles
group by release_year
order by release_year desc;

-- 18. running total using window function
select distinct(release_year), 
count(*) over (order by release_year desc) as running_total from netflix_titles;

-- 19. parition by type
select title, type,
count(*) over (order by type) as total_type from netflix_titles;

-- 20. find duplicate titles
select title, count(*) from netflix_titles
group by title
having count(*) > 1;

-- 21. Top 3 latest movie
select * from netflix_titles
where type ="movie"
order by release_year desc
limit 3;

-- 22. FInd shows without country
select * from netflix_titles
where country = Null;

-- 23. count null values in director
select count(*) from netflix_titles where director is NULL;

-- 24. find shows with multiple countries
select * from netflix_titles where country like "%,%";

-- 25. year wise ranking
select title, release_year,
rank() over (partition by release_year order by title) as rank_year 
from netflix_titles; 

-- 26 compare with avg year
select title, release_year from netflix_titles
where release_year > (select avg(release_year) from netflix_titles);

-- 27. classify shows new mid & old
select title, release_year,
case
when release_year >= 2020 then "NEW"
when release_year BETWEEN 2010 and 2019 then "MID"
else "OLD"
end as Category
from netflix_titles;

-- 28. convert movie into film, tc show into series
select title, type,
case 
when type = "Movie" then "flim"
when type = "TV show" then "Series"
end as type_label from netflix_titles;

-- 29. group content into india VS other
select title, country,
case
when country ="india" then "Indian content"
else "International"
end as category from netflix_titles;

-- 30 replace null with unknown
select title,
case when director is NULL then "Unknown"
else director
end as director_name from netflix_titles;
-- NOT WORKING IN NULL

-- 31. count movies VS TV shows
select
sum(case when type = "movie" then 1 else 0 end) as total_movies,
sum(case when type = "TV Show" then 1 else 0 end) as total_TV
from netflix_titles;

-- 32. CASE WITH GROUP BY (group shows into year categories and count)
select case
when release_year >= 2020 then "NEW"
else "OLD" 
end as category,
count(*)
from netflix_titles
group by category;

-- 33. find most recent content
select * from netflix_titles
where release_year = (Select max(release_year) from netflix_titles);

-- 34. find shows release after average year
select * from netflix_titles
where release_year > (Select avg(release_year) from netflix_titles);

-- 35. find rating with highest count
select rating from netflix_titles
group by rating
order by count(*) desc limit 1; 

-- 36. count shows per type using subquery
select type, total from (select type, count(*) as total
from netflix_titles group by type )
as sub;

-- 37. find top country with highest content
select country from netflix_titles
group by country
order by count(*) desc
limit 3;

-- 38. find shows where same country exists
select title from netflix_titles n1
where exists (select 1 from netflix_titles n2
where n1.country = n2.country
and n1.show_id != n2.show_id );  

-- 39. find shows from top 3 countries
select * from netflix_titles
where country IN(select country from netflix_titles
group by country
order by count(*) desc
) limit 3;

-- 40. find shows not in top countries
select * from netflix_titles
where country NOT IN (select * from netflix_titles
group by country
order by count(*) desc );

-- 41. compare each show with country average
select title, country, release_year from netflix_titles n1
where release_year > (select avg(release_year) from netflix_titles n2
where n1.country = n2.country );

-- 42. find total rows using subquery
select (select count(*) from netflix_titles) as Total_records;

-- 43 find second highest release year
select Max(release_year) from netflix_titles
where release_year < (select Max(release_year) from netflix_titles);

-- 44. create a cte to show all movies only
with movies_cte as (
select * from netflix_titles where type = "Movie")
select * from movies_cte;

-- 45. count number of movies & shows using cte
with type_count as (
select type, count(*) as total from netflix_titles group by type)
select * from type_count;

-- 46. show only records where director is missing
with null_director as (
select * from netflix_titles where director IS NULL)
select * from null_director;

-- 47. count new VS old shows
with categorized as (
select 
case
when release_year >= 2020 then "NEW" else "OLD" 
end as category 
from netflix_titles 
)
select category, count(*) 
from categorized
group by category;

-- 48. compare movies VS TV shows count
with movie as (
select count(*) as total_movies from netflix_titles where type = "Movie"),
TV as (
select count(*) as total_TV from netflix_titles where type = "TV Show")
select movie.total_movies, tv.total_tv
from movie, tv;

-- 49. find avg release year per country
with country_avg as 
(select country, avg(release_year) as avg_year
from netflix_titles
group by country)
select * from country_avg;

-- 50. find top country and its multi shows
with country_count as (
select country, count(*) as total from netflix_titles
group by country
),
top_country as (
select *  from country_count
order by total desc
limit 1)
select * from top_country;


-- doubts NULL ERRORS NOT WORKING, how to extrace moneth only, queires from over apply, 36 query to understand, 40, 46, 

