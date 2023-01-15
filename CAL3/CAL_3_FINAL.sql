BEGIN;


\echo 'creating schema'

CREATE SCHEMA IF NOT EXISTS cal2;

\echo 'creating interim tables import_*'


-- here we are creating tables for the data we have in csv file using the headers and column/ attribute and simple text as we just one to bring data from csv file to tables so then we can modify and transffer and do relations.

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

CREATE TABLE IF NOT EXISTS cal2.people(                                         -- creating table poeple if there is no such table made before
    full_name       TEXT        NOT NULL                                        --- full name is string/ text andn cant be null as it will be the primary key.
    ,coutry         TEXT
    ,birthday       DATE
    ,CONSTRAINT people_pk PRIMARY KEY (full_name)
);

INSERT INTO cal2.people (full_name, coutry, birthday)                       --- inserting to this table from both table of actor and director
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
CREATE TABLE IF NOT EXISTS cal2.directors(                                                                  --- creating a table directors with foreng key to table peole and primary key of name
    name                TEXT           NOT NULL
    ,person             TEXT           NOT NULL
    ,CONSTRAINT directors_pk PRIMARY KEY (name)
    ,CONSTRAINT directors_people_fk FOREIGN KEY (person)
        REFERENCES cal2.people(full_name) MATCH FULL ON DELETE RESTRICT ON UPDATE CASCADE
);

INSERT INTO cal2.directors(name, person) ----populating the table.
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
CREATE TABLE IF NOT EXISTS cal2.actors(                     -- same thing as mentioned witn directors with actors
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
CREATE TABLE IF NOT EXISTS cal2.movies(                             --- creating table movies with primary keys of title and year and foriegn key of director related to primary key of table directos.
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
\echo '---------------------------------------------------------------'
\echo '-----------------------CAL3 Start---------------------------------'


-- this is the first part: Audit trigger
CREATE TABLE IF NOT EXISTS cal2.audit_log
(
    id         SERIAL PRIMARY KEY,
    table_name TEXT      NOT NULL,
    event_type TEXT      NOT NULL,
    user_name  TEXT      NOT NULL,
    event_time TIMESTAMP NOT NULL
);

CREATE OR REPLACE FUNCTION function_audit_insert()
    RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO cal2.audit_log (table_name, event_type, user_name, event_time)
    VALUES ('movies', 'insert', current_user, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION function_audit_update()
    RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO cal2.audit_log (table_name, event_type, user_name, event_time)
    VALUES ('movies', 'update', current_user, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION function_audit_delete()
    RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO cal2.audit_log (table_name, event_type, user_name, event_time)
    VALUES ('movies', 'delete', current_user, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER audit_insert
    AFTER INSERT
    ON cal2.movies
    FOR EACH ROW
EXECUTE FUNCTION
    function_audit_insert();

CREATE TRIGGER audit_update
    AFTER UPDATE
    ON cal2.movies
    FOR EACH ROW
EXECUTE FUNCTION
    function_audit_update();

CREATE TRIGGER audit_delete
    AFTER DELETE
    ON cal2.movies
    FOR EACH ROW
EXECUTE FUNCTION
    function_audit_delete();

-- this is the end of first  part: Audit trigger

INSERT INTO cal2.movies(year, title, runtime, language, mpa_rating, director) --- populatig the table using the imported table joining with table directors.
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
CREATE TABLE IF NOT EXISTS cal2.movies_actors(                                  --- movies_actor is a table to show whihc actors acted in whihc movies showing the many to many relation.
    year                INTEGER         NOT NULL                                --- title and year will be foregn key from table movies
    ,title              TEXT            NOT NULL
    ,actor              TEXT            NOT NULL                                --- actors is a foriegn key of table actor
    ,CONSTRAINT movies_actors_movies_fk FOREIGN KEY (year, title) REFERENCES cal2.movies (year, title)
        MATCH FULL ON DELETE RESTRICT ON UPDATE CASCADE
    ,CONSTRAINT movies_actors_actors_fk FOREIGN KEY (actor) REFERENCES cal2.actors (name)
        MATCH FULL ON DELETE RESTRICT ON UPDATE CASCADE
);

INSERT INTO cal2.movies_actors(year, title, actor) --- populating the table using the foriegn keys of two other table.
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
CREATE TABLE IF NOT EXISTS cal2.movies_genres(    --- creatingn table genre for explicit genre using the attribute as foriegn keys of the table moives year and title
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
    ,regexp_split_to_table(import_movies.genres, '\s+')  AS genre ----seperating the genres using regex.
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
    substring(webpage, '(https://[\/_\.a-z]+)\/' || replace(lower(author), ' ', '_'))     AS url     --- the url get regexed(icluding letters . and /) and authors will be replaced in the end.
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
CREATE TABLE IF NOT EXISTS cal2.reviews (    --- creating a table reviews using url as foriegn key and title and year also forieng keys from movies but together with author becomes the primary key.
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

-- reviews and website Trigger
\echo 'reviews and website Trigger'

CREATE OR REPLACE FUNCTION check_site() RETURNS TRIGGER AS
$$
BEGIN
    IF NOT EXISTS(SELECT * FROM cal2.website WHERE url = NEW.site) THEN
        INSERT INTO cal2.website(url, type) VALUES (NEW.site, 'review');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--It is working, I've tested it at the end of the script
CREATE TRIGGER check_site
    BEFORE INSERT
    ON cal2.reviews
    FOR EACH ROW
EXECUTE FUNCTION check_site();


-- Average review trigger
CREATE TABLE IF NOT EXISTS cal2.average_reviews
(
    year           INTEGER NOT NULL,
    title          TEXT    NOT NULL,
    average_rating REAL    NOT NULL,
    PRIMARY KEY (year, title)
);
CREATE OR REPLACE FUNCTION update_average_reviews()
    RETURNS TRIGGER AS
$$
BEGIN
    -- Update the average rating for the film in the "average reviews" table
    UPDATE cal2.average_reviews
    SET average_rating = (SELECT AVG(rating)
                          FROM cal2.reviews
                          WHERE year = NEW.year
                            AND title = NEW.title)
    WHERE year = NEW.year
      AND title = NEW.title;

    -- Insert a new film into the "average reviews" table if it doesn't already exist
    INSERT INTO cal2.average_reviews (year, title, average_rating)
    SELECT NEW.year, NEW.title, AVG(rating)
    FROM cal2.reviews
    WHERE year = NEW.year
      AND title = NEW.title
    ON CONFLICT (year, title)
        DO UPDATE SET average_rating = (SELECT AVG(rating)
                                        FROM cal2.reviews
                                        WHERE year = EXCLUDED.year AND title = EXCLUDED.title);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_average_reviews
    AFTER INSERT
    ON cal2.reviews
    FOR EACH ROW
EXECUTE FUNCTION update_average_reviews();
\echo '---------------------------------------------------------------'

INSERT INTO cal2.movies (year, title, runtime, language, mpa_rating)
VALUES (2022, 'Movie A', 120, 'English', 'PG-13');
INSERT INTO cal2.reviews (year, title, rating, author, content, hash, site) VALUES (2022, 'Movie A', 5, 'Author B', 'Great movie!', '12345', 'www.wsite.com');
SELECT AVG(rating) FROM cal2.reviews WHERE year = 2022 AND title = 'Movie A';
INSERT INTO cal2.reviews (year, title, rating, author, content, hash, site) VALUES (2022, 'Movie A', 4, 'Author A', 'Great movie!', '12345', 'www.wsite.com');
SELECT AVG(rating) FROM cal2.reviews WHERE year = 2022 AND title = 'Movie A';

\echo 'Check This ---------------------------------------------------------------'

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

\echo '---------------------------------------------------------------'

SELECT count(*) FROM cal2.reviews;
\echo 'Percentage of NULL value in each column (Primary key included == 0.00%)'
SELECT 100.0 * SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS yearpercent, 100.0 * SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS titlepercent, 100.0 * SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS ratingpercent, 100.0 * SUM(CASE WHEN author IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS authorpercent, 100.0 * SUM(CASE WHEN content IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS contentpercent, 100.0 * SUM(CASE WHEN hash IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS hashpercent, 100.0 * SUM(CASE WHEN site IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS sitepercent FROM cal2.reviews;
\echo 'number of rows in the import_movies_reviews'
SELECT count(*) FROM cal2.import_movies_reviews;
--\echo 'number of rows in the import_directors'
--SELECT count(*) FROM cal2.import_directors;
\echo 'all the data has been transformed and nothing is missinng as it is join and number of rows are equal further more there is no NULL value therefore all the PK and FK are valid too'



-- USER PART CAL 3
-- Administrator user
DO
$do$
BEGIN
   IF EXISTS (
      SELECT FROM pg_catalog.pg_roles
      WHERE  rolname = 'administrator') THEN

      RAISE NOTICE 'Role "administrator" already exists. Skipping.';
   ELSE
      BEGIN   -- nested block
         CREATE ROLE administrator LOGIN PASSWORD 'password';
      EXCEPTION
         WHEN duplicate_object THEN
            RAISE NOTICE 'Role "administrator" was just created by a concurrent transaction. Skipping.';
      END;
   END IF;
END
$do$;


GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA cal2 TO administrator;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA cal2 TO administrator;


-- Administrator can create new tables
-- CREATE TABLE cal2.reviews (review_id SERIAL PRIMARY KEY, movie_title TEXT, review_text TEXT);

-- Administrator can insert data into tables
-- INSERT INTO cal2.people (full_name, coutry, birthday) VALUES ('John Smith', 'USA', '1980-01-01');

-- Administrator can update data in tables
-- UPDATE cal2.people SET coutry = 'Canada' WHERE full_name = 'John Smith';

-- Administrator can delete data from tables
-- DELETE FROM cal2.people WHERE full_name = 'John Smith';
-- Manager user
DO
$do$
BEGIN
   IF EXISTS (
      SELECT FROM pg_catalog.pg_roles
      WHERE  rolname = 'manager') THEN

      RAISE NOTICE 'Role "manager" already exists. Skipping.';
   ELSE
      BEGIN   -- nested block
         CREATE ROLE manager LOGIN PASSWORD 'password';
      EXCEPTION
         WHEN duplicate_object THEN
            RAISE NOTICE 'Role "manager" was just created by a concurrent transaction. Skipping.';
      END;
   END IF;
END
$do$;


GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA cal2 TO manager;



-- Manager can insert data into tables
INSERT INTO cal2.people (full_name, coutry, birthday) VALUES ('Jane Doe', 'USA', '1990-01-01');

-- Manager can update data in tables
UPDATE cal2.people SET coutry = 'Mexico' WHERE full_name = 'Jane Doe';

-- Manager can delete data from tables
DELETE FROM cal2.people WHERE full_name = 'Jane Doe';

-- Manager can select data from tables
SELECT full_name, coutry, birthday FROM cal2.people;




-- Critic user
DO
$do$
BEGIN
   IF EXISTS (
      SELECT FROM pg_catalog.pg_roles
      WHERE  rolname = 'Critic') THEN

      RAISE NOTICE 'Role "Critic" already exists. Skipping.';
   ELSE
      BEGIN   -- nested block
         CREATE ROLE Critic LOGIN PASSWORD 'password';
      EXCEPTION
         WHEN duplicate_object THEN
            RAISE NOTICE 'Role "Critic" was just created by a concurrent transaction. Skipping.';
      END;
   END IF;
END
$do$;
GRANT SELECT ON ALL TABLES IN SCHEMA cal2 TO critic;
GRANT INSERT ON TABLE cal2.reviews TO critic;

-- Critic can insert data into the reviews table
-- INSERT INTO cal2.reviews (title, content) VALUES ('The Shawshank Redemption', 'A must-watch classic!');

-- Critic can select data from tables
-- SELECT * FROM cal2.people;

-- Critic can't update data in tables
-- Error message: permission denied for table people
-- UPDATE cal2.people SET coutry = 'Argentina' WHERE full_name = 'Jane Doe';

-- Critic can't delete data from tables
-- Error message: permission denied for table people
-- DELETE FROM cal2.people WHERE full_name = 'Jane Doe';

-- Customer user

DO
$do$
BEGIN
   IF EXISTS (
      SELECT FROM pg_catalog.pg_roles
      WHERE  rolname = 'Customer') THEN

      RAISE NOTICE 'Role "Customer" already exists. Skipping.';
   ELSE
      BEGIN   -- nested block
         CREATE ROLE Customer LOGIN PASSWORD 'password';
      EXCEPTION
         WHEN duplicate_object THEN
            RAISE NOTICE 'Role "Customer" was just created by a concurrent transaction. Skipping.';
      END;
   END IF;
END
$do$;

GRANT SELECT ON ALL TABLES IN SCHEMA cal2 TO customer;

-- Customer can select data from tables
-- SELECT * FROM cal2.people;

-- Customer can't insert data into tables
-- Error message: permission denied for table people
-- INSERT INTO cal2.people (full_name, coutry, birthday) VALUES ('Bob Ross', 'USA', '1942-01-01');

-- Customer can't update data in tables
-- Error message: permission denied for table people
-- UPDATE cal2.people SET coutry = 'Brazil' WHERE full_name = 'Bob Ross';

-- Customer can't delete data from tables
-- Error message: permission denied for table people
-- DELETE FROM cal2.people WHERE full_name = 'Bob Ross';




/* Triggers Part */
/*-- this is the first part: Audit trigger
CREATE TABLE IF NOT EXISTS cal2.audit_log
(
    id         SERIAL PRIMARY KEY,
    table_name TEXT      NOT NULL,
    event_type TEXT      NOT NULL,
    user_name  TEXT      NOT NULL,
    event_time TIMESTAMP NOT NULL
);

CREATE OR REPLACE FUNCTION function_audit_insert()
    RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO cal2.audit_log (table_name, event_type, user_name, event_time)
    VALUES ('movies', 'insert', current_user, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION function_audit_update()
    RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO cal2.audit_log (table_name, event_type, user_name, event_time)
    VALUES ('movies', 'update', current_user, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION function_audit_delete()
    RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO cal2.audit_log (table_name, event_type, user_name, event_time)
    VALUES ('movies', 'delete', current_user, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER audit_insert
    AFTER INSERT
    ON cal2.movies
    FOR EACH ROW
EXECUTE FUNCTION
    function_audit_insert();

CREATE TRIGGER audit_update
    AFTER UPDATE
    ON cal2.movies
    FOR EACH ROW
EXECUTE FUNCTION
    function_audit_update();

CREATE TRIGGER audit_delete
    AFTER DELETE
    ON cal2.movies
    FOR EACH ROW
EXECUTE FUNCTION
    function_audit_delete();

-- this is the end of first  part: Audit trigger*/
-- this is the second part: Testing the triggers
/*
INSERT INTO movies (year, title, runtime, language)
VALUES (2022, 'Test Movie 1', 120, 'English');


INSERT INTO cal2.movies (year, title, runtime, language)
VALUES (2022, 'Test Movie 2', 110, 'Spanish');

UPDATE cal2.movies SET runtime = 130 WHERE year = 2022 AND title = 'Test Movie 1';
DELETE FROM cal2.movies WHERE year = 2022 AND title = 'Test Movie 2';
*/
-- Until here is audit trigger

/*-- reviews and website Trigger

CREATE OR REPLACE FUNCTION check_site() RETURNS TRIGGER AS
$$
BEGIN
    IF NOT EXISTS(SELECT * FROM cal2.website WHERE url = NEW.site) THEN
        INSERT INTO cal2.website(url, type) VALUES (NEW.site, 'review');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER check_site
    BEFORE INSERT
    ON cal2.reviews
    FOR EACH ROW
EXECUTE FUNCTION check_site();*/
/*
-- Average review trigger
CREATE TABLE IF NOT EXISTS cal2.average_reviews
(
    year           INTEGER NOT NULL,
    title          TEXT    NOT NULL,
    average_rating REAL    NOT NULL,
    PRIMARY KEY (year, title)
);
-- Testing the trigger
*/
/*
This is just for testing the trigger website from reviews

 */
INSERT INTO cal2.movies (year, title, runtime, language)
VALUES (2022, 'Test Movie 1', 120, 'English');
INSERT INTO cal2.movies (year, title, runtime, language)
VALUES (2022, 'Test Movie 2', 110, 'Spanish');

INSERT INTO cal2.reviews (year, title, rating, author, content, hash, site)
VALUES (2022, 'Test Movie 1', 4.5, 'John Doe', 'Great movie!', '12345', 'https://newwebsite.com');

-- SELECT * FROM cal2.website WHERE url = 'https://newwebsite.com';

INSERT INTO cal2.reviews (year, title, rating, author, content, hash, site)
VALUES (2022, 'Test Movie 2', 3.5, 'Jane Smith', 'Good movie', '67890', 'https://existingwebsite.com');
-- SELECT COUNT(*) FROM cal2.website WHERE url = 'https://newwebsite.com';

/*-- average review trigger
CREATE OR REPLACE FUNCTION update_average_reviews()
    RETURNS TRIGGER AS
$$
BEGIN
    -- Update the average rating for the film in the "average reviews" table
    UPDATE cal2.average_reviews
    SET average_rating = (SELECT AVG(rating)
                          FROM cal2.reviews
                          WHERE year = NEW.year
                            AND title = NEW.title)
    WHERE year = NEW.year
      AND title = NEW.title;

    -- Insert a new film into the "average reviews" table if it doesn't already exist
    INSERT INTO average_reviews (year, title, average_rating)
    SELECT NEW.year, NEW.title, AVG(rating)
    FROM cal2.reviews
    WHERE year = NEW.year
      AND title = NEW.title
    ON CONFLICT (year, title)
        DO UPDATE SET average_rating = (SELECT AVG(rating)
                                        FROM cal2.reviews
                                        WHERE year = EXCLUDED.year AND title = EXCLUDED.title);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_average_reviews2
    AFTER INSERT
    ON cal2.reviews
    FOR EACH ROW
EXECUTE FUNCTION update_average_reviews();
*/


/*INSERT INTO cal2.reviews (year, title, rating, author, content, hash, site)
VALUES (2022, 'Test Movie 1', 4.5, 'John Doe', 'Great movie!', '12345', 'https://newwebsite.com');
INSERT INTO cal2.reviews (year, title, rating, author, content, hash, site)
VALUES (2022, 'Test Movie 2', 3.5, 'Jane Smith', 'Good movie', '67890', 'https://existingwebsite.com');
*/
/*
-- Testing the update_average_reviews trigger
INSERT INTO movies (year, title, runtime, language)
VALUES (2022, 'Film Movies', 120, 'English');

INSERT INTO reviews (year, title, rating, author, content, hash, site)
VALUES (2022, 'Film Movies', 5, 'Cameron', 'Another one', 'hash123', 'tralasite.com');
*/


-- ROLLBACK;
COMMIT;