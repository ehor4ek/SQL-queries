-- Определить, какие автомобили имеют среднюю позицию лучше (меньше) средней позиции всех автомобилей в своем классе 
-- (то есть автомобилей в классе должно быть минимум два, чтобы выбрать один из них).
-- Вывести информацию об этих автомобилях, включая их имя, класс, среднюю позицию, 
-- количество гонок, в которых они участвовали, и страну производства класса автомобиля. 
-- Также отсортировать результаты по классу и затем по средней позиции в порядке возрастания.

SELECT car_name, car_class, average_position, race_count, car_country FROM 
(SELECT Cars.name AS car_name, Cars.class AS car_class, AVG(position) AS average_position,
COUNT(*) AS race_count, Classes.country AS car_country, class_position FROM Cars
JOIN Classes ON Classes.class = Cars.class
JOIN Results ON Results.car = Cars.name
JOIN (
	SELECT Classes.class AS calc_class, AVG(position) AS class_position FROM Classes
	JOIN Cars ON Cars.class = Classes.class
	JOIN Results ON Results.car = Cars.name
	GROUP BY Classes.class
) ON calc_class = Cars.class
GROUP BY Cars.name, Cars.class, Classes.country, class_position)
WHERE average_position < class_position
ORDER BY car_class, average_position