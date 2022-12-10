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
-- here there is more thann necessary data to check everything is going alright as you can see them by uncomenting it.
\echo 'number of rows in the table import_movies:'
SELECT count(*) FROM cal2.import_movies;
\echo 'show the percentage of NULL values in each columns'
SELECT 100.0 * SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS yearpercent, 100.0 * SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS titlepercent, 100.0 * SUM(CASE WHEN runtime IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS runtimepercent, 100.0 * SUM(CASE WHEN language IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS languagepercent, 100.0 * SUM(CASE WHEN mpa_rating IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS mpa_ratingpercent, 100.0 * SUM(CASE WHEN director IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS directorpercent FROM cal2.movies;
--\echo 'shows the number of rows in common on year and title between the tables import_movies and import_movies_directors'
--SELECT count(*) FROM (SELECT year, title FROM cal2.import_movies INTERSECT SELECT year, movie FROM cal2.import_movies_directors) III;
--\echo 'number of row in table import_movies that are not in the import_movies_directors ---> 979 just by uncommentinng the commneted code below'
--SELECT import_movies.year, import_movies.title FROM cal2.import_movies EXCEPT SELECT import_movies_directors.year, import_movies_directors.movie FROM cal2.import_movies_directors;
--\echo 'number of rows in common on name between the tables import_director & import_movies_directors'
--SELECT count(*) FROM (SELECT name FROM cal2.import_directors INTERSECT SELECT name FROM cal2.import_movies_directors) IIII;
\echo 'show the number of doubles in the table import_movies'
SELECT title, year, COUNT(year), COUNT(title) FROM cal2.import_movies GROUP BY title, year HAVING COUNT(title) > 1 AND COUNT(year) > 1; --count doubles
\echo 'as it can be seen as it is left join we add the new column infos to the table movies while recieving its data from the table import_movies therefore no data has been lost'
--\echo 'as it is shown Adding the 147 rows in common with table import_movies_director to the 979 rows of that are table import_movies and not in the import_movies_directors adds up to 1126 which is 3 less the import_movies row count which after taking to account that import_movies had 3 doubles we can conclude that the left join is fully operational between the table import_movies and import_movies_directors'
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
--\echo 'number of rows in the import_movies_actors'
--SELECT count(*) FROM cal2.import_movies_actors;

SELECT
    DISTINCT ON (IMA.year, IMA.title)
    IMA.year :: INTEGER                                 AS year
    ,IMA.title                                          AS title
    FROM cal2.import_movies_actors IMA
        JOIN cal2.movies M ON IMA.title = M.title AND (IMA.year :: INTEGER) = M.year
        
EXCEPT
SELECT
    DISTINCT ON (year, title) 
    year
    ,title 
    FROM cal2.movies_actors;


\echo 'number of distinct year and title in the table import_movies_actors ---> 147'
--SELECT DISTINCT  year, title FROM cal2.import_movies_actors; -- 147 rows
\echo 'example below shows that there is no actor name for 16 rows of the table import_movies_actors and as name of actor is foreign key for actor and cant be NULL therefore after eliminating the 16 rows from the 147 distinct rows we will have 131 that has been inserted to our table--> talbe works!'
SELECT name FROM cal2.import_movies_actors WHERE year = '1195' AND title = 'Congo';







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
\echo 'all the data has been transformed and nothing is missinng as it is join and number of rows are equal further more there is no NULL value therefore all the PK and FK are valid too'



\echo "Start here PART 3"

--Q1--
\echo 'Question 1 show the number of people who are both actors and directors'
SELECT full_name FROM cal2.people A                                                                 ---- select full names from poeple which include both actors and directors
JOIN cal2.actors B ON A.full_name = B.name                                                           ---- inner join or find simlar rows which the name as actor is same in people
JOIN cal2.directors C ON A.full_name = C.name;                                                        ---- same for directors therefore give intersect of people and actors and directors.

/*
People --> A 
Actors --> B
Directors --> C 

π A.full_name (Actor ⋈<sub>A.full_name = B.name<sub> People ⋈<sub>A.full_name = C.name;<sub> Director)
*/

\echo 'Question 2 What is the overall minute count for all movies in which Tom Cruise is acting? Group the results by genre and provide the SQL code as well.'
SELECT MG.genre, sum(runtime) AS "Total" FROM cal2.movies_actors MC                                        ---- selecting genre and total min runtim from movies_actor with joinin
JOIN cal2.movies M          ON  MC.title = M.title  AND MC.year = M.year                                     --- joining talbe movies onn year and title
JOIN cal2.movies_genres MG  ON  MC.title = MG.title AND MC.year = MG.year                                -- joining table movies_genres on year and title
WHERE MC.actor = 'Tom Cruise'                                                                            -- where the actors name is TOM CRUISE
GROUP BY MG.genre;                                                                                       -- group by genres.

/*
Movies_Actor --> MC
movies --> M
movies_genre --> MG 

(MG.genre G sum(runtime) (σ MC.actor = Tom Cruise (Movies_actor ⋈<sub>MC.title = M.title  AND MC.year = M.year<sub> Movies ⋈<sub><MC.title = MG.title AND MC.year = MG.yearsub> Movies_genres)) 
*/

\echo 'Question 3 Show people acting or directing any Horror movies. Provide the relational expression for your SQL query as well.'
SELECT P.full_name FROM cal2.people P                                                                    -- selecting full name from people
JOIN cal2.actors A                           ON P.full_name = A.person                                  --- joininng with Actor on fullname = person 
JOIN cal2.movies_actors MC                  ON A.name = MC.actor                                        --- joining on MOvies_Actor onn Actor name = Movie_Actor Actor 
JOIN cal2.movies_genres MG                  ON MC.title = MG.title AND MC.year = MG.year                --- Joining on Movies Genere on the primary keys of movies 
WHERE MG.genre = 'Horror'                                                                               --- selecting gerne = Horror 
UNION                                                                                                   -- unnion or adding to 
SELECT P.full_name FROM cal2.people P                                                                   -- selecting full name from people
JOIN cal2.directors D                      ON P.full_name = D.person                                    --- joininng with Director on fullname = person 
JOIN cal2.movies M                         ON D.name = M.director                                       --- JOining with movies table on Director name = Movies Director 
JOIN cal2.movies_genres MG                 ON M.title = MG.title AND M.year = MG.year                   --- JJoining on Movies Genere on the primary keys of movies
WHERE MG.genre = 'Horror';                                                                              --- selecting gerne = Horror
/*
People --> P
Actors --> A 
Movies_Actors --> MC
Movies_genre--> MG
Directors --> D
Movies --> M 

π P.full_name (Poeple ⋈<sub>P.full_name = A.person<sub> Actors ⋈<sub>A.name = MC.actor<sub> Movies_Actor ⋈<sub>MC.title = MG.title ∧ MC.year = MG.year<sub> Movies_Genre) 
∪ 
π P.full_name (People ⋈<sub>P.full_name = D.person<sub> Directors ⋈<sub>D.name = M.director<sub> Movies ⋈<sub>M.title = MG.title ∧ M.year = MG.year<sub> Movies_Genre)

*/

\echo 'Question 4 How many people, considering actors and directors can you count from the movie "The Lord of the Rings: The Return of the King"?   Show the SQL code.'
WITH actors_directors AS (                                                                                              --- Creating temp table called actors_director filled with 
    SELECT P.full_name, MC.title FROM cal2.people P                                                                      -- projecting fullname from people & Movies_actor title from table people 
    JOIN cal2.actors A                              ON P.full_name = A.person                                           --- joining with Actor on fullname = Actor person 
    JOIN cal2.movies_actors MC                      ON A.name = MC.actor                                                --- joining with movies_actor on Actor name= Movies_actor Actor 
    UNION                                                                                                               --- UNion or adding to 
    SELECT P.full_name, M.title FROM cal2.people P                                                                      --- projecting fullname from people & movies title from table people 
    JOIN cal2.directors D                           ON P.full_name = D.person                                           --- joing with director as fullname = director person 
    JOIN cal2.movies    M                           ON D.name = M.director                                              --- joining movies on director name = movies directo 
    )
SELECT                                                                                                                  -- projecting title as movies and count rows as Actor_directors 
    title               AS "Movies"
    ,count(*)           AS "Actors & Directors"
    FROM actors_directors                                                                                               -- From the temp table 
    WHERE title = 'The Lord of the Rings: The Return of the King'                                                       -- selecting the title as The Lord of the Rings: The Return of the King
    GROUP BY title;                                                                                                     -- grouped by title. 
/*
People --> p
Actor --> A 
movies_actors --> MC 
movies --> M
T1 <-- π P.full_name, MC.title (Poeple ⋈<sub>P.full_name = A.person<sub> Actors ⋈<sub>A.name = MC.actor<sub> Movies_Actor) ∪ π P.full_name, M.title (People ⋈<sub>P.full_name = D.person<sub> Directors ⋈<sub>D.name = M.director<sub> Movies)
ρ movies, Actor_director (title G count(*) (σ title = The Lord of the Ring: The Return of the King (T1)))
*/

\echo 'Question 5 Show  directors  and  the  movies  they    directed  for  those  people  being also  actors  in  addition to being directors. '


SELECT A.name, M.title FROM cal2.actors A                                                                                -- projecting Actor name and Movies title from actors 
JOIN cal2.directors D ON A.name = D.name                                                                                --- joining with directors on the actors name = directors name 
JOIN cal2.movies M    ON D.name = M.director                                                                            --- joining movies with director name = movies director 
JOIN cal2.people P on A.person = P.full_name and D.person = P.full_name                                                 ---- joining with people on Actor person = fullname and director person = fullname. 
;
/*
actor -> A
directors -> D
movies -> M 
people -> P
π A.name, M.title (Actors ⋈<sub>A.name = D.name<sub> Directors ⋈<sub>D.name = M.director<sub> Movies ⋈<sub>D.person = P.full_name<sub> People )
*/
/*
Solution number 2:

SELECT cal2.actors.person, title, cal2.directors.name
FROM cal2.directors
INNER JOIN cal2.movies ON cal2.directors.name = cal2.movies.director
INNER JOIN cal2.actors ON cal2.directors.person = cal2.actors.person;

*/



\echo '6. Provide the relational expression for all actors born before Dec 31 1980 and also the equivalent SQL expression. Provide also the result from your database.'
\echo '-----------------------------'

/*
π name (σ birthday<'1980-12-31' (actors ⋈ people))

*/

SELECT name
FROM cal2.actors
INNER JOIN cal2.people ON cal2.actors.person = cal2.people.full_name
WHERE birthday < '1980-12-31';

/*Explanation of the query
  This is a SQL query that selects the names of actors from a database table called "actors" in a schema called "cal2,"
  where the actor's birthday is before December 31, 1980. The query uses an inner join to combine the "actors" table
  with a table called "people" in the "cal2" schema, using the full name of each actor to match the records in the two
  tables. The resulting table will only include actors who have a birthday that is before December 31, 1980.
  */

\echo '7. Show the overall number of movies by genre with most popular genres first.'
/*
It is a single expression but we've put it like this for better view
π genre, num_movies (
  γ genre, count(*) as num_movies (
    cal2.movies_genres
  )
  ⨝ genre (
    cal2.movies_genres
  )
)
⨝ num_movies (
  cal2.movies_genres
)

Single Line, same expression:
π genre, num_movies (  γ genre, count(*) as num_movies (    cal2.movies_genres  )  ⨝ genre (    cal2.movies_genres  )) ⨝ num_movies (  cal2.movies_genres)
*/
SELECT genre, COUNT(*) as num_movies
FROM cal2.movies_genres
GROUP BY genre
ORDER BY num_movies DESC
/*Explanation of the query
This is a SQL query that selects the genres of movies from a database table called "movies_genres" in a schema called
  "cal2," and then groups them by genre, counting the number of movies in each group. The resulting table is ordered by
  the number of movies in each genre, with the largest number of movies listed first. The query uses an alias,
  "num_movies," to give the count of movies in each genre a more readable name.
*/


\echo '-----------------------------'
\echo '8. What movies share the same title but have different year? Provide a SQL code for this query, show them in lexicographical order and finally provide the relational algebra expression.'
/*
This is relational algebra for the given query from below
π title, min_year, max_year (
  γ title, min(year) as min_year, max(year) as max_year (
    cal2.movies
  )
  WHERE min_year < max_year
)
⨝ title (
  cal2.movies
)
*/
SELECT title, MIN(year) as min_year, MAX(year) as max_year
FROM cal2.movies
GROUP BY title
HAVING MIN(year) < MAX(year)
ORDER BY title
/*
Explanation of the query
This is a SQL query that selects the titles of movies from a database table called "movies" in a schema called "cal2,"
and then groups them by title. The query then selects the minimum and maximum year of each movie, and only includes
movies that have been released in more than one year. The resulting table is ordered by title, and includes the minimum
and maximum year of each movie that meets the criteria. The query uses aliases, "min_year" and "max_year," to give the
minimum and maximum years for each movie a more readable name.

*/
\echo '-----------------------------'
\echo '9. Provide the relational algebra for the query showing the best ranked movies (by rating). Provide the SQL query as well and finally show the corresponding results.'
/*
The relational algebra for the given query is:

π title, MAX(rating) (σ year=movies.year AND title=movies.title (movies ⋈ reviews))

This expression uses the π (projection) operator to select the title and MAX(rating) columns from the result
of the join between the movies and reviews tables. The join is performed using the ⋈ (natural join) operator, and
is restricted using the σ (selection) operator to only include rows where the year and title columns match in both tables.
The final result is sorted in descending order by the MAX(rating) column.
*/

SELECT cal2.movies.title, MAX(rating) as best_rating
FROM cal2.movies
INNER JOIN cal2.reviews ON cal2.reviews.year = cal2.movies.year AND cal2.reviews.title = cal2.movies.title
GROUP BY cal2.movies.title
ORDER BY best_rating DESC;
 /*
 This is a SQL query that selects the titles of movies from a database table called "movies" in a schema called "cal2,"
 and then finds the maximum rating for each movie. The query uses an inner join to combine the "movies" table with a
 table called "reviews" in the "cal2" schema, using the year and title of each movie to match the records in the two
 tables. The resulting table is ordered by the highest rating for each movie, with the movies having the highest ratings
 listed first. The query uses an alias, "best_rating," to give the maximum rating for each movie a more readable name.
 */

\echo '-----------------------------'
\echo '10. Provide the query to show movies having the same average rating and the results.'
\echo 'This is working now'
/*
π year, title, AVG(rating) (
    σ COUNT(*) > 1 (
        (cal2.reviews ⨝ cal2.reviews) ÷ year, title
    )
)
*/
SELECT year, title, AVG(rating) as avg_rating
FROM cal2.reviews
GROUP BY year, title
HAVING AVG(rating) IN (SELECT AVG(rating)
                       FROM cal2.reviews
                       GROUP BY year, title
                       HAVING COUNT(*) > 1)
;

/*
This SQL query selects the year, title, and average rating of books in a reviews table, grouped by year and title.
It then filters out results that do not have more than one review by using a HAVING clause with a subquery that returns
the average ratings of books that have been reviewed more than once.
*/

rollback;
-- I know some of the checks are not as optimal as they can be so our apologies still finding the way.

