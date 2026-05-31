-- Вам необходимо провести анализ данных о бронированиях в отелях и определить предпочтения клиентов по типу отелей. 
-- Для этого выполните следующие шаги:

-- Категоризация отелей.
-- Определите категорию каждого отеля на основе средней стоимости номера:

-- «Дешевый»: средняя стоимость менее 175 долларов.
-- «Средний»: средняя стоимость от 175 до 300 долларов.
-- «Дорогой»: средняя стоимость более 300 долларов.
-- Анализ предпочтений клиентов.
-- Для каждого клиента определите предпочитаемый тип отеля на основании условия ниже:

-- Если у клиента есть хотя бы один «дорогой» отель, присвойте ему категорию «дорогой».
-- Если у клиента нет «дорогих» отелей, но есть хотя бы один «средний», присвойте ему категорию «средний».
-- Если у клиента нет «дорогих» и «средних» отелей, но есть «дешевые», присвойте ему категорию предпочитаемых отелей «дешевый».
-- Вывод информации.
-- Выведите для каждого клиента следующую информацию:

-- ID_customer: уникальный идентификатор клиента.
-- name: имя клиента.
-- preferred_hotel_type: предпочитаемый тип отеля.
-- visited_hotels: список уникальных отелей, которые посетил клиент.
-- Сортировка результатов.
-- Отсортируйте клиентов так, чтобы сначала шли клиенты с «дешевыми» отелями, затем со «средними» и в конце — с «дорогими».
Нет необходимости в сортировке по названиям отелей.


SELECT * FROM
(SELECT ID_customer, name,
(CASE WHEN hotel_types LIKE '%Дорогой%' THEN 'Дорогой' WHEN hotel_types LIKE '%Средний%' THEN 'Средний' ELSE 'Дешевый' END) AS preferred_hotel_type,
visited_hotels FROM
(
	SELECT Customer.ID_customer, Customer.name, ARRAY_TO_STRING(ARRAY_AGG(DISTINCT category), '') AS hotel_types, 
	ARRAY_TO_STRING(ARRAY_AGG(DISTINCT hotel_name ORDER BY hotel_name), ',') AS visited_hotels FROM Customer
	JOIN Booking ON Booking.ID_customer = Customer.ID_customer
	JOIN Room ON Room.ID_room = Booking.ID_room
	JOIN 
	(
		SELECT hotel_id, hotel_name,
		(CASE WHEN avg_price < 175 THEN 'Дешевый' WHEN avg_price > 300 THEN 'Дорогой' ELSE 'Средний' END) AS category 
		FROM (
			SELECT Hotel.ID_hotel AS hotel_id, Hotel.name AS hotel_name, AVG(price) AS avg_price FROM Hotel
			JOIN Room ON Room.ID_hotel = Hotel.ID_hotel
			GROUP BY Hotel.ID_hotel
		) 
	) ON hotel_id = Room.ID_hotel
	GROUP BY Customer.ID_customer
)) ORDER BY 
	CASE preferred_hotel_type
		WHEN 'Дешевый' THEN 1
		WHEN 'Средний' THEN 2
		WHEN 'Дорогой' THEN 3
		ELSE 4
	END, ID_customer