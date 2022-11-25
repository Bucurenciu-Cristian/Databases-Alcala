
BEGIN;

\echo 'creating schema'

CREATE SCHEMA IF NOT EXISTS cal2;

\echo 'creating interim tables import_*'




CREATE TABLE IF NOT EXISTS cal2.import_actors(
    name                     TEXT    NOT NULL
    ,birthday               TEXT    NOT NULL
    --CONSTRAINS actors_pkey PRIMARY KEY (first_name, last_name, birthday)
);

--ROLLBACK;

CREATE TABLE IF NOT EXISTS cal2.import_movies_actors(
    year                TEXT        NOT NULL
    ,movie              TEXT        NOT NULL
    ,name               TEXT
    --CONSTRAINS actors_movies_pkey PRIMARY KEY (year, movie, first_name, last_name)
);



CREATE TABLE IF NOT EXISTS cal2.import_directors(
    name                TEXT        NOT NULL
    ,birthday           TEXT
    --CONSTRAINS directors_pkey PRIMARY KEY (first_name, last_name, birthday)
);



CREATE TABLE IF NOT EXISTS cal2.import_movies_reviews(
    year                TEXT        NOT NULL
    ,title              TEXT        NOT NULL
    ,rating             REAL
    ,author             TEXT
    ,content            TEXT
    ,hash               TEXT
    ,webpage            TEXT
    --CONSTRAINS movies_reviews_pkey PRIMARY KEY (????)
);



CREATE TABLE IF NOT EXISTS cal2.import_movies_directors(
    movie               TEXT        NOT NULL
    ,year               TEXT        NOT NULL
    ,name               TEXT
    --CONSTRAINS movies_directors_pkey PRIMARY KEY(??)
);



CREATE TABLE IF NOT EXISTS cal2.import_movies(
    year                TEXT
    ,title              TEXT
    ,genres             TEXT
    ,rating             TEXT
    ,runtime            TEXT
    ,language           TEXT
    ,mpa_rating         TEXT
    --CONSTRAINS movies_pkey PRIMARY KEY (??)
);



CREATE TABLE IF NOT EXISTS cal2.import_movies_medias(
    year                TEXT
    ,title              TEXT
    ,types              TEXT
    ,urls               TEXT
    ,size               TEXT
    --CONSTRAINS movies_medias_pkey PRIMARY KEY (??)
);


\echo 'Bulk loading data into import_* tables'

\COPY cal2.import_actors                                FROM 'actors(1).csv'                           WITH (FORMAT csv, HEADER, DELIMITER E'\t', NULL 'NULL', ENCODING 'UTF-8');
\COPY cal2.import_movies_actors                         FROM 'actors_movies(1).csv'                    WITH (FORMAT csv, HEADER, DELIMITER E'\t', NULL 'NULL', ENCODING 'UTF-8');
\COPY cal2.import_directors                             FROM 'directors(1).csv'                        WITH (FORMAT csv, HEADER, DELIMITER E'\t', NULL 'NULL', ENCODING 'UTF-8');
\COPY cal2.import_movies_reviews                        FROM 'movies_review(1).csv'                    WITH (FORMAT csv, HEADER, DELIMITER E'\t', NULL 'NULL', ENCODING 'UTF-8');
\COPY cal2.import_movies_directors                      FROM 'movies_directors(1).csv'                 WITH (FORMAT csv, HEADER, DELIMITER E'\t', NULL 'NULL', ENCODING 'UTF-8');
\COPY cal2.import_movies                                FROM 'std_movies(1).csv'                       WITH (FORMAT csv, HEADER, DELIMITER E'\t', NULL 'NULL', ENCODING 'UTF-8');
\COPY cal2.import_movies_medias                         FROM 'movies_medias(1).csv'                    WITH (FORMAT csv, HEADER, DELIMITER E'\t', NULL 'NULL', ENCODING 'UTF-8');



ROLLBACK;

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

\echo 'create & populate genres'
CREATE TABLE IF NOT EXISTS cal2.movies_genres(
    year                TEXT            NOT NULL
    ,title              TEXT            NOT NULL
    ,genre              TEXT            NOT NULL
    ,CONSTRAINT movies_genres_pk PRIMARY KEY (year, title, genre)
    ,CONSTRAINT movies_genres_movies_fk FOREIGN KEY (year, title) 
        REFERENCES cal2.movies (year, title)
        MATHC FULL ON DELETE RESTRICT ON UPDATE CASCADE
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

\echo 'create & populate website from media & review'
CREATE TABLE IF NOT EXISTS cal2.website (
    url                 TEXT        NOT NULL
    ,type               TEXT        NOT NULL
    ,CONSTRAINT website_pk PRIMARY KEY (url)
);

INSERT INTO cal2.website(url, type)
SELECT
    DISTINCT
    substring(webpage, '(https://[\/_\.a-z]+)\/' || replace(lower(author), ' ', '_'))      AS url
    , 'forum'                                                                              AS type
    FROM cal2.improt_movies_reviews
UNION ALL
SELECT
    DISTINCT
    substring(url, '(https://[\/_\.a-z]+\/assets)')                                        AS url
    , 'gallery'                                                                            AS type
    FROM cal2.import_movies_medias;

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


ROLLBACK;



