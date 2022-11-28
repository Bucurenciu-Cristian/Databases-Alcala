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

SELECT count(*) FROM cal2.people;
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

SELECT count(*) FROM cal2.directors;
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

SELECT count(*) FROM cal2.actors;
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
    IM.year :: INTEGER
    ,IM.title
    ,substring(IM.runtime, '\d+') :: INTEGER AS runtime
    ,IM.language
    ,IM.mpa_rating
    ,ID.name
    FROM cal2.import_movies IM
        LEFT JOIN cal2.import_movies_directors IMD ON IM.year = IMD.year AND IM.title = IMD.movie
        LEFT JOIN cal2.import_directors ID         ON ID.name = IMD.name
        ;

SELECT count(*) FROM cal2.movies;
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
    IMA.year :: INTEGER
    ,IMA.title
    ,IMA.name
    FROM cal2.import_movies_actors IMA
        JOIN cal2.actors A ON IMA.name = A.name
        JOIN cal2.movies M ON IMA.title = M.title AND (IMA.year :: INTEGER) = M.year
        ;

SELECT count(*) FROM cal2.movies_actors;
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

SELECT count(*) FROM cal2.movies_genres;
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
    substring(url, '(https://[\/_\.a-z]+\/assets.*)')                                       AS url
    , 'gallery'                                                                             AS type
    FROM cal2.import_movies_medias;


SELECT count(*) FROM cal2.website;
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
    ,substring(webpage, '(https://[\/_\.a-z]+)\/') || replace(lower(author), ' ', '_')                      AS site
    FROM cal2.import_movies_reviews
        JOIN cal2.movies ON import_movies_reviews.year = movies.year AND import_movies_reviews.title = movies.title
        ;

SELECT count(*) FROM cal2.reviews;
ROLLBACK;







