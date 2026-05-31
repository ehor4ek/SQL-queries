-- Определить классы автомобилей, которые имеют наименьшую среднюю позицию в гонках, 
-- и вывести информацию о каждом автомобиле из этих классов, включая его имя, 
-- среднюю позицию, количество гонок, в которых он участвовал, 
-- страну производства класса автомобиля, а также общее количество гонок, 
-- в которых участвовали автомобили этих классов. 
-- Если несколько классов имеют одинаковую среднюю позицию, выбрать все из них.

SELECT Cars.name AS car_name, Cars.class AS car_class, AVG(position) AS average_position,
COUNT(*) AS race_count, Classes.country AS car_country, total_races FROM Cars
JOIN Classes ON Classes.class = Cars.class
JOIN Results ON Results.car = Cars.name
JOIN 
(SELECT car_class AS needed_car_class, total_races FROM
(SELECT C.class AS car_class, AVG(position) AS average_position, COUNT(*) AS total_races
FROM Classes C
JOIN Cars ON Cars.class = C.class
JOIN Results ON Results.car = Cars.name
GROUP BY car_class)
WHERE average_position =
(SELECT MIN(average_position) FROM
(SELECT C.class AS car_class, AVG(position) AS average_position FROM Classes C
JOIN Cars ON Cars.class = C.class
JOIN Results ON Results.car = Cars.name
GROUP BY car_class)))
ON needed_car_class = Cars.class
GROUP BY Cars.name, Cars.class, Classes.country, total_races