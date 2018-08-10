--Find all carriers who cancelled more than 1 flights during 2007, order them from biggest to lowest by number of cancelled flights and list in each record all departure cities where cancellation happened. 

USE ${db};
set hive.auto.convert.join = true;

SELECT /*+ MAPJOIN(airport) */
	f.uniquecarrier as carrier, count(1) as cancelled_flights, collect_set(a.city) as cities
	FROM (SELECT uniquecarrier, origin FROM flight WHERE cancelled=1) AS f
	JOIN airport AS a
	ON (f.origin=a.code)
	GROUP BY f.uniquecarrier
	HAVING cancelled_flights > 1
	ORDER BY cancelled_flights DESC;