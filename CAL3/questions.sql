--Q1--
\echo 'Question 1 show the number of people who are both actors and directors'
SELECT full_name FROM cal2.people A                                                                 ---- select full names from poeple which include both actors and directors
JOIN cal2.actors B ON A.full_name = B.name                                                           ---- inner join or find simlar rows which the name as actor is same in people
JOIN cal2.directors C ON A.full_name = C.name;                                                        ---- same for directors therefore give intersect of people and actors and directors. 

\echo 'Question 2 What is the overall minute count for all movies in which Tom Cruise is acting? Group the results by genre and provide the SQL code as well.'
SELECT MG.genre, sum(runtime) AS "Total" FROM cal2.movies_actors MC                                        ---- selecting genre and total min runtim from movies_actor with joinin
JOIN cal2.movies M          ON  MC.title = M.title  AND MC.year = M.year                                     --- joining talbe movies onn year and title 
JOIN cal2.movies_genres MG  ON  MC.title = MG.title AND MC.year = MG.year                                -- joining table movies_genres on year and title
WHERE MC.actor = 'Tom Cruise'                                                                            -- where the actors name is TOM CRUISE
GROUP BY MG.genre;                                                                                       -- group by genres. 
\echo 'Question 3 Show people acting or directing any Horror movies. Provide the relational expression for your SQL query as well.'
SELECT P.full_name FROM cal2.people P                                                                    --    
JOIN cal2.actors A                           ON P.full_name = A.person
JOIN cal2.movies_actors MC                  ON A.name = MC.actor
JOIN cal2.movies_genres MG                  ON MC.title = MG.title AND MC.year = MG.year
WHERE MG.genre = 'Horror'
UNION
SELECT P.full_name FROM cal2.people P
JOIN cal2.directors D                      ON P.full_name = D.person
JOIN cal2.movies M                         ON D.name = M.director
JOIN cal2.movies_genres MG                 ON M.title = MG.title AND M.year = MG.year
WHERE MG.genre = 'Horror';
\echo 'Question 4 How many people, considering actors and directors can you count from the movie "The Lord of the Rings: The Return of the King"?   Show the SQL code.'
WITH actors_directors AS (
    SELECT P.full_name, MC.title FROM cal2.people P
    JOIN cal2.actors A                              ON P.full_name = A.person
    JOIN cal2.movies_actors MC                      ON A.name = MC.actor
    UNION
    SELECT P.full_name, M.title FROM cal2.people P
    JOIN cal2.directors D                           ON P.full_name = D.person
    JOIN cal2.movies    M                           ON D.name = M.director
    )
SELECT
    title               AS "Movies"
    ,count(*)           AS "Actors & Directors"
    FROM actors_directors 
    WHERE title = 'The Lord if the Rings: The Return of the King'
    GROUP BY title;
\echo 'Question 5 Show  directors  and  the  movies  they    directed  for  those  people  being also  actors  in  addition to being directors. '
SELECT D.name, M.title FROM cal2.directors D
JOIN cal2.movies M                      ON D.name = M.director
JOIN cal2.movies_actors MC              ON M.year = MC.year AND M.title = MC.title
WHERE M.director = MC.actor;

SELECT P.full_name, M.title FROM cal2.people P
JOIN cal2.actors A          ON P.full_name = A.person
JOIN cal2.directors D       ON P.full_name = D.person
JOIN cal2.movies M          ON D.name = M.director
JOIN cal2.movies_actors MC  ON A.name = MC.actor;

