BEGIN;

\echo 'creating schema'
CREATE SCHEMA IF NOT EXISTS CAL2;

\echo 'creating intermediary tables import_*'
CREATE TABLE IF NOT EXISTS CAL2.import_movies
(
    year     TEXT NOT NULL,
    title    TEXT NOT NULL,
    duration TEXT NOT NULL,
    language TEXT NOT NULL,
    rating   TEXT NOT NULL,
    date DATE,
    

    CONSTRAINT movies_pkey PRIMARY KEY (year, title, duration, language, rating)
);



ROLLBACK;