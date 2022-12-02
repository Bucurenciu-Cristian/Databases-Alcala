--this is the finnal version
--\pset pager off

BEGIN;

\echo 'creating schema'

CREATE SCHEMA IF NOT EXISTS cal2;

\echo 'creating interim tables import_*'




CREATE TABLE IF NOT EXISTS cal2.import_actors(
    name                     TEXT    NOT NULL
    ,birthday                DATE    
    
);



CREATE TABLE IF NOT EXISTS cal2.import_movies_actors(
    year                TEXT        NOT NULL
    ,title              TEXT        NOT NULL
    ,name               TEXT
    
);



CREATE TABLE IF NOT EXISTS cal2.import_directors(
    name                TEXT        NOT NULL
    ,birthday           TEXT
    
);



CREATE TABLE IF NOT EXISTS cal2.import_movies_reviews(
    year                INTEGER        NOT NULL
    ,title              TEXT           NOT NULL
    ,rating             REAL
    ,author             TEXT
    ,content            TEXT
    ,hash               TEXT
    ,webpage            TEXT
    
);



CREATE TABLE IF NOT EXISTS cal2.import_movies_directors(
    movie               TEXT        NOT NULL
    ,year               TEXT        NOT NULL
    ,name               TEXT
    
);



CREATE TABLE IF NOT EXISTS cal2.import_movies(
    year                TEXT
    ,title              TEXT
    ,genres             TEXT
    ,rating             TEXT
    ,runtime            TEXT
    ,language           TEXT
    ,mpa_rating         TEXT
    
);



CREATE TABLE IF NOT EXISTS cal2.import_movies_medias(
    year                TEXT        NOT NULL
    ,title              TEXT        NOT NULL
    ,type               TEXT        NOT NULL
    ,url                TEXT        NOT NULL
    ,size               TEXT        NOT NULL
    
);


\echo 'Bulk loading data into import_* tables'

\COPY cal2.import_actors                                FROM 'actors.csv'                           WITH (FORMAT csv, HEADER, DELIMITER E'\t', NULL 'NULL', ENCODING 'UTF-8');
\COPY cal2.import_movies_actors                         FROM 'actors_movies.csv'                    WITH (FORMAT csv, HEADER, DELIMITER E'\t', NULL 'NULL', ENCODING 'UTF-8');
\COPY cal2.import_directors                             FROM 'directors.csv'                        WITH (FORMAT csv, HEADER, DELIMITER E'\t', NULL 'NULL', ENCODING 'UTF-8');
\COPY cal2.import_movies_reviews                        FROM 'movie_reviews.csv'                    WITH (FORMAT csv, HEADER, DELIMITER E'\t', NULL 'NULL', ENCODING 'UTF-8');
\COPY cal2.import_movies_directors                      FROM 'movies_directors.csv'                 WITH (FORMAT csv, HEADER, DELIMITER E'\t', NULL 'NULL', ENCODING 'UTF-8');
\COPY cal2.import_movies                                FROM 'std_movies.csv'                       WITH (FORMAT csv, HEADER, DELIMITER E'\t', NULL 'NULL', ENCODING 'UTF-8');
\COPY cal2.import_movies_medias                         FROM 'movies_medias.csv'                    WITH (FORMAT csv, HEADER, DELIMITER E'\t', NULL 'NULL', ENCODING 'UTF-8');

/*
Using a simple bash code we count the rows in the csv files. then we comaper them to the number of rows in the imported table. the numbers has to match to ensure that all data has been copied.
Bash code: pc ~ % cat filename.csv | wc -l 
then the number minues one to obtain all the rows with out the header. 
the calculated number is printed after the description which table's rows is being counted. 
*/


\echo 'number of rows in the imported table of import_actors:'
\echo 'number of rows in the csv file: 997'
SELECT count(*) FROM cal2.import_actors;
\echo 'calculate the percentage of null values in the column'
SELECT 100.0 * SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS namepercent, 100.0 * SUM(CASE WHEN birthday IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS birthdaypercent FROM cal2.import_actors;
\echo 'calculate number of rows in column = birthday has the value of NULL'
SELECT count(*) FROM cal2.import_actors WHERE birthday IS NULL;
\echo '----------------------------------------------------------------------------'

\echo 'number of rows in the imported table of import_movies_actors:'
\echo 'number of rows in the csv file: 210'
SELECT count(*) FROM cal2.import_movies_actors;
--SELECT count(*) FROM cal2.import_movies_actors WHERE "name" || "year" || "title" IS NULL;
\echo 'calculate the percentage of null values in the column'
SELECT 100.0 * SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS namepercent, 100.0 * SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS yearpercent FROM cal2.import_movies_actors;
\echo 'calculate number of rows in column = name has the value of NULL'
SELECT count(*) FROM cal2.import_movies_actors WHERE name IS NULL;
\echo '----------------------------------------------------------------------------'


\echo 'number of rows in the imported table of import_directors:'
\echo 'number of rows in the csv file: 560'
SELECT count(*) FROM cal2.import_directors;
--SELECT count(*) FROM cal2.import_directors WHERE "name" || "birthday" IS NULL;
\echo 'calculate the percentage of null values in the column'
SELECT 100.0 * SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS namepercent, 100.0 * SUM(CASE WHEN birthday IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS birthdaypercent FROM cal2.import_directors;
\echo 'calculate number of rows in column = birthday has the value of NULL'
SELECT count(*) FROM cal2.import_directors WHERE birthday IS NULL;
\echo '----------------------------------------------------------------------------'



\echo 'number of rows in the imported table of import_movies_reviews:'
\echo 'number of rows in the csv file: 1129'
SELECT count(*) FROM cal2.import_movies_reviews;
--SELECT count(*) FROM cal2.import_actors WHERE "year" || "title" || "rating" || "hash" || "content" || "webpage" || "author" IS NULL;
\echo 'calculate the percentage of null values in the column'
SELECT 100.0 * SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS yearpercent, 100.0 * SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS titlepercent, 100.0 * SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS ratingpercent, 100.0 * SUM(CASE WHEN hash IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS hashpercent, 100.0 * SUM(CASE WHEN content IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS contentpercent, 100.0 * SUM(CASE WHEN webpage IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS webpagepercent, 100.0 * SUM(CASE WHEN author IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS authorpercent  FROM cal2.import_movies_reviews;
\echo 'there is no NULL value in this table'
--\echo 'calculate number of rows in column = birthday has the value of NULL'
--SELECT count(*) FROM cal2.import_directors WHERE birthday IS NULL;
\echo '----------------------------------------------------------------------------'



\echo 'number of rows in the imported table of import_movies_directors:'
\echo 'number of rows in the csv file: 147'
SELECT count(*) FROM cal2.import_movies_directors;
--SELECT count(*) FROM cal2.import_actors WHERE "movie" || "year" || "name" IS NULL;
\echo 'calculate the percentage of null values in the column'
SELECT 100.0 * SUM(CASE WHEN movie IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS moviepercent, 100.0 * SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS yearpercent, 100.0 * SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS namepercent FROM cal2.import_movies_directors;
\echo 'calculate number of rows in column = name has the value of NULL'
SELECT count(*) FROM cal2.import_movies_directors WHERE name IS NULL;
\echo '----------------------------------------------------------------------------'





\echo 'number of rows in the imported table of import_movies:'
\echo 'number of rows in the csv file: 1129'
SELECT count(*) FROM cal2.import_movies;
--SELECT count(*) FROM cal2.import_actors WHERE "year" || "title" || "genres" || "rating" || "runtime" || "language" || "mpa_rating" IS NULL;
\echo 'calculate the percentage of null values in the column'
SELECT 100.0 * SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS yearpercent, 100.0 * SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS titlepercent, 100.0 * SUM(CASE WHEN genres IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS genrespercent, 100.0 * SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS ratingpercent, 100.0 * SUM(CASE WHEN runtime IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS runtimepercent, 100.0 * SUM(CASE WHEN language IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS languagepercent, 100.0 * SUM(CASE WHEN mpa_rating IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS mpa_ratingpercent FROM cal2.import_movies;
\echo 'calculate number of rows in column = mpa_rating has the value of NULL'
SELECT count(*) FROM cal2.import_movies WHERE mpa_rating IS NULL;
\echo '----------------------------------------------------------------------------'





\echo 'number of rows in the imported table of import_movies_medias:'
\echo 'number of rows in the csv file: 1109'
SELECT count(*) FROM cal2.import_movies_medias;
--SELECT count(*) FROM cal2.import_actors WHERE "year" || "title" || "type" || "url" || "size" IS NULL;
\echo 'calculate the percentage of null values in the column'
SELECT 100.0 * SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS yearpercent, 100.0 * SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS titlepercent, 100.0 * SUM(CASE WHEN type IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS typepercent, 100.0 * SUM(CASE WHEN url IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS urlpercent, 100.0 * SUM(CASE WHEN size IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS sizepercent FROM cal2.import_movies_medias;
\echo 'table does not contain NULL value'
--\echo 'calculate number of rows in column = name has the value of NULL'
--SELECT count(*) FROM cal2.import_movies_actors WHERE name IS NULL;
\echo '----------------------------------------------------------------------------'




/*
As all the data has been copied successfully. Final tables are going to be made. 
The percentage of the NULL values in each column is presented.
The number of rows in the columns Containing NULL value is also shown. 
*/









\echo 'create and populate table person from actors & directors'

CREATE TABLE IF NOT EXISTS cal2.people(
    full_name       TEXT        NOT NULL
    ,coutry         TEXT
    ,birthday       DATE
    ,CONSTRAINT people_pk PRIMARY KEY (full_name)
);

INSERT INTO cal2.people (full_name, coutry, birthday)
SELECT
    DISTINCT 
    name                    AS full_name
    ,NULL                   AS coutry
    ,birthday :: DATE       AS birthday
    FROM cal2.import_directors
UNION
SELECT
    DISTINCT
    name                    AS full_name
    ,NULL                   AS coutry
    ,birthday :: DATE       AS birthday
    FROM cal2.import_actors
ON CONFLICT DO NOTHING;

--SELECT count(*) FROM cal2.people;
-- Checkes necessary for this table 
-- 1. first check if there is no NULL value in the primary key
--2. Explain how the numbers add up to make this table 
--3. check for duplicates if any
\echo 'Percentage of NULL value in each column (Primary key included == 0.00%)'
SELECT 100.0 * SUM(CASE WHEN full_name IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS namepercent, 100.0 * SUM(CASE WHEN coutry IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS countrypercent, 100.0 * SUM(CASE WHEN birthday IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS birthdaypercent FROM cal2.people;
\echo 'number of rows in the import_actors'
SELECT count(*) FROM cal2.import_actors;
\echo 'number of rows in the import_directors'
SELECT count(*) FROM cal2.import_directors;
SELECT name FROM cal2.import_actors INTERSECT SELECT name FROM cal2.import_directors;
\echo 'Further more there is no NULL value in primary key'
SELECT full_name, COUNT(full_name) FROM cal2.people GROUP BY full_name HAVING COUNT(full_name) > 1; --count doubles
\echo 'The table works and there is no missing data as Data_actor + Data_Directors - (Data_actor ∩ Data_director) == rows for Cal2.people --> 997 + 560 - 23 = 1534'

\echo '---------------------------------------------------------------'
\echo '---------------------------------------------------------------'
\echo '---------------------------------------------------------------'



\echo 'create & populate table directors'
CREATE TABLE IF NOT EXISTS cal2.directors(
    name                TEXT           NOT NULL
    ,person             TEXT           NOT NULL
    ,CONSTRAINT directors_pk PRIMARY KEY (name)
    ,CONSTRAINT directors_people_fk FOREIGN KEY (person)
        REFERENCES cal2.people(full_name) MATCH FULL ON DELETE RESTRICT ON UPDATE CASCADE
);

INSERT INTO cal2.directors(name, person)
SELECT
    DISTINCT
    name                AS name
    ,full_name          AS person
    FROM cal2.import_directors
        JOIN cal2.people ON name = full_name;

--SELECT count(*) FROM cal2.directors;
\echo 'the percentage of NULL value in each column'
SELECT 100.0 * SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS namepercent, 100.0 * SUM(CASE WHEN person IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS personpersent FROM cal2.directors;
\echo 'show the numbers of row in the temparpry table of import_directors'
SELECT count(*) FROM cal2.import_directors;
\echo 'number of rows in common with table people between table directors and people which shows that all data in table directors are in the table people therefore fullfiling the FK constrains'
SELECT count(*) FROM (SELECT person FROM cal2.directors INTERSECT SELECT full_name FROM cal2.people) I; 
\echo 'as it can bee seen the intersect all the data from table import_directors has been transfered and checked by its foriegn key with table people and percentage of NULL is also persented as 0% for both columns'
\echo '---------------------------------------------------------------'
\echo '---------------------------------------------------------------'
\echo '---------------------------------------------------------------'




\echo 'create & populate actors'
CREATE TABLE IF NOT EXISTS cal2.actors(
    name            TEXT            NOT NULL
    ,person         TEXT            NOT NULL
    ,CONSTRAINT actors_pk PRIMARY KEY (name)
    ,CONSTRAINT actors_people_fk FOREIGN KEY (person)
        REFERENCES cal2.people(full_name) MATCH FULL ON DELETE RESTRICT ON UPDATE CASCADE

);

INSERT INTO cal2.actors(name, person)
SELECT
    DISTINCT
    name                    AS name
    ,full_name              AS person
    FROM cal2.import_actors
        JOIN cal2.people ON name = full_name;

--SELECT count(*) FROM cal2.actors;
\echo 'the percentage of NULL values in each column'
SELECT 100.0 * SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS namepercent, 100.0 * SUM(CASE WHEN person IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS personpersent FROM cal2.actors;
\echo 'numbers of rows that are in table import_actors'
SELECT count(*) FROM cal2.import_actors;
\echo 'number of rows in the common in the table actors and people that shows all the rows in actor are included in people therefore fullfilling FK Contrains'
SELECT count(*) FROM (SELECT person FROM cal2.actors INTERSECT SELECT full_name FROM cal2.people) II;
\echo 'as it can bee seen the intersect all the data from table import_directors has been transfered and checked by its foriegn key with table people and percentage of NULL is also persented as 0% for both columns'
\echo '---------------------------------------------------------------'
\echo '---------------------------------------------------------------'
\echo '---------------------------------------------------------------'




\echo 'create & populate movies'
CREATE TABLE IF NOT EXISTS cal2.movies(
    year                INTEGER             NOT NULL
    ,title              TEXT                NOT NULL
    ,runtime            INTEGER             NOT NULL
    ,language           TEXT                NOT NULL
    ,mpa_rating         TEXT
    ,director           TEXT
    ,CONSTRAINT movies_pk PRIMARY KEY (year, title)
    ,CONSTRAINT movies_directors_fk FOREIGN KEY (director)
        REFERENCES cal2.directors (name) MATCH FULL ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO cal2.movies(year, title, runtime, language, mpa_rating, director)
SELECT
    DISTINCT ON (IM.year, IM.title)           
    IM.year :: INTEGER                       AS year                 
    ,IM.title                                AS title
    ,substring(IM.runtime, '\d+') :: INTEGER AS runtime
    ,IM.language                             AS language
    ,IM.mpa_rating                           AS mpa_rating
    ,ID.name                                 AS director
    FROM cal2.import_movies IM
        LEFT JOIN cal2.import_movies_directors IMD ON IM.year = IMD.year AND IM.title = IMD.movie
        LEFT JOIN cal2.import_directors ID         ON ID.name = IMD.name
        ;

--SELECT count(*) FROM cal2.movies;
\echo 'number of rows in the table import_movies:'
SELECT count(*) FROM cal2.import_movies;
\echo 'show the percentage of NULL values in each columns'
SELECT 100.0 * SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS yearpercent, 100.0 * SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS titlepercent, 100.0 * SUM(CASE WHEN runtime IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS runtimepercent, 100.0 * SUM(CASE WHEN language IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS languagepercent, 100.0 * SUM(CASE WHEN mpa_rating IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS mpa_ratingpercent, 100.0 * SUM(CASE WHEN director IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS directorpercent FROM cal2.movies;
\echo 'shows the number of rows in common on year and title between the tables import_movies and import_movies_directors'
SELECT count(*) FROM (SELECT year, title FROM cal2.import_movies INTERSECT SELECT year, movie FROM cal2.import_movies_directors) III;
\echo 'number of row in table import_movies that are not in the import_movies_directors ---> 979 just by uncommentinng the commneted code below'
--SELECT import_movies.year, import_movies.title FROM cal2.import_movies EXCEPT SELECT import_movies_directors.year, import_movies_directors.movie FROM cal2.import_movies_directors;
\echo 'number of rows in common on name between the tables import_director & import_movies_directors'
SELECT count(*) FROM (SELECT name FROM cal2.import_directors INTERSECT SELECT name FROM cal2.import_movies_directors) IIII; -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------hrer i neeed to figure out the way to justify the usage of the left joint on tables IM and ID wtf is happeninnggggggg----------------------------------------
\echo 'count the doubles in the table import_movies'
SELECT title, year, COUNT(year), COUNT(title) FROM cal2.import_movies GROUP BY title, year HAVING COUNT(title) > 1 AND COUNT(year) > 1; --count doubles
\echo 'as it is shown Adding the 147 rows in common with table import_movies_director to the 979 rows of that are table import_movies and not in the import_movies_directors adds up to 1126 which is 3 less the import_movies row count which after taking to account that import_movies had 3 doubles we can conclude that the left join is fully operational between the table import_movies and import_movies_directors'
--SELECT count(*) FROM (SELECT name);
--SELECT count(*) FROM (SELECT year FROM cal2.import_movies A LEFT JOIN cal2.import_movies_directors B ON A.year = B.year WHERE B.year IS NULL) IIII;
\echo '---------------------------------------------------------------'
\echo '---------------------------------------------------------------'
\echo '---------------------------------------------------------------'



\echo 'create & populate movies_actors'
CREATE TABLE IF NOT EXISTS cal2.movies_actors(
    year                INTEGER         NOT NULL
    ,title              TEXT            NOT NULL
    ,actor              TEXT            NOT NULL
    ,CONSTRAINT movies_actors_movies_fk FOREIGN KEY (year, title) REFERENCES cal2.movies (year, title)
        MATCH FULL ON DELETE RESTRICT ON UPDATE CASCADE
    ,CONSTRAINT movies_actors_actors_fk FOREIGN KEY (actor) REFERENCES cal2.actors (name)
        MATCH FULL ON DELETE RESTRICT ON UPDATE CASCADE
);

INSERT INTO cal2.movies_actors(year, title, actor)
SELECT
    DISTINCT ON (IMA.year, IMA.title)
    IMA.year :: INTEGER                                 AS year
    ,IMA.title                                          AS title
    ,IMA.name                                           AS actor
    FROM cal2.import_movies_actors IMA
        JOIN cal2.actors A ON IMA.name = A.name
        JOIN cal2.movies M ON IMA.title = M.title AND (IMA.year :: INTEGER) = M.year
        ;

\echo 'Percentage of NULL value in each column (Primary key included == 0.00%)'
SELECT 100.0 * SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS yearpercent, 100.0 * SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS titlepercent, 100.0 * SUM(CASE WHEN actor IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS actorpercent FROM cal2.movies_actors;
\echo 'number of rows in the import_movies_actors'
SELECT count(*) FROM cal2.import_movies_actors;
/*
\echo 'number of rows in common between movies_actor and actors on name'
SELECT actor FROM cal2.movies_actors INTERSECT SELECT name FROM cal2.actors;
\echo 'nnumber of rows that are in import_movies_actor and not in actors on name'
SELECT import_movies_actors.name FROM cal2.import_movies_actors EXCEPT SELECT actors.name FROM cal2.actors;
\echo 'number of doubles in the table import_movies_actors'
SELECT name, COUNT(name) FROM cal2.import_movies_actors GROUP BY name HAVING COUNT(name) > 1; --count doubles
\echo 'number of rows in common with the table import_movies_actors and movies based on YEAR????????? and title ---> 144'
--SELECT title FROM cal2.import_movies_actors INTERSECT SELECT title FROM cal2.movies;


*/




--SELECT count(*) FROM cal2.movies_actors;
\echo '---------------------------------------------------------------'
\echo '---------------------------------------------------------------'
\echo '---------------------------------------------------------------'






\echo 'create & populate genres'
CREATE TABLE IF NOT EXISTS cal2.movies_genres(
    year                INTEGER            NOT NULL
    ,title              TEXT               NOT NULL
    ,genre              TEXT               NOT NULL
    ,CONSTRAINT movies_genres_pk PRIMARY KEY (year, title, genre)
    ,CONSTRAINT movies_fk FOREIGN KEY (year, title) 
        REFERENCES cal2.movies (year, title)
        MATCH FULL ON DELETE RESTRICT ON UPDATE CASCADE
);

INSERT INTO cal2.movies_genres(year, title, genre)
SELECT
    DISTINCT ON (year, title, genre)
    import_movies.year :: INTEGER                        AS year
    ,import_movies.title                                 AS title
    ,regexp_split_to_table(import_movies.genres, '\s+')  AS genre
    FROM cal2.import_movies
        JOIN cal2.movies ON (import_movies.year :: INTEGER) = movies.year AND import_movies.title = movies.title
        ;

--\echo 'Percentage of NULL value in each column (Primary key included == 0.00%)'
--SELECT 100.0 * SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS yearpercent, 100.0 * SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS titlepercent, 100.0 * SUM(CASE WHEN genre IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS genrepercent FROM cal2.people;
\echo 'number of rows in the import_moveies'
SELECT count(*) FROM cal2.import_movies;
\echo 'number of rows in the movies'
SELECT count(*) FROM cal2.movies;
\echo 'the code belows shows that if we group by year and title we will have 1126 rows which is exactly correct therefore we have all the movies with their genere sperated like same movies can have multiple genre therefore multiple row'
--select count(concat(title, year)) FROM cal2.movies_genres group by title,year;  -- 1126 rows

\echo '---------------------------------------------------------------'
\echo '---------------------------------------------------------------'
\echo '---------------------------------------------------------------'






\echo 'create & populate website from media & review'
CREATE TABLE IF NOT EXISTS cal2.website (
    url                 TEXT        NOT NULL
    ,type               TEXT        NOT NULL
    ,CONSTRAINT website_pk PRIMARY KEY (url)
);

INSERT INTO cal2.website(url, type)
SELECT
    DISTINCT
    substring(webpage, '(https://[\/_\.a-z]+)\/' || replace(lower(author), ' ', '_'))     AS url
    , 'forum'                                                                               AS type
    FROM cal2.import_movies_reviews
UNION ALL
SELECT
    DISTINCT
    substring(url, '(https://[\/_\.a-z]+\/assets)')                                       AS url
    , 'gallery'                                                                             AS type
    FROM cal2.import_movies_medias;


--SELECT count(*) FROM cal2.website;
\echo 'Percentage of NULL value in each column (Primary key included == 0.00%)'
SELECT 100.0 * SUM(CASE WHEN url IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS urlpercent, 100.0 * SUM(CASE WHEN type IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS typepercent FROM cal2.website;
\echo 'number of rows in the import_movies_reviews'
SELECT count(DISTINCT substring(webpage, '(https://[\/_\.a-z]+)\/' || replace(lower(author), ' ', '_'))) FROM cal2.import_movies_reviews;
\echo 'number of rows in the import_movies_medias'
SELECT count(DISTINCT substring(url, '(https://[\/_\.a-z]+\/assets)')) FROM cal2.import_movies_medias;
\echo 'as it can be seen that 6 + 1 = 7 therefore all the data has transfered nothing has been lost'

\echo '---------------------------------------------------------------'
\echo '---------------------------------------------------------------'
\echo '---------------------------------------------------------------'





\echo 'create & populate reviews'
CREATE TABLE IF NOT EXISTS cal2.reviews (
    year                    INTEGER         NOT NULL
    , title                 TEXT            NOT NULL
    , rating                REAL        
    , author                TEXT            NOT NULL
    , content               TEXT            NOT NULL
    , hash                  TEXT            NOT NULL
    , site                  TEXT            NOT NULL
    ,CONSTRAINT reviews_pk PRIMARY KEY (year, title, author)
    ,CONSTRAINT reviews_website_fk FOREIGN key (site) REFERENCES cal2.website(url)
    ,CONSTRAINT reviews_movies_fk FOREIGN KEY (year, title) REFERENCES cal2.movies(year, title)

);


INSERT INTO cal2.reviews (year, title, rating, author, content, hash, site)
SELECT
    import_movies_reviews.year                                                                              AS year
    , import_movies_reviews.title                                                                           AS title
    , rating :: REAL                                                                                        AS rating
    , author                                                                                                AS author
    , content                                                                                               AS content
    , hash                                                                                                  AS hash
    ,substring(webpage, '(https://[\/_\.a-z]+)\/' || replace(lower(author), ' ', '_'))                      AS site
    FROM cal2.import_movies_reviews
        JOIN cal2.movies ON import_movies_reviews.year = movies.year AND import_movies_reviews.title = movies.title
        ;

--SELECT count(*) FROM cal2.reviews;
\echo 'Percentage of NULL value in each column (Primary key included == 0.00%)'
SELECT 100.0 * SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS yearpercent, 100.0 * SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS titlepercent, 100.0 * SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS ratingpercent, 100.0 * SUM(CASE WHEN author IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS authorpercent, 100.0 * SUM(CASE WHEN content IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS contentpercent, 100.0 * SUM(CASE WHEN hash IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS hashpercent, 100.0 * SUM(CASE WHEN site IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS sitepercent FROM cal2.reviews;
\echo 'number of rows in the import_movies_reviews'
SELECT count(*) FROM cal2.import_movies_reviews;
--\echo 'number of rows in the import_directors'
--SELECT count(*) FROM cal2.import_directors;
\echo 'rows in common between import_movies_reviews and table movies ----> 1126'
--SELECT year, title FROM cal2.import_movies_reviews INTERSECT SELECT year, title FROM cal2.movies; --1126
SELECT title, year, COUNT(year), COUNT(title) FROM cal2.import_movies_reviews GROUP BY title, year HAVING COUNT(title) > 1 AND COUNT(year) > 1; --count doubles
\echo 'As you can see when we go from imported table to processed table we miss 3 values and as we calculated above that are 3 duplicate values in the imported table which therefore is counted for our loss and in conclusion the table is working'

ROLLBACK;
-- I know some of the checks are not as optimal as they can be so my apologies still finding the way.
