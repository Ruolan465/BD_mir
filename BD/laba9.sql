/* 2026-11-11 16:59:18 [146 ms] */ 
CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    registration_date DATE NOT NULL,
    recommended_by INT,
    FOREIGN KEY (recommended_by) REFERENCES Customers(customer_id)
);
/* 2026-11-11 17:01:28 [54 ms] */ 
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);
/* 2026-11-11 17:02:08 [37 ms] */ 
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
/* 2026-11-11 17:02:15 [27 ms] */ 
CREATE TABLE Order_Items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price_per_unit DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
INSERT INTO Customers (customer_id, full_name, email, registration_date, recommended_by) VALUES
(1, 'Иван Иванов', 'ivan.ivanov@example.com', '2023-01-15', NULL),
(2, 'Мария Петрова', 'maria.petrova@example.com', '2023-02-20', 1),
(3, 'Алексей Смирнов', 'alex.smirnov@example.com', '2023-03-10', 1),
(4, 'Елена Васильева', 'elena.v@example.com', '2023-04-01', 2),
(5, 'Андрей Николаев', 'andrey.n@example.com', '2023-05-01', NULL);

INSERT INTO Products (product_name, category, price) VALUES
('Смартфон', 'Электроника', 70000.00),
('Ноутбук', 'Электроника', 120000.00),
('Кофемашина', 'Бытовая техника', 25000.00),
('Книга "Основы SQL"', 'Книги', 1500.00),
('Фен', 'Бытовая техника', 4500.00),
('Пылесос', 'Бытовая техника', 15000.00);

INSERT INTO Orders (customer_id, order_date, status) VALUES
(1, '2024-05-10', 'Доставлен'),
(2, '2024-05-12', 'В обработке'),
(1, '2024-05-15', 'Отправлен'),
(3, '2024-05-16', 'Доставлен');

INSERT INTO Order_Items (order_id, product_id, quantity, price_per_unit) VALUES
(1, 1, 1, 70000.00),  -- Иван купил Смартфон
(1, 4, 2, 1400.00),   -- и 2 книги
(2, 2, 1, 120000.00), -- Мария купила Ноутбук
(3, 3, 1, 25000.00),  -- Иван купил Кофемашину
(4, 1, 1, 70000.00),  -- Алексей купил Смартфон
(4, 5, 1, 4500.00);   -- и Фен
SELECT current_database();

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public';
SELECT --задание1
    c.full_name, --присвоила короткие имена таблицам, указала нужные столбцы
    o.order_date
FROM Customers c --указала первую таблицу
JOIN Orders o ON c.customer_id = o.customer_id;-- вторая таблица и условие через on по которому ссоеденять.
SELECT--задание 2
    c.full_name --какие таблицы нужно вывеести
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id is NULL;--уточнение какие строки выводить

SELECT--задание3
    p.product_name,--какие столбцы из таблиц нужно вывести
    oi.quantity,
    oi.price_per_unit
FROM Orders o --первая таблиа, основная
JOIN Order_Items oi ON o.order_id = oi.order_id --присоединяем несколько таблиц, через ОН указала соединение по одинаковому столбцу
JOIN Products p ON oi.product_id = p.product_id -- аналогично присоединила вторую таблицу
WHERE o.order_id = 1; --указала условие, оставила только 1 заказ
--задание 4
SELECT full_name--вывела имена покупателей
FROM Customers--из таблицы покупателей
WHERE customer_id IN ( -- только тех покупателей, которые подходят по условию ИН
    SELECT customer_id -- выбрала id покупателей
    FROM Orders o-- из таблицы заказов
    JOIN Order_Items oi ON o.order_id = oi.order_id -- соединяем заказы с их позициями
    JOIN Products p ON oi.product_id = p.product_id -- соединяем позиции заказов с товарами
    WHERE p.product_name = 'Смартфон' -- Добавила условие, выводящие только заказы смартфонов
);
-- задание 5
SELECT product_name, price -- вывела название и цену товаров
FROM Products -- из таблицы товаров
WHERE price > (SELECT AVG(price) FROM Products); -- оставляем товары дороже средней цены, avg вычисляет среднее значение цены 
-- задание 6
SELECT order_id, order_date -- вывела номер и дату заказа
FROM Orders o -- из таблицы ордерс
WHERE EXISTS ( -- проверяем, существует ли подходящая позиция заказа
    SELECT 1 -- проверяем наличие любой записи
    FROM Order_Items oi -- из таблицы позиций заказов
    JOIN Products p ON oi.product_id = p.product_id -- соединяем позиции с товарами
    WHERE oi.order_id = o.order_id -- связываем позицию с айди заказа
    AND p.price > 100000 -- оставляем товары дороже 100 000
);
--заание 7
SELECT full_name -- вывела имена
FROM Customers -- из таблицы покупателей
WHERE customer_id NOT IN ( --условие для исключение из списка
    SELECT customer_id -- указала ID покупателей
    FROM Orders o-- из таблицы заказов
    JOIN Order_Items oi ON o.order_id = oi.order_id -- соединяем заказы с позициями
    JOIN Products p ON oi.product_id = p.product_id -- соединяем позиции с товарами
    WHERE p.product_name = 'Ноутбук' -- оставляем только заказы с ноутбуком
);--полчился список покупателей, которые не покупали ноутбук

SELECT DISTINCT--без повторений
c.full_name --какие таблицы нужно вывеести
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id-- объеденила покупатлей и заказы по id покупателя
LEFT JOIN Order_Items oi ON o.order_id = oi.order_id -- соединяем заказы с их позициями
LEFT JOIN Products p ON oi.product_id = p.product_id -- соединяем позиции с товарами
WHERE p.product_name IS NULL OR p.product_name <> 'Ноутбук'; -- оставляем покупателей без ноутбука. Покупатели без покупок(нул) по сути тоже бех ноутбууа
--- задание 8
SELECT p.product_name -- вывела названия товаров
FROM Order_Items oi -- из заказанных товаров
RIGHT JOIN Products p ON oi.product_id = p.product_id -- сохранила все строки товаров,  объединила с заказами
WHERE oi.product_id IS NULL; -- оставла только те, у которых нул в заказе
SELECT-- задание 9
    c.full_name, -- вывела имена покупателей
    p.product_name, -- вывела названия товаров
    oi.quantity -- вывела количество товаров
FROM Customers c -- 1 таблица, покупатели
FULL OUTER JOIN Orders o ON c.customer_id = o.customer_id -- сохранив все записи,соединяем покупателей с заказами
FULL OUTER JOIN Order_Items oi ON o.order_id = oi.order_id -- сохранив все записи, соединяем заказы с их позициями
FULL OUTER JOIN Products p ON oi.product_id = p.product_id; -- сохранив все товары, соединяем позиции с товарами
--нул там, где нет совпадений среди таблиц
--задание10
SELECT DISTINCT c.full_name -- вывела имена покупателей без повторений
FROM Customers c -- берем данные из таблицы покупателей
JOIN Orders o ON c.customer_id = o.customer_id -- соединяем покупателей с заказами
JOIN Order_Items oi ON o.order_id = oi.order_id -- соединяем заказы с их позициями
JOIN Products p ON oi.product_id = p.product_id -- соединяем позиции с товарами
WHERE p.price = (SELECT MAX(price) FROM Products); -- оставляем покупателей, купивших самый дорогой товар
SELECT full_name -- вывела имена покупателей
FROM Customers -- из таблицы покупателей
WHERE customer_id IN ( -- оставляем покупателей из списка подзапроса по условию
    SELECT customer_id -- взяла ID покупателей
    FROM Orders -- из таблицы заказов
    WHERE order_id IN ( -- оставляем нужные заказы по ИН
        SELECT order_id -- взяла ID заказов
        FROM Order_Items -- из таблицы позиций заказов
        WHERE product_id IN ( -- оставила позиции с нужными товарами
            SELECT product_id -- выбираем ID самых дорогих товаров
            FROM Products -- из таблицы товаров
            WHERE price = (SELECT MAX(price) FROM Products) -- находим товар с максимальной ценой
        )
    )
);
SELECT--задание11
    c.full_name, -- выводим имена покупателей
    p.category -- выводим категории товаров
FROM Customers c -- берем данные из таблицы покупателей
CROSS JOIN Products p; -- создаем все возможные комбинации покупателей и товаров
SELECT--задание12
    recommender.full_name AS recommended_by, -- вывела имя того, кто порекомендовал
    customer.full_name AS new_customer -- вывела имя нового покупателя
FROM Customers customer -- первая таблица покупателей
JOIN Customers recommender ON customer.recommended_by = recommender.customer_id; -- соединила покупателя с тем, кто его порекомендовал

--практика 9
SELECT full_name from customers;--прост проверила, правильно ли открыла бд

--задание1
SELECT
    category,--вывела конкретный столбец
    COUNT(product_id) AS products_in_category-- посчитала количество товаров, дав новому столбцу наимонование
FROM Products--из таблицы товаров
GROUP BY category;--группирровка по категории
--задание2
SELECT SUM(quantity * price_per_unit) AS total_revenue--выбрала нужные столбцы, посчитала выручку через СУММ, дала новому столбцу название
FROM Order_Items;--Указала исходную таблицу
--задание3
SELECT 
    c.customer_id,--вывела id покупателей для удобствав работе
    c.full_name,--вывела имена покупателей
    COUNT(o.order_id) AS all_orders --и посчитала количество заказов, дала новому столбцу название
FROM Customers c--работала с данными из таблицы
Left JOIN orders o ON c.customer_id = o.customer_id--соединила по id покупателя
GROUP BY c.customer_id, c.full_name--сгруппировала по имени и id
ORDER BY all_orders DESC;--Отсортировала по количеству заказов
--задание4
SELECT AVG(total_price) AS avg_price--посчитала среднюю стоимость заказа
FROM ( --расчитала общую стоимость в подзапросе(как же я ненавижу эти елочки)
    SELECT
        order_id,--ну тут все как обычно, указала нужные столбцы
        SUM(quantity * price_per_unit) AS total_price--посчитала общую стоимость каждого заказа   
    FROM Order_Items-- откуда брала данные
    GROUP BY order_id--группировка
);

--задание5
SELECT
    status,--нужный столбец
    COUNT(*) AS orders_in_status --посчитала количество заказов в каждом статусе
FROM Orders --из таблицы заказов
GROUP BY status; --сгруппировала заказы по статусам

--задание6
SELECT
    category,--вывела категорию товаров
    COUNT( product_id) AS products_in_category --посчитала количество товаров в каждой категории
FROM Products --из таблицы товаров
GROUP BY category --сгруппировала по категориям
HAVING COUNT( product_id) > 1; --оставила только категории с более чем одним товаром

---задание7
SELECT
    c.full_name,--указала нужный столбей
COUNT(o.order_id) AS total_orders--посчитала количество заказов
FROM Customers c--данные из таблицы покупателей
JOIN Orders o ON c.customer_id = o.customer_id--соединила таблицы по id покупателя
GROUP BY c.full_name--сгруппировала по имени покупателя
HAVING COUNT(o.order_id) > 1;--оставила только тех покупателей, у которых больше одного заказа

--задание8
SELECT
    p.product_name,--вывела название товара
    SUM(oi.quantity) AS total_quantity--и количество проданных единиц
FROM Products p--данные из таблицы товаров
JOIN Order_Items oi ON p.product_id = oi.product_id--соединила таблицы по id товара
GROUP BY p.product_id, p.product_name--сгруппировала по названию товара
HAVING SUM(oi.quantity) = (--оставила только товары с максимальным количеством проданных единиц
    SELECT MAX(total_quantity)--указала максимальное количество единиц
    FROM (----подзапрос для нахождения максимального количества продажц
        SELECT SUM(oi.quantity) AS total_quantity--посчитала количество проданных единиц 
        FROM Products p--взяла данные из таблицы
        JOIN Order_Items oi ON p.product_id = oi.product_id--соединила таблицы по id
        GROUP BY p.product_id, p.product_name--групировочка по названию товара
    )--п.с. Елочки это кошмар, они так путают
);