-- Определить, какие клиенты сделали более двух бронирований в разных отелях, 
-- и вывести информацию о каждом таком клиенте, включая его имя, электронную почту, 
-- телефон, общее количество бронирований, а также список отелей, 
-- в которых они бронировали номера (объединенные в одно поле через запятую). 
-- Также подсчитать среднюю длительность их пребывания (в днях) по всем бронированиям. 
-- Отсортировать результаты по количеству бронирований в порядке убывания.

SELECT Customer.name, email, phone, COUNT(*) AS book_count,
ARRAY_TO_STRING(ARRAY_AGG(DISTINCT Hotel.name ORDER BY Hotel.name), ', ') AS hotels,
AVG(check_out_date - check_in_date) AS staying FROM Customer
JOIN Booking ON Booking.ID_customer = Customer.ID_customer
JOIN Room ON Room.ID_room = Booking.ID_room
JOIN Hotel ON Hotel.ID_hotel = Room.ID_hotel
GROUP BY Customer.ID_customer, Customer.name, email, phone
HAVING COUNT(*) > 2 AND COUNT(DISTINCT Hotel.ID_hotel) > 1
ORDER BY book_count DESC