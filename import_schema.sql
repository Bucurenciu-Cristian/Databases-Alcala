BEGIN;

\echo 'creating schema'

CREATE SCHEMA IF NOT EXISTS cal2;

\echo 'creating interim tables improt_*'




CREATE TABLE IF NOT EXISTS cal2.import_actors(
    first_name              TEXT    NOT NULL
    ,last_name              TEXT    NOT NULL
    ,birthday               TEXT    NOT NULL
    --CONSTRAINS actors_pkey PRIMARY KEY (first_name, last_name, birthday)
);

--ROLLBACK;

CREATE TABLE IF NOT EXISTS cal2.improt_actors_movies(
    year                TEXT
    ,movie              TEXT
    ,first_name         TEXT
    ,last_name          TEXT
    --CONSTRAINS actors_movies_pkey PRIMARY KEY (year, movie, first_name, last_name)
);



CREATE TABLE IF NOT EXISTS cal2.improt_directors(
    first_name          TEXT
    ,last_name          TEXT
    ,birthday           TEXT
    --CONSTRAINS directors_pkey PRIMARY KEY (first_name, last_name, birthday)
);



CREATE TABLE IF NOT EXISTS cal2.improt_movies_reviews(
    year                TEXT
    ,title              TEXT
    ,rating             TEXT
    ,author             TEXT
    ,content            TEXT
    ,hashes             TEXT
    ,webpage            TEXT
    --CONSTRAINS movies_reviews_pkey PRIMARY KEY (????)
);



CREATE TABLE IF NOT EXISTS cal2.improt_movies_directors(
    title               TEXT
    ,year               TEXT
    ,first_name         TEXT
    ,last_name          TEXT
    --CONSTRAINS movies_directors_pkey PRIMARY KEY(??)
);



CREATE TABLE IF NOT EXISTS cal2.import_movies(
    year                TEXT
    ,title              TEXT
    ,genres             TEXT
    ,rating             TEXT
    ,runtime            TEXT
    ,languages          TEXT
    ,mpa_rating         TEXT
    --CONSTRAINS movies_pkey PRIMARY KEY (??)
);



CREATE TABLE IF NOT EXISTS cal2.improt_movies_medias(
    year                TEXT
    ,title              TEXT
    ,types              TEXT
    ,urls               TEXT
    ,size               TEXT
    --CONSTRAINS movies_medias_pkey PRIMARY KEY (??)
);


\echo 'Bulk loading data into import_* tables'

\COPY cal2.import_actors                                FROM 'actors(1).csv'                           WITH (FORMAT csv, HEADER, DELIMITER E'\t', NULL 'NULL', ENCODING 'UTF-8');
\COPY cal2.improt_actors_movies                         FROM 'actors_movies(1).csv'                    WITH (FORMAT csv, HEADER, DELIMITER E'\t', NULL 'NULL', ENCODING 'UTF-8');
\COPY cal2.improt_directors                             FROM 'directors(1).csv'                        WITH (FORMAT csv, HEADER, DELIMITER E'\t', NULL 'NULL', ENCODING 'UTF-8');
\COPY cal2.improt_movies_reviews                        FROM 'movies_review(1).csv'                    WITH (FORMAT csv, HEADER, DELIMITER E'\t', NULL 'NULL', ENCODING 'UTF-8');
\COPY cal2.improt_movies_directors                      FROM 'movies_directors(1).csv'                 WITH (FORMAT csv, HEADER, DELIMITER E'\t', NULL 'NULL', ENCODING 'UTF-8');
\COPY cal2.import_movies                                FROM 'std_movies(1).csv'                       WITH (FORMAT csv, HEADER, DELIMITER E'\t', NULL 'NULL', ENCODING 'UTF-8');
\COPY cal2.improt_movies_medias                         FROM 'movies_medias(1).csv'                    WITH (FORMAT csv, HEADER, DELIMITER E'\t', NULL 'NULL', ENCODING 'UTF-8');



ROLLBACK;