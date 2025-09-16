-- Netflix Project
DROP TABLE IF EXISTS NETFLIX;
CREATE TABLE NETFLIX(
show_id VARCHAR(6),
type VARCHAR(10),
title VARCHAR(150),
director VARCHAR(208),
castS VARCHAR(1000),
country VARCHAR(150),
date_added VARCHAR(50),
release_year INT,
rating VARCHAR(10),
duration VARCHAR(15),
listed_in VARCHAR(100),
description VARCHAR(250)
);

SELECT * FROM NETFLIX;


SELECT COUNT(*) AS TOTAL_CONTENT FROM NETFLIX;


SELECT DISTINCT type FROM NETFLIX;



-- 15.Business Problems

--1.Count the Number of Movies vs TV Shows
SELECT TYPE,COUNT(*) AS TOTAL_CONTENT FROM NETFLIX GROUP BY TYPE;
 -- 2. Find the Most Common Rating for Movies and TV Shows
SELECT type,rating FROM (
SELECT type,rating,count(*),RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS RANKING FROM
NETFLIX GROUP BY 1,2) AS T1 WHERE RANKING=1

--3. List All Movies Released in a Specific Year (e.g., 2020)

SELECT * FROM NETFLIX WHERE type='Movie' AND release_year = 2020;

--4. Find the Top 5 Countries with the Most Content on Netflix

SELECT UNNEST(STRING_TO_ARRAY(country,',')) AS NEW_COUNTRY,COUNT(show_id) as total_content
FROM NETFLIX GROUP BY 1 ORDER BY 2 DESC LIMIT 5;


--5. Identify the Longest Movie
SELECT * FROM NETFLIX WHERE TYPE='Movie' AND 
duration=(SELECT MAX(duration) FROM NETFLIX);

--6. Find Content Added in the Last 5 Years
SELECT * FROM NETFLIX WHERE
TO_DATE(DATE_ADDED,'MONTH DD,YY')>=CURRENT_DATE-INTERVAL '5 YEARS';

--7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
SELECT * FROM NETFLIX WHERE director LIKE '%Rajiv Chilaka%';

--8. List All TV Shows with More Than 5 Seasons
SELECT * 
FROM NETFLIX
WHERE type = 'TV Show'
  AND CAST(SPLIT_PART(duration, ' ', 1) AS INT) > 5;

 -- 9. Count the Number of Content Items in Each Genre
 SELECT UNNEST(STRING_TO_ARRAY(LISTED_IN,','))AS Genre ,COUNT(SHOW_ID)
 FROM NETFLIX GROUP BY 1;

--10.Find each year and the average numbers of content release in India on netflix.
SELECT 
EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,COUNT(*) AS yearly_content,
ROUND((COUNT(*)::numeric / (SELECT COUNT(*) FROM NETFLIX WHERE country = 'India')) * 100, 2
    ) AS avg_content_per_year
FROM NETFLIX WHERE country = 'India' GROUP BY 1 ORDER BY 1;

--11. List All Movies that are Documentaries
SELECT * FROM NETFLIX WHERE listed_in ILIKE '%Documentaries%';

--12. Find All Content Without a Director
SELECT * FROM NETFLIX WHERE DIRECTOR IS NULL;

--13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT * FROM NETFLIX WHERE  castS ILIKE '%Salman Khan%' AND release_year>EXTRACT(YEAR FROM CURRENT_DATE)-10


--14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
SELECT UNNEST(STRING_TO_ARRAY(CASTS,',')) AS ACTORS,COUNT(*)AS TOTAL_CONTENT FROM NETFLIX WHERE
COUNTRY ILIKE '%India%' GROUP BY 1 ORDER BY 2 DESC LIMIT 10



--15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
SELECT * ,CASE WHEN description ILIKE '%Kill%' OR description ILIKE '%Violence%' THEN 'BAD_CONTENT'
ELSE 'GOOD_CONTENT' END CATEGORY FROM NETFLIX

-- COUNT THE CATEGORY
WITH NEW_TABLE AS (SELECT * ,CASE WHEN description ILIKE '%Kill%' OR description ILIKE '%Violence%' THEN 'BAD_CONTENT'
ELSE 'GOOD_CONTENT' END CATEGORY FROM NETFLIX
)SELECT CATEGORY ,COUNT(*) AS TOTAL_CONTENT FROM  NEW_TABLE GROUP BY 1

--16. Find the Year with the Highest Number of Content Additions

SELECT EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
       COUNT(*) AS total_content
FROM NETFLIX
GROUP BY 1
ORDER BY total_content DESC
LIMIT 1;

--17. Find the Top 5 Directors with the Most Content
SELECT director, COUNT(*) AS total_content
FROM NETFLIX
WHERE director IS NOT NULL
GROUP BY director
ORDER BY total_content DESC
LIMIT 5;

--18. Find the Average Duration of Movies
SELECT ROUND(AVG(CAST(SPLIT_PART(duration, ' ', 1) AS INT)), 2) AS avg_movie_duration
FROM NETFLIX
WHERE type = 'Movie';

--19. Find the Most Common Genre on Netflix
SELECT TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) AS genre,
       COUNT(*) AS total_content
FROM NETFLIX
GROUP BY genre
ORDER BY total_content DESC
LIMIT 1;


--20. Compare Number of Movies vs TV Shows Released Each Year
SELECT release_year, type, COUNT(*) AS total_content
FROM NETFLIX
GROUP BY release_year, type
ORDER BY release_year, type;


