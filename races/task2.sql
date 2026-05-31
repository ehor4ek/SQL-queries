-- Определить автомобиль, который имеет наименьшую среднюю позицию в гонках среди всех автомобилей, 
-- и вывести информацию об этом автомобиле, включая его класс, среднюю позицию, количество гонок, 
-- в которых он участвовал, и страну производства класса автомобиля. 
-- Если несколько автомобилей имеют одинаковую наименьшую среднюю позицию, выбрать один из них по алфавиту (по имени автомобиля).

SELECT C.name AS car_name, C.class AS car_class, AVG(position) AS average_position, 
COUNT(*) AS race_count, Classes.country AS car_country FROM Cars C
JOIN Classes ON Classes.class = C.class
JOIN Results ON Results.car = C.name
GROUP BY car_name, car_country
ORDER BY average_position, car_name
LIMIT 1;