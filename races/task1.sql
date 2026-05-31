-- Определить, какие автомобили из каждого класса имеют наименьшую среднюю позицию в гонках, 
-- и вывести информацию о каждом таком автомобиле для данного класса, 
-- включая его класс, среднюю позицию и количество гонок, в которых он участвовал. 
-- Также отсортировать результаты по средней позиции.

SELECT * FROM
(SELECT C.name AS car_name, C.class AS car_class, AVG(position) AS average_position,
COUNT(*) AS race_count FROM Cars C
JOIN Results ON Results.car = C.name
GROUP BY C.name, C.class)
WHERE (car_class, average_position) IN
(SELECT car_class, MIN(average_position) FROM
(SELECT Cars.class AS car_class, AVG(position) AS average_position
FROM Cars
JOIN Results ON Results.car = Cars.name
GROUP BY Cars.name, Cars.class)
GROUP BY car_class)
ORDER BY average_position, car_name