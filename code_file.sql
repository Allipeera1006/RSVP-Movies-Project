USE IMDB;

-- Before you proceed to solve the assignment, it is a good practice to know what the data values in each table are.



-- Similarly, Write queries to see data values from all tables 
SELECT * FROM [dbo].[director_mapping]

SELECT * FROM [dbo].[genre]

SELECT * FROM [dbo].[movie]

SELECT * FROM [dbo].[names]

SELECT * FROM [dbo].[ratings]

SELECT * FROM [dbo].[role_mapping]

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------------------------------------


/* To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movie' and 'genre' tables. */

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 
    COUNT(*) AS movie_row_count
FROM
    movie;

 SELECT 
    COUNT(*) AS names_row_count
FROM
    names;


-- Similarly, write queries to find the total number of rows in each table
SELECT 
     COUNT(*) AS director_mapping_count
 FROM director_mapping

 SELECT 
     COUNT(*) AS genre_count
 FROM genre

 SELECT 
     COUNT(*) AS ratings_count
 FROM ratings

 SELECT 
     COUNT(*) AS role_mapping_count
 FROM role_mapping
-- ------------------------------------------------------------------------------------------------------------------------------------------------

-- Q2. Which columns in the 'movie' table have null values?
-- Type your code below:

-- Solution 1
SELECT 
    COUNT(*) AS title_nulls
FROM
    movie
WHERE title IS NULL;

SELECT 
    COUNT(*) AS year_nulls
FROM
    movie
WHERE year IS NULL;

-- Similarly, write queries to find the null values of remaining columns in 'movie' table 

SELECT COUNT(*) AS date_published_nulls FROM movie
WHERE date_published IS NULL;

SELECT COUNT(*) AS duration_nulls FROM movie
WHERE duration IS NULL;

SELECT COUNT(*) AS country_nulls FROM movie  
WHERE country IS NULL;

SELECT COUNT(*) AS worlwide_gross_income_nulls FROM movie
WHERE worlwide_gross_income IS NULL;

SELECT COUNT(*) AS languages_nulls FROM movie
WHERE languages IS NULL;

SELECT COUNT(*) AS production_company_nulls FROM movie
WHERE production_company IS NULL;
-- Solution 2
SELECT 
    COUNT(CASE
        WHEN title IS NULL THEN id
    END) AS title_nulls,
    COUNT(CASE
        WHEN year IS NULL THEN id
    END) AS year_nulls,
    
     -- Add the case statements for the remaining columns
     COUNT(CASE 
        WHEN date_published IS NULL THEN id
    END) AS date_published_nulls,
    COUNT(CASE
        WHEN duration IS NULL THEN id
    END) AS duration_nulls,
    COUNT(CASE
        WHEN country IS NULL THEN id
    END) AS country_nulls,
    COUNT(CASE
        WHEN worlwide_gross_income IS NULL THEN id
    END) AS worlwide_gross_income_nulls,
    COUNT(CASE
        WHEN languages IS NULL THEN id
    END) AS languages_nulls,
    COUNT(CASE
        WHEN production_company IS NULL THEN id
    END) AS production_company_nulls
FROM
    movie;

select * from movie;
    
/* In Solution 2 above, id in each case statement has been used as a counter to count the number of null values. Whenever a value
   is null for a column, the id increments by 1. */

/* There are 20 nulls in country; 3724 nulls in worlwide_gross_income; 194 nulls in languages; 528 nulls in production_company.
   Notice that we do not need to check for null values in the 'id' column as it is a primary key.*/

-- As you can see, four columns of the 'movie' table have null values. Let's look at the movies released in each year. 

-- ----------------------------------------------------------------------------------------------------------------------------------------------

-- Q3.1 Find the total number of movies released in each year.

/* Output format :

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	   2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+ */


-- Hint: Utilize the COUNT(*) function to count the number of movies.
-- Hint: Use the GROUP BY clause to group the results by the 'year' column.

-- Type your code below:
SELECT year, COUNT(*) AS number_of_movies from movie
group by year
order by year;




-- Q3.1 How does the trend look month-wise? (Output expected) 




/* Output format :
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	  1			|	    134			|
|	  2			|	    231			|
|	  .			|		 .			|
+---------------+-------------------+ */

-- Type your code below:
SELECT MONTH(date_published) as month_num , count(*) as number_of_movies from movie
group by MONTH(date_published)
order by month_num;




/* The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the
'movies' table. 
We know that USA and India produce a huge number of movies each year. Lets find the number of movies produced by USA
or India in the last year. */
  
  -- ---------------------------------------------------------------------------------------------------------------------------------------------------
  


  
-- Q4. How many movies were produced in the USA or India in the year 2019?
-- Hint: Use the LIKE operator to filter countries containing 'USA' or 'India'.

/* Output format

+---------------+
|number_of_movies|
+---------------+
|	  -		     |  */

-- Type your code below:

SELECT COUNT(*) AS number_of_movies FROM movie
WHERE 
    (country LIKE '%USA%' OR country LIKE '%India%')
    AND YEAR(date_published) = 2019;



/* USA and India produced more than a thousand movies (you know the exact number!) in the year 2019.
Exploring the table 'genre' will be fun, too.
Let’s find out the different genres in the dataset. */

-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- Q5. Find the unique list of the genres present in the data set?
select * from genre;
/* Output format
+---------------+
|genre|
+-----+
|  -  |
|  -  |
|  -  |  */

-- Type your code below:
SELECT DISTINCT genre from genre;



/* So, RSVP Movies plans to make a movie on one of these genres.
Now, don't you want to know in which genre were the highest number of movies produced?
Combining both the 'movie' and the 'genre' table can give us interesting insights. */

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q6.Which genre had the highest number of movies produced overall?

-- Hint: Utilize the COUNT() function to count the occurrences of movie IDs for each genre.
-- Hint: Group the results by the 'genre' column using the GROUP BY clause.
-- Hint: Order the results by the count of movie IDs in descending order using the ORDER BY clause.
-- Hint: Use the LIMIT clause to restrict the result to only the top genre with the highest movie count.


/* Output format
+-----------+--------------+
|	genre	|	movie_count|
+-----------+---------------
|	  -		|	    -	   |

+---------------+----------+ */

-- Type your code below:
select top 1 g.genre, count(m.id) as movie_count 
from genre as g
inner join  
movie as m 
on m.id = g.movie_id
group by genre
order by movie_count desc;
--The genre Drama has produced highest number of movies ( 4285 )

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q7. How many movies belong to only one genre?

-- Hint: Utilize a Common Table Expression (CTE) named 'movie_genre_summary' to summarize genre counts per movie.
-- Hint: Use the COUNT() function along with GROUP BY to count the number of genres for each movie.
-- Hint: Employ COUNT(DISTINCT) to count movies with only one genre.

/* Output format
+------------------------+
|single_genre_movie_count|
+------------------------+
|           -            |*/

-- Type your code below:
with movie_genre_summary as (
    select count(g.genre) as genre_count, m.id  from 
    genre as g inner join movie as m
    on g.movie_id = m.id
    group by m.id
)
select count(*) as single_genre_movie_count from movie_genre_summary
where genre_count = 1;

--there are 3289 movies which have only one genre called drama
/* There are more than three thousand movies which have only one genre associated with them.
This is a significant number.
Now, let's find out the ideal duration for RSVP Movies’ next project.*/

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

-- Hint: Utilize a LEFT JOIN to combine the 'genre' and 'movie' tables based on the 'movie_id'.
-- Hint: Specify table aliases for clarity, such as 'g' for 'genre' and 'm' for 'movie'.
-- Hint: Employ the AVG() function to calculate the average duration for each genre.
-- Hint: GROUP BY the 'genre' column to calculate averages for each genre.
select * from movie
select * from genre

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	Thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select g.genre, avg(cast(m.duration as int)) as avg_duration from genre as g
left join movie as m
on g.movie_id = m.id
group by g.genre
order by avg_duration desc;


/* Note that using an outer join is important as we are dealing with a large number of null values. Using
   an inner join will slow down query processing. */

/* Now you know that movies of genre 'Drama' (produced highest in number in 2019) have an average duration of
106.77 mins.
Let's find where the movies of genre 'thriller' lie on the basis of number of movies.*/

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------


    
-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 

-- Hint: Use a Common Table Expression (CTE) named 'summary' to aggregate counts of movie IDs for each genre.
-- Hint: Utilize the COUNT() function along with GROUP BY to count the number of movie IDs for each genre.
-- Hint: Implement the RANK() function to assign a rank to each genre based on movie count.
-- Hint: Employ LOWER() function to ensure case-insensitive comparison.


/* Output format:
+---------------+-------------------+---------------------+
|   genre		|	 movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|   -	    	|	   -			|			-		  |
+---------------+-------------------+---------------------+*/

-- Type your code below:
WITH summary AS (
    SELECT g.genre, COUNT(m.id) AS movie_count FROM genre AS g
    LEFT JOIN movie AS m
    ON g.movie_id = m.id
    GROUP BY g.genre
)
SELECT genre, movie_count,
RANK() OVER (ORDER BY movie_count DESC) AS genre_rank
FROM summary
WHERE LOWER(genre) = 'thriller';




-- Thriller movies are in the top 3 among all genres in terms of the number of movies.

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* In the previous segment, you analysed the 'movie' and the 'genre' tables. 
   In this segment, you will analyse the 'ratings' table as well.
   To start with, let's get the minimum and maximum values of different columns in the table */

-- Segment 2:

-- Q10.  Find the minimum and maximum values for each column of the 'ratings' table except the movie_id column.

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|max_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/

-- Type your code below:
SELECT min(avg_rating) as min_avg_rating, max(avg_rating) as max_avg_rating, 
       min(total_votes) as min_total_votes,max(total_votes) as max_total_votes,
       min(median_rating) as min_median_ratin,max(median_rating) as max_median_rating
from ratings;

    
/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating. */

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
select * from movie
select * from ratings

-- Hint: Use a Common Table Expression (CTE) named 'top_movies' to calculate the average rating for each movie and assign a rank.
-- Hint: Utilize a LEFT JOIN to combine the 'movie' and 'ratings' tables based on 'id' and 'movie_id' respectively.
-- Hint: Implement the AVG() function to calculate the average rating for each movie.
-- Hint: Use the ROW_NUMBER() function along with ORDER BY to assign ranks to movies based on average rating, ordered in descending order.

/* Output format:
+---------------+-------------------+---------------------+
|     title		|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
|     Fan		|		9.6			|			5	  	  |
|	  .			|		 .			|			.		  |
|	  .			|		 .			|			.		  |
|	  .			|		 .			|			.		  |
+---------------+-------------------+---------------------+*/

-- Type your code below:
with top_movies as (
    select m.title , avg(r.avg_rating) as avg_rating from movie as m
    left join ratings as r
    on m.id = r.movie_id
    group by m.title
)
select TOP 10 title, avg_rating, ROW_NUMBER() over ( order by avg_rating desc) as movie_rank
from top_movies  
order by avg_rating desc;





-- It's okay to use RANK() or DENSE_RANK() as well.

/* Do you find the movie 'Fan' in the top 10 movies with an average rating of 9.6? If not, please check your code
again.
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight. */

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q12. Summarise the ratings table based on the movie counts by median ratings.(order by median_rating)

/* Output format:
+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */

-- Type your code below:
select median_rating , count(*) as movie_count
from ratings
group by median_rating
order by median_rating;


/* Movies with a median rating of 7 are the highest in number. 
Now, let's find out the production house with which RSVP Movies should look to partner with for its next project.*/

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------




-- Q13. Which production house has produced the most number of hit movies (average rating > 8)?

-- Hint: Use a Common Table Expression (CTE) named 'top_prod' to find the top production companies based on movie count.
-- Hint: Utilize a LEFT JOIN to combine the 'movie' and 'ratings' tables based on 'id' and 'movie_id' respectively.
-- Hint: Exclude NULL production company values using IS NOT NULL in the WHERE clause.


/* Output format:
+------------------+-------------------+----------------------+
|production_company|    movie_count	   |    prod_company_rank |
+------------------+-------------------+----------------------+
|           	   |		 		   |			 	  	  |
+------------------+-------------------+----------------------+*/

-- Type your code below:
with top_prod as (
    select m.production_company , count(*) as movie_count from movie as m
    left join ratings as r 
    on m.id = r.movie_id
    where r.avg_rating > 8 and m.production_company is not null
    group by m.production_company
)
select production_company, movie_count ,dense_rank() over(order by movie_count desc) as prod_company_rank
from top_prod
order by movie_count desc;







-- It's okay to use RANK() or DENSE_RANK() as well.
-- The answer can be either Dream Warrior Pictures or National Theatre Live or both.

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q14. How many movies released in each genre in March 2017 in the USA had more than 1,000 votes?(Split the question into parts and try to understand it.)

-- Hint: Utilize INNER JOINs to combine the 'genre', 'movie', and 'ratings' tables based on their relationships.
-- Hint: Use the WHERE clause to apply filtering conditions based on year, month, country, and total votes.
-- Hint: Extract the month from the 'date_published' column using the MONTH() function.
-- Hint: Employ LOWER() function for case-insensitive comparison of country names.
-- Hint: Utilize COUNT() function along with GROUP BY to count movies in each genre.
select * from movie
select * from genre
select * from ratings

/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */


-- Type your code below:
select g.genre , count(m.id) as movie_count from movie as m
inner join genre as g
 on m.id = g.movie_id
inner join ratings as r
on m.id = r.movie_id
where m.year = 2017 and month(m.date_published) = 3 and lower(m.country) = 'usa' and r.total_votes > 1000
group by g.genre
order by movie_count desc;









-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Lets try analysing the 'imdb' database using a unique problem statement.

-- Q15. Find the movies in each genre that start with the characters ‘The’ and have an average rating > 8.

-- Hint: Utilize INNER JOINs to combine the 'movie', 'genre', and 'ratings' tables based on their relationships.
-- Hint: Apply filtering conditions in the WHERE clause using the LIKE operator for the 'title' column and a condition for 'avg_rating'.
-- Hint: Use the '%' wildcard appropriately with the LIKE operator for pattern matching.


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
select m.title , r.avg_rating , g.genre from movie as m
inner join genre as g
 on m.id = g.movie_id
inner join ratings as r
 on m.id = r.movie_id
where m.title like 'The%' and r.avg_rating > 8 
order by r.avg_rating desc;






-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- You should also try out the same for median rating and check whether the ‘median rating’ column gives any
-- significant insights.

-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?

-- Hint: Use an INNER JOIN to combine the 'movie' and 'ratings' tables based on their relationship.
-- Hint: Pay attention to the date format for the BETWEEN operator and ensure it matches the format of the 'date_published' column.

/* Output format
+---------------+
|movie_count|
+-----------+
|     -     |  */

-- Type your code below:
select count(*) as movie_count from movie as m
inner join ratings as r 
on m.id = r.movie_id
where m.date_published between '2018-04-01' and '2019-04-01' and r.median_rating = 8;

-- 2794 movies released between 1 April 2018 and 1 April 2019 
-- In 2794 movies, 356 movies given a median rating of 8 in given period




-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Now, let's see the popularity of movies in different languages.

select * from movie
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.

/* Output format:
+---------------------------+---------------------------+
| german_votes_per_movie	|	italian_votes_per_movie	|
+---------------------------+----------------------------
|	-	                    |		    -   			|
|	.			            |		.	        		|
+---------------------------+---------------------------+ */

-- Type your code below:
SELECT 
    AVG(CASE WHEN LOWER(m.languages) LIKE '%german%' THEN r.total_votes END) AS german_votes_per_movie,
    AVG(CASE WHEN LOWER(m.languages) LIKE '%italian%' THEN r.total_votes END) AS italian_votes_per_movie
FROM movie AS m
JOIN ratings AS r 
    ON m.id = r.movie_id;

--yes german movies get more votes than italian movies
--german movie votes = 12928 and italian movies = 11960


-- Answer is Yes


-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------


/* Now that you have analysed the 'movie', 'genre' and 'ratings' tables, let us analyse another table - the 'names'
table. 
Let’s begin by searching for null values in the table. */

-- Segment 3:

-- Q18. Find the number of null values in each column of the 'names' table, except for the 'id' column.

/* Hint: You can find the number of null values for individual columns or follow below output format

+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/

-- Type your code below:
select * from names

select count(*) as name_nulls from names where name is null;

select count(*) as height_nulls from names where height is null;

select count(*) as date_of_birth_nulls from names where date_of_birth is null;

select count(*) as known_for_movies_nulls from names where known_for_movies is null;

-- Solution 2
-- use case statements to write the query to find null values of each column in names table
-- Hint: Refer question 2

-- Type your code below 
select 
    count(case 
            when name is null then id end) as name_nulls,
    count(case
            when height is null then id end) as height_nulls,
    count(case
            when date_of_birth is null then id end) as date_of_birth_nulls,
    count(case
            when known_for_movies is null then id end) as known_for_movies
from names;

--From names table there is no null values in name col
--17335 null values in height col
--13431 null values in date_of_birth col
--15226 null values in known_for_movies col

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- 

/* The director is the most important person in a movie crew. 
   Let’s find out the top three directors each in the top three genres who can be hired by RSVP Movies. */

-- Q19. Who are the top three directors in each of the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)

/* Output format:
+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
select * from ratings
select * from names
-- Type your code below:
WITH top_genres AS (
    SELECT g.genre
    FROM genre AS g
    JOIN ratings AS r ON g.movie_id = r.movie_id
    WHERE r.avg_rating > 8
    GROUP BY g.genre
    ORDER BY COUNT(*) DESC
    OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY
),
director_movies AS (
    SELECT 
        g.genre,
        n.name AS director_name,
        COUNT(*) AS movie_count
    FROM genre AS g
    JOIN movie AS m ON g.movie_id = m.id
    JOIN ratings AS r ON m.id = r.movie_id
    JOIN director_mapping AS dm ON m.id = dm.movie_id
    JOIN names AS n ON dm.name_id = n.id
    WHERE r.avg_rating > 8
      AND g.genre IN (SELECT genre FROM top_genres)
    GROUP BY g.genre, n.name
),
ranked_directors AS (
    SELECT 
        genre,
        director_name,
        movie_count,
        RANK() OVER (PARTITION BY genre ORDER BY movie_count DESC) AS rank_no
    FROM director_movies
)
SELECT director_name,genre, movie_count
FROM ranked_directors
WHERE rank_no <= 3
ORDER BY genre, movie_count DESC;

-- In action genre Anthony russo,James Mangold and Joe russo are top directors with movie count 2


-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q20. Who are the top two actors whose movies have a median rating >= 8?

-- Hint: Utilize INNER JOINs to combine the 'names', 'role_mapping', 'movie', and 'ratings' tables based on their relationships.
-- Hint: Apply filtering conditions in the WHERE clause using logical conditions for median rating and category.
-- Hint: Group the results by the actor's name using GROUP BY.
-- Hint: Utilize aggregate functions such as COUNT() to count the number of movies each actor has participated in.
select * from role_mapping;
select * from ratings
/* Output format:
+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christian Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */

-- Type your code below:
select top 2 n.name as actor_name , count(m.id) as movie_count from names as n
inner join role_mapping as rm
 on n.id = rm.name_id
inner join movie as m
 on rm.movie_id = m.id
inner join ratings as r
 on m.id = r.movie_id
where r.median_rating >= 8 and rm.category = 'actor'
group by n.name
order by movie_count desc;

-- Mammootly and Mohanlal were top two actors whose movies have a median rating >= 8





/* Did you find the actor 'Mohanlal' in the list? If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q21. Which are the top three production houses based on the number of votes received by their movies?

-- Hint: Use a Common Table Expression (CTE) named 'top_prod' to find the top production companies based on total votes.
-- Hint: Utilize a LEFT JOIN to combine the 'movie' and 'ratings' tables based on 'id' and 'movie_id' respectively.
-- Hint: Filter out NULL production company values using IS NOT NULL in the WHERE clause.
-- Hint: Utilize the SUM() function to calculate the total votes for each production company.
-- Hint: Implement the ROW_NUMBER() function along with ORDER BY to assign ranks to production companies based on total votes, ordered in descending order.
-- Hint: Limit the number of results to the top 3 using ROW_NUMBER() and WHERE clause.
select * from movie;
select * from ratings;

/* Output format:
+-------------------+-------------------+---------------------+
|production_company |   vote_count		|	prod_comp_rank    |
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|		.		      |
|	.				|		.			|		.		  	  |
+-------------------+-------------------+---------------------+*/

-- Type your code below:
with top_prod as (
    select m.production_company, sum(r.total_votes) as vote_count from movie as m
    left join ratings as r 
    on m.id = r.movie_id
    where m.production_company is not null
    group by m.production_company
)
select top 3 production_company, vote_count , row_number() over(order by vote_count desc) as prod_comp_rank
from top_prod;

--Marvel Studios is the top production company with 2656967 votes and placed as 1st rank in production company
--Twentieth Century Fox is top 2 production company with 2411163 votes
--Warner Bros is top 3 production company with 2396057 votes p
SELECT * FROM [dbo].[director_mapping]

SELECT * FROM [dbo].[genre]

SELECT * FROM [dbo].[movie]

SELECT * FROM [dbo].[names]

SELECT * FROM [dbo].[ratings]

SELECT * FROM [dbo].[role_mapping]







-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the
-- list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker.)

/* Output format:
+---------------+---------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes	|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+---------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|		3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|		.		|	       .		  |	   .	    		 |		.	       |
|		.		|		.		|	       .		  |	   .	    		 |		.	       |
+---------------+---------------+---------------------+----------------------+-----------------+*/

-- Type your code below:
with rank_actors as (
    select n.name as actor_name ,sum(r.total_votes) as total_votes,
    count(distinct m.id) as movie_count ,
    cast(sum(r.avg_rating * r.total_votes) as float) / sum(r.total_votes) as actor_avg_rating
    from names as n
    inner join role_mapping as rm
     on n.id = rm.name_id
    inner join movie as m
     on rm.movie_id = m.id
    inner join ratings as r
     on m.id = r.movie_id
    where lower(m.country) like 'india%' and lower(rm.category) = 'actor'
    group by n.name
    having count(distinct m.id) >= 5
)
select actor_name, total_votes, movie_count, round(actor_avg_rating,2) as actor_avg_rating,
rank() over(order by actor_avg_rating desc, total_votes desc) as actor_rank
from rank_actors;
 
-- Vijay sethupathi is at the top of the list with 23114 votes ,5 movies and 8.42 average rating
-- Fahadh Faasil is at the 2nd position in the list with 13557 votes
-- Yogi babu is at the 3rd position in the list with 8500 votes




-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q23.Find the top five actresses in Hindi movies released in India based on their average ratings.
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker.)

-- Hint: Utilize a Common Table Expression (CTE) named 'actress_ratings' to aggregate data for actresses based on specific criteria.
-- Hint: Use INNER JOINs to combine the 'names', 'role_mapping', 'movie', and 'ratings' tables based on their relationships.
-- Hint: Consider which columns are necessary for the output and ensure they are selected in the SELECT clause.
-- Hint: Apply filtering conditions in the WHERE clause using logical conditions for category and language.
-- Hint: Utilize aggregate functions such as SUM() and COUNT() to calculate total votes, movie count, and average rating for each actress.
-- Hint: Use GROUP BY to group the results by actress name.
-- Hint: Implement the ROW_NUMBER() function along with ORDER BY to assign ranks to actresses based on average rating and total votes, ordered in descending order.
-- Hint: Specify the condition for selecting actresses with at least 3 movies using a WHERE clause.
-- Hint: Limit the number of results to the top 5 using LIMIT.


/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:
with actress_ratings as(
    SELECT n.name as actress_name,
        COUNT(m.id) as movie_count,
        SUM(r.total_votes) as total_votes,
        CAST(SUM(r.avg_rating * r.total_votes) AS FLOAT) / NULLIF(SUM(r.total_votes), 0) AS actress_avg_rating
    FROM names AS n
    INNER JOIN role_mapping AS rm 
        ON n.id = rm.name_id
    INNER JOIN movie AS m 
        ON rm.movie_id = m.id
    INNER JOIN ratings AS r 
        ON m.id = r.movie_id
    WHERE rm.category = 'actress' AND LOWER(m.languages) LIKE '%hindi%' AND LOWER(m.country) LIKE '%india%'     
    GROUP BY n.name
    HAVING COUNT(m.id) >= 3                   
)
SELECT TOP 5 actress_name, total_votes, movie_count,
    ROUND(actress_avg_rating, 2) AS actress_avg_rating,
    ROW_NUMBER() OVER (ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
FROM actress_ratings
ORDER BY actress_rank;

-- Taapsee Pannu,Kriti Sanon,Divya Dutta,Shraddha Kapoor and Kriti Kharbanda those are the top 5 five actresses in Hindi movies released
--in India based on their average ratings.
--Taapsee Pannu was on the top with 7.74 average rating
--Kriti Kharbanda was on last with 4.8 averaging rating



-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Now let us divide all the thriller movies in the following categories and find out their numbers.
/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories: 
			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop   */
            
-- Hint: Utilize LEFT JOINs to combine the 'movie', 'ratings', and 'genre' tables based on their relationships.
-- Hint: Use the CASE statement to categorize movies based on their average rating into 'Superhit', 'Hit', 'One time watch', and 'Flop'.
-- Hint: Implement logical conditions within the CASE statement to define the movie categories based on rating ranges.
-- Hint: Apply filtering conditions in the WHERE clause to select movies with a specific genre ('thriller') and a total vote count exceeding 25000.
-- Hint: Utilize the LOWER() function to ensure case-insensitive comparison of genre names.

/* Output format :

+-------------------+-------------------+
|   movie_name	    |	movie_category  |
+-------------------+--------------------
|	Pet Sematary	|	One time watch	|
|       -       	|		.			|
|	    -   		|		.			|
+---------------+-------------------+ */


-- Type your code below:
SELECT 
    m.title AS movie_name,
    CASE
        WHEN r.avg_rating > 8 THEN 'Superhit'
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit'
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch'
        WHEN r.avg_rating < 5 THEN 'Flop'
    END AS movie_category
FROM movie AS m
LEFT JOIN ratings AS r 
    ON m.id = r.movie_id
LEFT JOIN genre AS g 
    ON m.id = g.movie_id
WHERE LOWER(g.genre) = 'thriller'
  AND r.total_votes >= 25000;

--there are 77 thriller movies having atleast 25000 votes
-- 4 movies are super hit
--18 movies are hit movies
--3 movies are flop and remaining are one time watch 



-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment. */

-- Segment 4:

    
-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to get the output according to the output format given below.)

-- Hint: Utilize a Common Table Expression (CTE) named 'genre_summary' to calculate the average duration for each genre.
-- Hint: Use a LEFT JOIN to combine the 'genre' and 'movie' tables based on the 'movie_id' and 'id' respectively.
-- Hint: Implement the ROUND() function to round the average duration to two decimal places.
-- Hint: Utilize the AVG() function along with GROUP BY to calculate the average duration for each genre.
-- Hint: In the main query, use the SUM() and AVG() window functions to compute the running total duration and moving average duration respectively.
-- Hint: Utilize the ROWS UNBOUNDED PRECEDING option to include all rows from the beginning of the partition.


/* Output format:
+---------------+-------------------+----------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration   |
+---------------+-------------------+----------------------+----------------------+
|	comedy		|			145		|	       106.2	   |	   128.42	      |
|		.		|			.		|	       .		   |	   .	    	  |
|		.		|			.		|	       .		   |	   .	    	  |
|		.		|			.		|	       .		   |	   .	    	  |
+---------------+-------------------+----------------------+----------------------+*/

-- Type your code below:
WITH genre_summary AS (
    SELECT 
        g.genre,
        ROUND(AVG(CAST(m.duration AS FLOAT)), 2) AS avg_duration
    FROM genre AS g
    LEFT JOIN movie AS m ON g.movie_id = m.id
    WHERE m.duration IS NOT NULL
    GROUP BY g.genre
)
SELECT 
    genre,
    avg_duration,
    SUM(avg_duration) OVER (
        ORDER BY genre ROWS UNBOUNDED PRECEDING
    ) AS running_total_duration,
    ROUND(AVG(avg_duration) OVER (
        ORDER BY genre ROWS UNBOUNDED PRECEDING
    ), 2) AS moving_avg_duration
FROM genre_summary
ORDER BY genre;



-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------


/* Finally, let’s find out the names of the top two production houses that have produced the highest number of hits
   among multilingual movies.
   
Q26. What are the top two production houses that have produced the highest number of hits (median rating >= 8) among
multilingual movies? */
-- Hint: Utilize a Common Table Expression (CTE) named 'top_prod' to find the top production companies based on movie count.
-- Hint: Use a LEFT JOIN to combine the 'movie' and 'ratings' tables based on their relationship.
-- Hint: Apply filtering conditions in the WHERE clause using logical conditions for median rating, production company existence, and language specification.
-- Hint: Utilize aggregate functions such as COUNT() to count the number of movies for each production company.
-- Hint: Implement the ROW_NUMBER() function along with ORDER BY to assign ranks to production companies based on movie count, ordered in descending order.
-- Hint: Apply filtering conditions in the WHERE clause using logical conditions for median rating, production company existence, and language specification.
-- Hint: Limit the number of results to the top 2 using ROW_NUMBER() and WHERE clause.
-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0.
-- If there is a comma, that means the movie is of more than one language.


/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/

-- Type your code below:
WITH top_prod AS (
    SELECT 
        m.production_company,
        COUNT(*) AS movie_count,
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS prod_comp_rank
    FROM movie AS m
    JOIN ratings AS r ON m.id = r.movie_id
    WHERE r.median_rating >= 8
      AND m.production_company IS NOT NULL
      AND CHARINDEX(',', m.languages) > 0   -- multilingual check
    GROUP BY m.production_company
)
SELECT production_company, movie_count, prod_comp_rank
FROM top_prod
WHERE prod_comp_rank <= 2;

-- Star cinema and Twentieth Century Fox are the top two production houses that have produced the highest number of hits
--(median rating >= 8) among multilingual movies.
--Star cinema produced 7 movies and Twentieth Century Fox produced 2 movies



-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q27. Who are the top 3 actresses based on the number of Super Hit movies (average rating > 8) in 'drama' genre?

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:
WITH drama_superhit_actresses AS (
    SELECT 
        n.name AS actress_name,
        SUM(r.total_votes) AS total_votes,
        COUNT(DISTINCT m.id) AS movie_count,
        ROUND(AVG(r.avg_rating), 2) AS actress_avg_rating
    FROM movie AS m
    JOIN ratings AS r ON m.id = r.movie_id
    JOIN genre AS g ON m.id = g.movie_id
    JOIN role_mapping AS rm ON m.id = rm.movie_id
    JOIN names AS n ON rm.name_id = n.id
    WHERE g.genre = 'Drama'
      AND r.avg_rating > 8
      AND rm.category = 'actress'
    GROUP BY n.name
)
SELECT 
    actress_name,
    total_votes,
    movie_count,
    actress_avg_rating,
    RANK() OVER (ORDER BY movie_count DESC, actress_avg_rating DESC) AS actress_rank
FROM drama_superhit_actresses
WHERE movie_count > 0
ORDER BY actress_rank
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;

--Amanda Lawrence, Denise Gough, Susan Brown are the top 3 actresses based on the number of Super Hit movies (average rating > 8)
--in 'drama' genre

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------

