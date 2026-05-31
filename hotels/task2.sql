-- Необходимо провести анализ клиентов, 
-- которые сделали более двух бронирований в разных отелях 
-- и потратили более 500 долларов на свои бронирования. Для этого:

-- Определить клиентов, которые сделали более двух бронирований и 
-- забронировали номера в более чем одном отеле. 
-- Вывести для каждого такого клиента следующие данные: ID_customer, имя, общее количество бронирований, 
-- общее количество уникальных отелей, в которых они бронировали номера, и общую сумму, потраченную на бронирования.
-- Также определить клиентов, которые потратили более 500 долларов на бронирования, 
-- и вывести для них ID_customer, имя, общую сумму, потраченную на бронирования, и общее количество бронирований.
-- В результате объединить данные из первых двух пунктов, 
-- чтобы получить список клиентов, которые соответствуют условиям обоих запросов. 
-- Отобразить поля: ID_customer, имя, общее количество бронирований, общую сумму, потраченную на бронирования, 
-- и общее количество уникальных отелей.
-- Результаты отсортировать по общей сумме, потраченной клиентами, в порядке возрастания.

-- РЕШЕНИЕ СТРОГО ПО УСЛОВИЮ:

SELECT ID_customer, customer_name AS name, total_bookings, total_spent, unique_hotels FROM
(
	SELECT Customer.ID_customer, Customer.name AS customer_name, COUNT(*) AS total_bookings,
	COUNT(DISTINCT Hotel.ID_hotel) AS unique_hotels,
	SUM((check_out_date - check_in_date) * price) AS total_spent FROM Customer
	JOIN Booking ON Booking.ID_customer = Customer.ID_customer
	JOIN Room ON Room.ID_room = Booking.ID_room
	JOIN Hotel ON Hotel.ID_hotel = Room.ID_hotel
	GROUP BY Customer.ID_customer
	HAVING COUNT(*) > 2 AND
	COUNT(DISTINCT Hotel.ID_hotel) > 1
)
JOIN
(
	SELECT Customer.ID_customer AS id_rich, Customer.name,
	SUM((check_out_date - check_in_date) * price),	COUNT(*) FROM Customer
	JOIN Booking ON Booking.ID_customer = Customer.ID_customer
	JOIN Room ON Room.ID_room = Booking.ID_room
	JOIN Hotel ON Hotel.ID_hotel = Room.ID_hotel
	GROUP BY Customer.ID_customer
	HAVING SUM((check_out_date - check_in_date) * price) > 500
) ON id_rich = ID_customer
ORDER BY total_spent

-- РЕШЕНИЕ СООТВЕТСТВУЮЩЕЕ ВЫВОДУ:

SELECT ID_customer, customer_name AS name, total_bookings, total_spent, unique_hotels FROM
(
	SELECT Customer.ID_customer, Customer.name AS customer_name, COUNT(*) AS total_bookings,
	COUNT(DISTINCT Hotel.ID_hotel) AS unique_hotels,
	SUM(price) AS total_spent FROM Customer
	JOIN Booking ON Booking.ID_customer = Customer.ID_customer
	JOIN Room ON Room.ID_room = Booking.ID_room
	JOIN Hotel ON Hotel.ID_hotel = Room.ID_hotel
	GROUP BY Customer.ID_customer
	HAVING COUNT(*) > 2 AND
	COUNT(DISTINCT Hotel.ID_hotel) > 1
)
JOIN
(
	SELECT Customer.ID_customer AS id_rich, Customer.name,
	SUM(price),	COUNT(*) FROM Customer
	JOIN Booking ON Booking.ID_customer = Customer.ID_customer
	JOIN Room ON Room.ID_room = Booking.ID_room
	JOIN Hotel ON Hotel.ID_hotel = Room.ID_hotel
	GROUP BY Customer.ID_customer
	HAVING SUM(price) > 500
) ON id_rich = ID_customer
ORDER BY total_spent