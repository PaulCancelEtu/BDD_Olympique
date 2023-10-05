DROP TABLE import, noc, athlete, teams, jeux_olympiques, events, participations CASCADE;

CREATE TEMP TABLE import(id text, name text, sex char(1), age int,
height int, weight float, team text, noc char(3), games text, year int,
season char(6) , city text, sport text, event text, medal text);


\copy import FROM ../data-olympique/athlete_events.csv WITH DELIMITER ',' HEADER csv null AS 'NA';

DELETE FROM import WHERE sport = 'Art Competitions' OR year<1920;

CREATE TEMP TABLE noc (noc CHAR(3), region text, notes text);

\copy noc FROM ../data-olympique/noc_regions.csv WITH DELIMITER ',' HEADER csv null AS '';

UPDATE noc
SET noc = REPLACE(noc, 'SIN', 'SGP')
WHERE noc = 'SIN';


CREATE TABLE athlete(id text, name text, sex char(1),
CONSTRAINT pk_athlete PRIMARY KEY (id));

CREATE TABLE teams(team text, noc text,
CONSTRAINT pk_teams PRIMARY KEY (noc));

CREATE TABLE jeux_olympiques(jno serial, games text, year int, season text, city text,
CONSTRAINT pk_jo PRIMARY KEY (jno));

CREATE TABLE events(eno serial, sport text, event text,
CONSTRAINT pk_events PRIMARY KEY (eno));

INSERT INTO athlete(id, name, sex)
SELECT DISTINCT id, name, sex FROM import;

INSERT INTO teams(team, noc)
SELECT DISTINCT region, noc FROM noc;

INSERT INTO events(sport, event)
SELECT DISTINCT sport, event FROM import;

INSERT INTO jeux_olympiques(games, year, season, city)
SELECT DISTINCT import.games, import.year, import.season, import.city FROM import;

CREATE TABLE participations(id text, eno serial,jno serial, noc CHAR(3), medal text, age int, height int, weight int,
CONSTRAINT fk_id FOREIGN KEY (id) REFERENCES athlete(id),
CONSTRAINT fk_eno FOREIGN KEY (eno) REFERENCES events(eno),
CONSTRAINT fk_jno FOREIGN KEY (jno) REFERENCES jeux_olympiques(jno),
CONSTRAINT fk_noc FOREIGN KEY (noc) REFERENCES teams(noc));

INSERT INTO participations (id, age, height, weight, medal,noc, jno, eno)
SELECT i.id, i.age, i.height, i.weight, medal, i.noc, j.jno, e.eno
FROM import AS i JOIN jeux_olympiques AS j
ON i.games = j.games AND i.year = j.year AND i.season = j.season AND i.city = j.city
JOIN events e ON i.sport = e.sport AND i.event = e.event;


\copy participations TO '../tables/participations.csv' WITH DELIMITER ';' CSV HEADER

\copy athlete TO '../tables/athlete.csv' WITH DELIMITER ';' CSV HEADER

\copy teams TO '../tables/teams.csv' WITH DELIMITER ';' CSV HEADER

\copy jeux_olympiques TO '../tables/jeux_olympiques.csv' WITH DELIMITER ';' CSV HEADER

\copy events TO '../tables/events.csv' WITH DELIMITER ';' CSV HEADER
