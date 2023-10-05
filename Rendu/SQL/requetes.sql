-- Exercice 3)

--1)
SELECT count(*) FROM information_schema.columns WHERE table_name ='import';

-- 15 

--2)
SELECT COUNT(*) FROM import;

-- 255080

--3)
SELECT COUNT(noc) FROM noc WHERE noc IS NOT null;

-- 230

--4)
SELECT COUNT(DISTINCT(id)) FROM import;

-- 127575

--5)
SELECT COUNT(*) FROM import WHERE medal = 'Gold';

-- 12116

--6)
SELECT COUNT(*) FROM import WHERE name LIKE 'Carl Lewis%';

-- 2


-- Exercice 5)

--1)
SELECT noc, COUNT(*) FROM participations 
GROUP BY noc ORDER BY COUNT(*) DESC;

--2)
SELECT noc, COUNT(*) FROM participations
WHERE medal = 'Gold'
GROUP BY noc ORDER BY COUNT(*) DESC;

--3)
SELECT noc, COUNT(*) FROM participations
WHERE medal IS NOT NULL 
GROUP BY noc ORDER BY COUNT(*) DESC;

--4)
SELECT athlete.id, athlete.name, COUNT(*) FROM athlete, participations 
WHERE athlete.id = participations.id AND medal = 'Gold' 
GROUP BY athlete.id ORDER BY COUNT(*) DESC;

--5)
SELECT noc, COUNT(*) FROM participations, jeux_olympiques 
WHERE medal IS NOT NULL AND participations.jno = jeux_olympiques.jno 
AND city = 'Albertville' GROUP BY noc ORDER BY COUNT(*) DESC;

--6)
SELECT COUNT(*)/2 FROM participations AS p1, participations AS p2 
WHERE p1.id = p2.id AND p1.noc <> p2.noc;

-- 9343

--7)
SELECT COUNT(*)/2 FROM participations AS p1, participations AS p2 
WHERE p1.id = p2.id AND p1.noc <> p2.noc AND p1.noc = 'FRA';

-- 114

--8)
SELECT age, COUNT(*) FROM participations WHERE medal = 'Gold' GROUP BY age;

--9)
SELECT event, COUNT(*) FROM participations, events 
WHERE age >= 50 AND medal IS NOT NULL 
AND participations.eno = events.eno 
GROUP BY event ORDER BY COUNT(*) DESC;

--10)
SELECT season, year, COUNT(DISTINCT event) FROM jeux_olympiques, participations, events 
WHERE jeux_olympiques.jno = participations.jno 
AND events.eno = participations.eno 
GROUP BY season, year ORDER BY year ASC;

--11)
SELECT year, COUNT(*) FROM participations, jeux_olympiques, athlete 
WHERE participations.jno = jeux_olympiques.jno 
AND participations.id = athlete.id AND sex = 'F' 
AND season = 'Summer' 
AND medal IS NOT NULL 
GROUP BY year ORDER BY year ASC;

-- Exercice 6) Pays : France, Sport : Gymnastique

-- 1) Médaillé d'argent ou de bronze français en gymnastique par année avec le nombre de médailles.
SELECT year, athlete.id, athlete.name, COUNT(*) 
FROM participations, jeux_olympiques, athlete, events 
WHERE participations.eno = events.eno 
AND participations.jno = jeux_olympiques.jno 
AND participations.id = athlete.id 
AND (medal = 'Silver' OR medal = 'Bronze') 
AND sport = 'Gymnastics' AND noc = 'FRA'
GROUP BY year, athlete.id, athlete.name ORDER BY COUNT(*) DESC;

--2) Gymnastes français de plus de 30 ans n'ayant jamais remporté de médaille
SELECT DISTINCT athlete.id, athlete.name, age FROM participations, athlete, events 
WHERE participations.id = athlete.id AND medal IS NULL 
AND age > 30 
AND participations.eno = events.eno AND noc = 'FRA' 
AND sport = 'Gymnastics';

-- 3) Nombre de gymnaste français ayant été médaillé

SELECT COUNT(*) FROM participations, events 
WHERE participations.eno = events.eno 
AND sport = 'Gymnastics' AND noc = 'FRA' 
AND medal IS NOT NULL;

-- 4) Moyenne des poids des gymnastes français n'ayant jamais été médaillé par 
-- sexe arrondie à 2 virgule près

SELECT sex, ROUND(AVG(weight),2) FROM participations, athlete, events 
WHERE athlete.id = participations.id AND noc = 'FRA' 
AND events.eno = participations.eno 
AND sport = 'Gymnastics' GROUP By sex;