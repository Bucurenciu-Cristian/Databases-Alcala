BEGIN;

-- Administrator user
CREATE USER administrator WITH PASSWORD 'password';
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA cal2_ddbb2022 TO administrator;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA cal2_ddbb2022 TO administrator;


-- Administrator can create new tables
CREATE TABLE cal2_ddbb2022.reviews (review_id SERIAL PRIMARY KEY, movie_title TEXT, review_text TEXT);

-- Administrator can insert data into tables
INSERT INTO cal2_ddbb2022.people (full_name, country, birthdate) VALUES ('John Smith', 'USA', '1980-01-01');

-- Administrator can update data in tables
UPDATE cal2_ddbb2022.people SET country = 'Canada' WHERE full_name = 'John Smith';

-- Administrator can delete data from tables
DELETE FROM cal2_ddbb2022.people WHERE full_name = 'John Smith';
-- Manager user
CREATE USER manager WITH PASSWORD 'password';
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA cal2_ddbb2022 TO manager;



-- Manager can insert data into tables
INSERT INTO cal2_ddbb2022.people (full_name, country, birthdate) VALUES ('Jane Doe', 'USA', '1990-01-01');

-- Manager can update data in tables
UPDATE cal2_ddbb2022.people SET country = 'Mexico' WHERE full_name = 'Jane Doe';

-- Manager can delete data from tables
DELETE FROM cal2_ddbb2022.people WHERE full_name = 'Jane Doe';

-- Manager can select data from tables
SELECT full_name, country, birthdate FROM cal2_ddbb2022.people;




-- Critic user
CREATE USER critic WITH PASSWORD 'password';
GRANT SELECT ON ALL TABLES IN SCHEMA cal2_ddbb2022 TO critic;
GRANT INSERT ON TABLE cal2_ddbb2022.reviews TO critic;

-- Critic can insert data into the reviews table
INSERT INTO cal2_ddbb2022.reviews (movie_title, review_text) VALUES ('The Shawshank Redemption', 'A must-watch classic!');

-- Critic can select data from tables
SELECT * FROM cal2_ddbb2022.people;

-- Critic can't update data in tables
-- Error message: permission denied for table people
UPDATE cal2_ddbb2022.people SET country = 'Argentina' WHERE full_name = 'Jane Doe';

-- Critic can't delete data from tables
-- Error message: permission denied for table people
DELETE FROM cal2_ddbb2022.people WHERE full_name = 'Jane Doe';





-- Customer user
CREATE USER customer WITH PASSWORD 'password';
GRANT SELECT ON ALL TABLES IN SCHEMA cal2_ddbb2022 TO customer;

-- Customer can select data from tables
SELECT * FROM cal2_ddbb2022.people;

-- Customer can't insert data into tables
-- Error message: permission denied for table people
INSERT INTO cal2_ddbb2022.people (full_name, country, birthdate) VALUES ('Bob Ross', 'USA', '1942-01-01');

-- Customer can't update data in tables
-- Error message: permission denied for table people
UPDATE cal2_ddbb2022.people SET country = 'Brazil' WHERE full_name = 'Bob Ross';

-- Customer can't delete data from tables
-- Error message: permission denied for table people
DELETE FROM cal2_ddbb2022.people WHERE full_name = 'Bob Ross';

ROLLBACK;
