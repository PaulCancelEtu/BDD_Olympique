CREATE TEMP TABLE rempl(country text, year int , participant int , medaille int , f int , propf int , proph int , propmf int , propfm int );

INSERT INTO rempl(country, year, participant, medaille, f,  propf,  proph,  propmf,  propfm)
SELECT team, year,
    	count(id) as "participants",
    	count(case WHEN medal IS NOT NULL THEN age ELSE null end) as "nb médaillés",
    	count(case WHEN sex = 'F' THEN sex ELSE null end) as "Du nombre de femmes participantes",
    	(count(case WHEN sex = 'F' THEN sex ELSE null end) * 100 / count(id)) as "proportion de femmes",
    	(count(case WHEN sex = 'M' THEN sex ELSE null end) * 100 / count(id)) as "proportion d'hommes",
        (count(case WHEN sex = 'F' AND MEDAL IS NOT NULL THEN sex ELSE null end) * 100 / count(case WHEN sex = 'F' THEN sex ELSE null end)) as "proportion de m f",
        (count(case WHEN sex = 'F' AND MEDAL IS NOT NULL THEN sex ELSE null end) * 100 / count(id)) as "f parmi les médaillés"

FROM participations natural join teams natural join jeux_olympiques natural join athlete

WHERE team = 'USA'
OR team = 'Russia'
OR team = 'Germany'
OR team = 'France'
OR team = 'China'

GROUP BY team, year
ORDER BY year DESC;
