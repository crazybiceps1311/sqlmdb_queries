/*#How many movies currently exist in the database with an IMDb rating greater than 8.5?*/

SELECT
    COUNT(*)
FROM
    sqlmdb.movies
WHERE
    imdb_rating > 8.5;
    
/*#How many movies have a perfect metascore from Metacritic.com and what is the release year range?

Hint: Find the metascore attribute in the CRTIIC_REVIEWS table.*/  
SELECT 
    COUNT(*), release_year
FROM
    sqlmdb.critic_reviews
    INNER JOIN sqlmdb.movies
    USING(movie_guid)
WHERE
    metascore = 100
GROUP BY
    release_year
ORDER BY
    COUNT(*) DESC;

/*Which movie (title and release year) has the biggest cast?

Hint: Use the MOVIE_ACTORS table.*/

SELECT 
    movie_title,
    release_year,
    COUNT(person_guid)
FROM
    sqlmdb.movie_actors
    INNER JOIN sqlmdb.movies
    USING (movie_guid)
GROUP BY
    movie_title, release_year
ORDER BY
    COUNT(*) DESC;

/*How many movie industry participants (PERSONS) come from the country of Denmark?

Hint: Use the BIRTH_COUNTRY_A3CODE in the PERSONS table (the code for Denmark is "DNK").*/
    
SELECT 
    COUNT(*)
FROM 
    sqlmdb.persons
WHERE
    birth_country_a3code = 'DNK';
 
/*What is the approximate average runtime for movies from the 1950s?

Hint: The release_year should be between 1950 and 1959.*/    

SELECT 
    ROUND(AVG(runtime),2)
FROM
    sqlmdb.movies
WHERE 
    release_year BETWEEN 1950 AND 1959;
    
/*Which movie has the most taglines - those sometime unforgettable marketing slogans?*/ 
    
SELECT 
    movie_title,
    COUNT(tagline)
FROM
    sqlmdb.taglines
    INNER JOIN sqlmdb.movies
    USING (movie_guid)
GROUP BY
    movie_title
ORDER BY
    2 DESC;
 
/*Which movie made by the studio "Metro-Goldwyn-Mayer (MGM)" has the highest metascore?

Hint: Use the metascore attribute (from Metacritic.com) in the CRITIC_REVIEWS table.*/

SELECT 
    movie_title,
    metascore
FROM
    sqlmdb.movies
    INNER JOIN sqlmdb.critic_reviews 
    USING (movie_guid)
    INNER JOIN sqlmdb.movie_studios 
    USING (movie_guid)
    INNER JOIN sqlmdb.studios 
    USING (studio_guid)
WHERE 
    studio_name = 'Metro-Goldwyn-Mayer (MGM)'
ORDER BY
    metascore DESC;


/*How many movies include cast members (MOVIE_ACTORS) from Denmark?

Hint: Use the BIRTH_COUNTRY_A3CODE in the PERSONS table (with code "DNK" for Denmark).  Careful to handle duplicate movies in the result set.*/

SELECT
    COUNT( distinct movie_title)
FROM sqlmdb.movies
    INNER JOIN sqlmdb.movie_actors
    USING (movie_guid)
    INNER JOIN sqlmdb.persons
    USING (person_guid)
WHERE
    birth_country_a3code = 'DNK'
GROUP BY
    movie_title;

// re-look at the above query again

/*How many countries have 200 or more movie industry participants?

Hint: Use the BIRTH_COUNTRY_A3CODE in the PERSONS table.*/


SELECT 
    birth_country_a3code, COUNT(*)
FROM
    sqlmdb.persons
WHERE
    birth_country_a3code IS NOT NULL
    AND
    birth_country_a3code = 'ITA'
    AND
    
GROUP BY
    birth_country_a3code
HAVING
    COUNT(person_guid) > 200;


/*List the name, number of movies and total worldwide gross (SUM) for any director that has a movie in the top 25 films based on IMDb ratings (with ties going to the most votes).  What is the name of the director with largest worldwide gross?

Hint: Order by both IMDb ratings and votes.*/

SELECT 
    person_name, COUNT(movie_title)
FROM
    sqlmdb.movies
    INNER JOIN sqlmdb.movie_jobs
    USING (movie_guid)
    INNER JOIN sqlmdb.persons
    USING (person_guid)
WHERE
    job_code = 'DRTR'
    AND
    movie_title IN 
            (SELECT 
                movie_title 
            FROM 
                sqlmdb.movies
            WHERE 
                imdb_rating IS NOT NULL
            ORDER BY
                imdb_rating DESC, imdb_votes DESC
            FETCH FIRST 10 ROWS ONLY)
GROUP BY
    person_name
ORDER BY 2 DESC;
    
/*How many Italian born directors have made movies in this database?

Hint: Use the BIRTH_COUNTRY_A3CODE in the PERSONS table, along with the "DRTR" (for director) JOB_CODE in MOVIE_JOBS.  Of course, beware of duplicates since directors may direct more than one film!*/    
    
SELECT 
    person_name, COUNT(movie_title), SUM(worldwide_gross)
FROM
    sqlmdb.movies
    INNER JOIN sqlmdb.movie_jobs
    USING (movie_guid)
    INNER JOIN sqlmdb.persons
    USING (person_guid)
WHERE
    worldwide_gross IS NOT NULL
    AND
    job_code = 'DRTR'
    AND
    movie_title IN 
            (SELECT 
                movie_title 
            FROM 
                sqlmdb.movies
            WHERE 
                imdb_rating IS NOT NULL
            ORDER BY
                imdb_rating DESC, imdb_votes DESC
            FETCH FIRST 25 ROWS ONLY)
GROUP BY
    person_name
ORDER BY 
    3 DESC;    
    
/* Spot those movies which are rated high all accross the scoring websites.*/

select count(*) from sqlmdb.movies
where imdb_rating >= 9

union

select count(*) from sqlmdb.critic_reviews
where metascore >= 90

union

select count(*) from sqlmdb.rotten_tomatoes
where tomatometer >= 90;





    
    
    
    
    
    
    
    
    
    
    
    
    
    