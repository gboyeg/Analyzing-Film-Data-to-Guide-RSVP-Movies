USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT 'director_mapping' AS TableName, COUNT(*) AS RowCount FROM director_mapping
UNION ALL
SELECT 'genre' AS TableName, COUNT(*) AS RowCount FROM genre
UNION ALL
SELECT 'movie' AS TableName, COUNT(*) AS RowCount FROM movie
UNION ALL
SELECT 'names' AS TableName, COUNT(*) AS RowCount FROM names
UNION ALL
SELECT 'ratings' AS TableName, COUNT(*) AS RowCount FROM ratings
UNION ALL
SELECT 'role_mapping' AS TableName, COUNT(*) AS RowCount FROM role_mapping;










-- Q2. Which columns in the movie table have null values?
SELECT
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id_null_count,
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_null_count,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_null_count,
    SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_null_count,
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_null_count,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_null_count,
    SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worlwide_gross_income_null_count,
    SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_null_count,
    SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_null_count
FROM movie;










-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)







SELECT Year, count(id) as number_of_movies
FROM movie
GROUP BY year
ORDER BY year;

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT Month(date_published) as month_num, count(id) as num_of_movies
FROM movie
GROUP BY month_num
ORDER BY num_of_movies;









/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT
    COUNT(id) AS movie_count
FROM
    movie
WHERE
    (country LIKE '%INDIA%' OR country LIKE '%USA%')
    AND year = 2019;










/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
FROM genre;









/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT GENRE,
    COUNT(ID) AS TOTAL_MOVIES
FROM MOVIE M
INNER JOIN GENRE G ON M.ID = G.MOVIE_ID
GROUP BY GENRE
ORDER BY TOTAL_MOVIES DESC
LIMIT 5;


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

ANALYZE unique_movie  AS (
    SELECT movie_id,
        COUNT(genre) AS Total_genre
    FROM genre
    GROUP BY movie_id
)
SELECT COUNT(*) as movie_with_one_genre
FROM unique_movie
WHERE Total_genre = 1;

WITH movies_with_one_genre AS (SELECT movie_id FROM genre GROUP BY movie_id HAVING Count(DISTINCT genre) = 1) SELECT Count(*) AS movies_with_one_genre FROM movies_with_one_genre;

WITH movies_with_one_genre AS (
    SELECT g.movie_id 
    FROM genre g
    GROUP BY g.movie_id 
    HAVING COUNT(DISTINCT g.genre) = 1
)
SELECT COUNT(*) AS movies_with_one_genre 
FROM movies_with_one_genre mwg
JOIN movies m ON mwg.movie_id = m.movie_id;


WITH movies_with_one_genre AS (
    SELECT movie_id 
    FROM genre 
    GROUP BY movie_id 
    HAVING COUNT(DISTINCT genre) = 1
)
SELECT COUNT(*) AS movies_with_one_genre 
FROM movies_with_one_genre;




/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)



SELECT genre,
    ROUND(AVG(duration), 2) as avg_duration
FROM movie m
INNER JOIN genre g
ON m.id = g.movie_id
GROUP BY genre;



/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:









/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/



-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

WITH genre_rank AS (
    SELECT genre,
        COUNT(ID) AS movie_count,
        ROW_NUMBER() OVER(ORDER BY COUNT(ID) DESC) AS genre_rank
    FROM MOVIE M
    INNER JOIN GENRE G
    ON M.ID = G.MOVIE_ID
    GROUP BY GENRE )
SELECT * FROM genre_rank
WHERE genre = 'Thriller';

/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:










/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?

SELECT 
    MIN(avg_rating) AS min_avg_rating, MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes, MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating, MAX(median_rating) AS max_median_rating
FROM ratings;







/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:






    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
WITH RankedMovies AS (
    SELECT m.title, r.avg_rating,
           ROW_NUMBER() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
    FROM ratings r
    INNER JOIN movie m ON r.movie_id = m.id
)
SELECT title, avg_rating, movie_rank
FROM RankedMovies
WHERE movie_rank <= 10;





/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too








/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
SELECT
    median_rating,
    COUNT(m.id) AS movie_count
FROM ratings r
INNER JOIN movie m ON r.movie_id = m.id
GROUP BY median_rating
ORDER BY movie_count DESC;









/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have










/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
SELECT production_company, COUNT(m.id) AS movie_count, 
    RANK() OVER (ORDER BY COUNT(m.id) DESC) AS prod_company_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE avg_rating > 8 AND production_company IS NOT NULL
GROUP BY production_company;







/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:









-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
SELECT genre,
    COUNT(id) AS movie_count
FROM genre g INNER JOIN movie m 
ON m.id = g.movie_id
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE MONTH(date_published) = 3
    AND YEAR(date_published) = 2017
    AND total_votes > 1000
    AND country LIKE '%USA%'
GROUP BY genre
ORDER BY movie_count DESC;







/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:









-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
SELECT m.title, r.avg_rating, g.genre
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
INNER JOIN genre g ON m.id = g.movie_id
WHERE m.title LIKE 'The%' AND r.avg_rating > 8
ORDER BY r.avg_rating DESC;










/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:









-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT
    COUNT(id) AS Movie_released_April2018_April2019
FROM movie m INNER JOIN ratings r
ON m.id = r.movie_id
WHERE (date_published BETWEEN '2018-04-01' AND '2019-04-01')
AND (median_rating = 8);









-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
SELECT country,
    SUM(total_votes) AS total_votes
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
WHERE country IN ('Germany', 'Italy')
GROUP BY country;









-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:








-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??

SELECT SUM(CASE WHEN NAME IS NULL THEN 1 ELSE 0 END) as name_nulls,
        SUM(CASE WHEN HEIGHT IS NULL THEN 1 ELSE 0 END) as HEIGHT_nulls,
        SUM(CASE WHEN DATE_OF_BIRTH IS NULL THEN 1 ELSE 0 END) as DATE_OF_BIRTH_nulls,
        SUM(CASE WHEN KNOWN_FOR_MOVIES IS NULL THEN 1 ELSE 0 END) as KNOWN_FOR_MOVIES_nulls
FROM NAMES;











/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:








/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
WITH Top_Three_Genre AS (
SELECT genre, COUNT(m.id) AS Movie_count
FROM movie m INNER JOIN genre g ON m.id = g.movie_id
INNER JOIN ratings r ON r.movie_id = m.id
WHERE avg_rating > 8
GROUP BY genre
ORDER BY Movie_count DESC LIMIT 3)
SELECT n.name AS director_name, COUNT(m.id) AS Movie_count
FROM movie m INNER JOIN director_mapping d ON m.id = d.movie_id
INNER JOIN names n ON n.id = d.name_id INNER JOIN genre g ON g.movie_id = m.id
INNER JOIN ratings r ON m.id = r.movie_id
WHERE g.genre IN (SELECT genre FROM Top_Three_Genre)
AND avg_rating > 8
GROUP BY director_name
ORDER BY Movie_count DESC LIMIT 3;







-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:



/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?

SELECT n.name AS Actor_name,
    COUNT(m.id) AS Movie_count
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
INNER JOIN role_mapping rm ON m.id = rm.movie_id
INNER JOIN names n ON n.id = rm.name_id
WHERE median_Rating >= 8
GROUP BY Actor_name
ORDER BY Movie_count DESC LIMIT 2;






/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:








/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
SELECT production_company,
    SUM(total_votes) AS Vote_count,
    ROW_NUMBER() OVER (ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
GROUP BY production_company LIMIT 3;

SELECT production_company,
    SUM(total_votes) AS Vote_count,
    ROW_NUMBER() OVER (ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
GROUP BY production_company
ORDER BY Vote_count DESC
LIMIT 3;






/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:










/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?


SELECT name AS actor_name,
    SUM(total_votes) AS total_votes,
    COUNT(m.id) AS movie_count,
    ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actor_avg_rating,
    ROW_NUMBER() OVER (ORDER BY  ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) DESC) AS actor_rank
FROM names n
INNER JOIN role_mapping rm ON n.id = rm.name_id
INNER JOIN ratings r ON rm.movie_id = r.movie_id
INNER JOIN movie m ON m.id = rm.movie_id
WHERE category = "actor" AND country LIKE "%india%"
GROUP BY actor_name
HAVING movie_count >= 5;




-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:






-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings?



 
SELECT name AS actress_name,
    SUM(total_votes) AS total_votes,
    COUNT(m.id) AS movie_count,
    ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actress_avg_rating,
    ROW_NUMBER() OVER ( ORDER BY ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) DESC, 
    SUM(total_votes) DESC
    ) AS actress_rank
FROM names n
INNER JOIN role_mapping rm ON n.id = rm.name_id
INNER JOIN ratings r ON rm.movie_id = r.movie_id
INNER JOIN movie m ON m.id = rm.movie_id
WHERE category = "actress"
    AND country LIKE "%india%"
    AND languages LIKE "%hindi%"
GROUP BY actress_name
HAVING movie_count >= 3;





-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:









/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 


			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/


SELECT title, genre, avg_rating,
    CASE
        WHEN avg_rating > 8 THEN 'Superhit movies'
        WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        WHEN avg_rating < 5 THEN 'Flop movies' END AS rating_category
FROM movie AS m
INNER JOIN genre AS g ON m.id = g.movie_id
INNER JOIN ratings AS r ON r.movie_id = m.id
WHERE genre = 'Thriller';

-- Type your code below:









/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
SELECT genre,
    ROUND(AVG(duration), 2) AS avg_duration,
    SUM(ROUND(AVG(duration), 2)) OVER (ORDER BY genre) AS running_total_duration,
    ROUND(AVG(ROUND(AVG(duration), 2)) 
    OVER (ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS moving_avg_duration
FROM movie AS m
INNER JOIN genre AS g ON m.id = g.movie_id
GROUP BY genre
ORDER BY genre;








-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:









-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 



-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies




-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?

WITH top_production_houses AS (
SELECT production_company, COUNT(*) AS movie_count,
ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS prod_comp_rank
FROM movie m INNER JOIN ratings r ON m.id = r.movie_id
WHERE median_rating >= 8
        AND POSITION(',' in languages) > 0 -- Movies with multiple languages
        AND production_company IS NOT NULL
    GROUP BY production_company)
SELECT production_company, movie_count,prod_comp_rank
FROM top_production_houses
WHERE prod_comp_rank <= 2;



/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:








-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
SELECT name AS actress_name,
    SUM(total_votes) AS total_votes,
    COUNT(m.id) AS movie_count,
    AVG(avg_rating) AS actress_Avg_rating,
    ROW_NUMBER() OVER (ORDER BY count(m.id) DESC) AS actress_rank
FROM names n
INNER JOIN role_mapping rm ON n.id = rm.name_id
INNER JOIN movie m ON m.id = rm.movie_id
INNER JOIN ratings r ON r.movie_id = m.id
INNER JOIN genre g ON g.movie_id = m.id
WHERE avg_rating > 8 AND category = "actress" AND genre = "drama"
GROUP BY actress_name
ORDER BY movie_count desc LIMIT 3;








/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:








/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations




Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

CREATE VIEW avg_diff_between_movie_dates AS
WITH movie_dates AS (
SELECT nm.id AS director_id, nm.name AS director_name, m.id AS movie_id, m.date_published AS movie_date,
LEAD(m.date_published, 1) OVER (PARTITION BY nm.name ORDER BY m.date_published) AS next_movie_date
FROM names nm INNER JOIN director_mapping dm ON nm.id = dm.name_id
INNER JOIN movie m ON dm.movie_id = m.id
)
SELECT director_id, director_name,
AVG(DATEDIFF(next_movie_date, movie_date)) AS avg_inter_movie_days
FROM movie_dates
GROUP BY director_id, director_name;
-- Top 9 directors based on the number of movies
WITH top_directors AS (
    SELECT nm.id AS director_id, nm.name AS director_name,
        COUNT(DISTINCT dm.movie_id) AS number_of_movies,
        ROUND(AVG(r.avg_rating), 2) AS avg_rating,
        SUM(r.total_votes) AS total_votes,
        MIN(r.avg_rating) AS min_rating,
        MAX(r.avg_rating) AS max_rating,
        SUM(m.duration) AS total_duration,
        ROW_NUMBER() OVER (ORDER BY COUNT(DISTINCT dm.movie_id) DESC) AS director_rank
FROM names nm
INNER JOIN director_mapping dm ON nm.id = dm.name_id
INNER JOIN movie m ON dm.movie_id = m.id
INNER JOIN ratings r ON m.id = r.movie_id
GROUP BY director_id, director_name
)
-- Combine with the average inter-movie days
SELECT td.director_id, td.director_name, td.number_of_movies,
    AVGD.avg_inter_movie_days AS avg_inter_movie_days,
    td.avg_rating,td.total_votes, td.min_rating, td.max_rating,
    td.total_duration
FROM top_directors td
LEFT JOIN avg_diff_between_movie_dates AVGD ON td.director_id = AVGD.director_id
WHERE td.director_rank <= 9;


WITH TOP_3_GENRE
AS
  (
           SELECT   GENRE
           FROM     GENRE
           GROUP BY GENRE
           ORDER BY COUNT(GENRE) DESC
           LIMIT    3 ),
  TOP_MOVIES
AS
  (
             SELECT     genre,
                        year,
                        TITLE                                                                                                                     AS movie_name,
                        CAST(REPLACE(IFNULL(WORLWIDE_GROSS_INCOME,0),'$ ','') AS DECIMAL(10))                                                     AS worldwide_gross_income_$,
                        ROW_NUMBER() OVER (PARTITION BY YEAR ORDER BY CAST(REPLACE(IFNULL(WORLWIDE_GROSS_INCOME,0),'$ ','') AS DECIMAL(10)) DESC) AS movie_rank
             FROM       MOVIE M
             INNER JOIN GENRE G
             ON         M.ID = G.MOVIE_ID
             WHERE      GENRE IN
                        (
                               SELECT *
                               FROM   TOP_3_GENRE) )
  SELECT *
  FROM   TOP_MOVIES
  WHERE  MOVIE_RANK<=5;


