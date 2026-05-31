-- Определить, какие классы автомобилей имеют наибольшее количество автомобилей с низкой средней позицией (больше 3.0) 
-- и вывести информацию о каждом автомобиле из этих классов, 
-- включая его имя, класс, среднюю позицию, количество гонок, в которых он участвовал, 
-- страну производства класса автомобиля, а также общее количество гонок для каждого класса. 
-- Отсортировать результаты по количеству автомобилей с низкой средней позицией.

-- РЕШЕНИЕ СТРОГО ПО УСЛОВИЮ:

SELECT Cars.name AS car_name, Cars.class AS car_class, AVG(position) AS average_position, 
COUNT(*) AS race_count, Classes.country AS car_country, 
total_races, low_position_count FROM Cars
JOIN Classes ON Classes.class = Cars.class
JOIN Results ON Results.car = Cars.name
JOIN
(
	SELECT * FROM
	(
		SELECT car_class AS needed_class, COUNT(*) AS low_position_count FROM
		(
			SELECT Cars.name, Cars.class AS car_class, AVG(position) AS average_position FROM Cars
			JOIN Results ON Results.car = Cars.name
			GROUP BY Cars.name
		)
		WHERE average_position > 3.0
		GROUP BY needed_class
	)
	WHERE low_position_count = 
	(
		SELECT MAX(low_position_count) FROM 
		(
			SELECT car_class AS needed_class, COUNT(*) AS low_position_count FROM
			(
				SELECT Cars.name, Cars.class AS car_class, AVG(position) AS average_position FROM Cars
				JOIN Results ON Results.car = Cars.name
				GROUP BY Cars.name
			)
			WHERE average_position > 3.0
			GROUP BY needed_class
		)
	)
) ON needed_class = Cars.class
JOIN
(
	SELECT Cars.class AS thisClass, COUNT(*) AS total_races FROM Cars
	JOIN Results ON Results.car = Cars.name
	GROUP BY Cars.class
) ON thisClass = Cars.class
GROUP BY Cars.name, Classes.country, total_races, low_position_count
ORDER BY low_position_count DESC;

-- РЕШЕНИЕ СООТВЕТСТВУЮЩЕЕ ВЫВОДУ:
-- | car_name         | car_class  | average_position | race_count | car_country | total_races | low_position_count |
-- |------------------|------------|------------------|------------|-------------|-------------|--------------------|
-- | Audi A4          | Sedan      | 8.0000           | 1          | Germany     | 2           | 2                  |
-- | Chevrolet Camaro | Coupe      | 4.0000           | 1          | USA         | 1           | 1                  |
-- | Renault Clio     | Hatchback  | 5.0000           | 1          | France      | 1           | 1                  |
-- | Ford F-150       | Pickup     | 6.0000           | 1          | USA         | 1           | 1                  |

SELECT * FROM
(SELECT Cars.name AS car_name, Cars.class AS car_class, AVG(position) AS average_position, 
COUNT(*) AS race_count, Classes.country AS car_country, 
total_races, low_position_count FROM Cars
JOIN Classes ON Classes.class = Cars.class
JOIN Results ON Results.car = Cars.name
JOIN
(		
	SELECT car_class AS needed_class, COUNT(*) AS low_position_count FROM
	(
		SELECT Cars.name, Cars.class AS car_class, AVG(position) AS average_position FROM Cars
		JOIN Results ON Results.car = Cars.name
		GROUP BY Cars.name
	)
	WHERE average_position >= 3.0
	GROUP BY needed_class
) ON needed_class = Cars.class
JOIN
(
	SELECT Cars.class AS thisClass, COUNT(*) AS total_races FROM Cars
	JOIN Results ON Results.car = Cars.name
	GROUP BY Cars.class
) ON thisClass = Cars.class
GROUP BY Cars.name, Classes.country, total_races, low_position_count)
WHERE average_position > 3.0
ORDER BY low_position_count DESC;