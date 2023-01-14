BEGIN;

-- this is the first part: Audit trigger
CREATE TABLE audit_log (
    id SERIAL PRIMARY KEY,
    table_name TEXT NOT NULL,
    event_type TEXT NOT NULL,
    user_name TEXT NOT NULL,
    event_time TIMESTAMP NOT NULL
);

CREATE OR REPLACE FUNCTION function_audit_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_log (table_name, event_type, user_name, event_time)
    VALUES ('movies', 'insert', current_user, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION function_audit_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_log (table_name, event_type, user_name, event_time)
    VALUES ('movies', 'update', current_user, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION function_audit_delete()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_log (table_name, event_type, user_name, event_time)
    VALUES ('movies', 'delete', current_user, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER audit_insert
AFTER INSERT ON cal2_ddbb2022.movies
FOR EACH ROW
EXECUTE FUNCTION
    function_audit_insert();

CREATE TRIGGER audit_update
AFTER UPDATE ON cal2_ddbb2022.movies
FOR EACH ROW
EXECUTE FUNCTION
    function_audit_update();

CREATE TRIGGER audit_delete
AFTER DELETE ON cal2_ddbb2022.movies
FOR EACH ROW
EXECUTE FUNCTION
    function_audit_delete();

-- this is the second part: Testing the triggers

INSERT INTO movies (year, title, runtime, language)
VALUES (2022, 'Test Movie 1', 120, 'English');


INSERT INTO cal2_ddbb2022.movies (year, title, runtime, language)
VALUES (2022, 'Test Movie 2', 110, 'Spanish');

UPDATE cal2_ddbb2022.movies SET runtime = 130 WHERE year = 2022 AND title = 'Test Movie 1';
DELETE FROM cal2_ddbb2022.movies WHERE year = 2022 AND title = 'Test Movie 2';

-- Until here is audit trigger

-- reviews and websites Trigger

CREATE OR REPLACE FUNCTION check_site() RETURNS TRIGGER AS
$$
BEGIN
    IF NOT EXISTS(SELECT * FROM cal2_ddbb2022.websites WHERE url = NEW.site) THEN
        INSERT INTO cal2_ddbb2022.websites(url, type) VALUES (NEW.site, 'review');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER check_site
    BEFORE INSERT
    ON cal2_ddbb2022.reviews
    FOR EACH ROW
EXECUTE FUNCTION check_site();

-- Average review trigger
CREATE TABLE average_reviews (
    year INTEGER NOT NULL,
    title TEXT NOT NULL,
    average_rating REAL NOT NULL,
    PRIMARY KEY (year, title)
);

-- Testing the trigger
INSERT INTO cal2_ddbb2022.reviews (year, title, rating, author, content, hash, site)
VALUES (2022, 'Test Movie 1', 4.5, 'John Doe', 'Great movie!', '12345', 'https://newwebsite.com');

SELECT * FROM cal2_ddbb2022.websites WHERE url = 'https://newwebsite.com';

INSERT INTO cal2_ddbb2022.reviews (year, title, rating, author, content, hash, site)
VALUES (2022, 'Test Movie 2', 3.5, 'Jane Smith', 'Good movie', '67890', 'https://existingwebsite.com');
SELECT COUNT(*) FROM cal2_ddbb2022.websites WHERE url = 'https://existingwebsite.com';


-- average review trigger
CREATE OR REPLACE FUNCTION update_average_reviews()
RETURNS TRIGGER AS $$
BEGIN
    -- Update the average rating for the film in the "average reviews" table
    UPDATE average_reviews
    SET average_rating = (
        SELECT AVG(rating)
        FROM cal2_ddbb2022.reviews
        WHERE year = NEW.year AND title = NEW.title
    )
    WHERE year = NEW.year AND title = NEW.title;

    -- Insert a new film into the "average reviews" table if it doesn't already exist
    INSERT INTO average_reviews (year, title, average_rating)
    SELECT NEW.year, NEW.title, AVG(rating)
    FROM cal2_ddbb2022.reviews
    WHERE year = NEW.year AND title = NEW.title
    ON CONFLICT (year, title)
    DO UPDATE SET average_rating = (SELECT AVG(rating) FROM cal2_ddbb2022.reviews WHERE year = EXCLUDED.year AND title = EXCLUDED.title);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_average_reviews2
AFTER INSERT ON reviews
FOR EACH ROW
EXECUTE FUNCTION update_average_reviews();



INSERT INTO cal2_ddbb2022.reviews (year, title, rating, author, content, hash, site)
VALUES (2022, 'Test Movie 1', 4.5, 'John Doe', 'Great movie!', '12345', 'https://newwebsite.com');
INSERT INTO cal2_ddbb2022.reviews (year, title, rating, author, content, hash, site)
VALUES (2022, 'Test Movie 2', 3.5, 'Jane Smith', 'Good movie', '67890', 'https://existingwebsite.com');


-- Testing the update_average_reviews trigger
INSERT INTO movies (year, title, runtime, language)
VALUES (2022, 'Film Movies', 120, 'English');

INSERT INTO reviews (year, title, rating, author, content, hash, site)
VALUES (2022, 'Film Movies', 5, 'Cameron', 'Another one', 'hash123', 'tralasite.com');

ROLLBACK;