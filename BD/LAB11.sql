--задание1
CREATE TABLE Books (
    --изначальная таблица. соответствует НФ2, но нарушена НФ3
    --мздательство и его город, определяются не бук_ид, а публишер_ид
    book_id INT PRIMARY KEY,--ид книги
    title VARCHAR(255),--назвванеи книги
    author_name VARCHAR(255),--автор книги
    publisher_id INT,--издпательство книги
    publisher_name VARCHAR(255),-- Название издательства, неключ.атрибут публишер ид
    publisher_city VARCHAR(100)-- Город, в котором находится издательство, неключ.атрибут публишер ид
);
--разделить данные на две таблицы
CREATE TABLE publishers(
    publisher_id INT PRIMARY KEY,
    publisher_name VARCHAR(255),    -- Название издательства
    publisher_city VARCHAR(100)     -- Город, в котором находится издательство
);
CREATE TABLE bookss (
    book_id INT PRIMARY KEY,
    title VARCHAR(255),
    author_name VARCHAR(255),
    publisher_id INT,
    FOREIGN KEY (publisher_id) REFERENCES Publishers(publisher_id)
);
INSERT INTO publishers (publisher_id, publisher_name, publisher_city) VALUES
(1, '"Эксмо', 'Москва'),
(2, 'Питер', 'Санкт-Петербург');
INSERT INTO Bookss (book_id, title, author_name, publisher_id) VALUES
    (10, 'Базы данных', 'Иван Иванов', 1),
    (20, 'SQL для начинающих', 'Мария Петрова', 1),
    (30, 'Проектирование систем', 'Алексей Сидоров', 2);
    SELECT
    b.book_id,
    b.title,
    b.author_name,
    p.publisher_name,
    p.publisher_city
FROM bookss b
JOIN publishers p ON p.publisher_id = b.publisher_id
ORDER BY b.book_id; --проверила, работает


--задание 2
CREATE TABLE RaceResults_test (
    race_id INT,--PK
    driver_id INT,--PK
    car_model VARCHAR(100), -- Модель автомобиля
    car_manufacturer VARCHAR(100),-- Производитель автомобиля, зависти от неключ. кар модэл
    finish_time TIME,--время заезда
    PRIMARY KEY (race_id, driver_id)--PK составной
);--делим на 2 таблицы
CREATE TABLE Cars (
    car_model VARCHAR(100) PRIMARY KEY,
    car_manufacturer VARCHAR(100)
);
CREATE TABLE RaceResults (
    race_id INT,
    driver_id INT,
    car_model VARCHAR(100),
    finish_time TIME,
    PRIMARY KEY (race_id, driver_id),
    FOREIGN KEY (car_model) REFERENCES Cars(car_model)
);
INSERT INTO Cars (car_model, car_manufacturer)
VALUES
    ('GT-R', 'Nissan.'),
    ('GS F', 'Lexus'),
    ('MC20', 'Maserati');
INSERT INTO RaceResults (race_id, driver_id, car_model, finish_time)
VALUES
    (1, 10, 'GT-R', '00:12:10'),
    (1, 11, 'GS F', '00:12:03'),
    (2, 10, 'MC20', '00:11:58');
SELECT
    r.race_id,
    r.driver_id,
    r.car_model,
    c.car_manufacturer,
    r.finish_time
FROM RaceResults r
JOIN Cars c ON c.car_model = r.car_model
ORDER BY r.race_id, r.driver_id;--работает


--задание3
CREATE TABLE RoomBookings_test (--я даж не знаю с чего подступится, ощущение как наушники распутываешь
    booking_time TIMESTAMP,--бронирование
    room_name VARCHAR(255),--название комнаты
    event_name VARCHAR(255),--название ивента
    event_type VARCHAR(255)--тип ивента
);--Нарушение НФБК: время ивента определяет имя комнаты, 
--но это не суперключ, он не определяет бронирование, 
--вынесла их в отдельные таблицы
CREATE TABLE Rooms (
    room_name VARCHAR(255) PRIMARY KEY
);--таблица с названиями
CREATE TABLE EventsType (
    event_type VARCHAR(255) PRIMARY KEY,
    room_name VARCHAR(255),
    FOREIGN KEY (room_name) REFERENCES Rooms(room_name)
);--зависимость комнаты от типа ивента
CREATE TABLE Events (
    event_name VARCHAR(255) PRIMARY KEY,
    event_type VARCHAR(255),
    FOREIGN KEY (event_type) REFERENCES EventsType(event_type)
);--Ивенты
CREATE TABLE RoomBookings (
    booking_time TIMESTAMP,
    room_name VARCHAR(255),
    event_name VARCHAR(255),
    PRIMARY KEY (booking_time, room_name),
    UNIQUE (booking_time, event_name),
    FOREIGN KEY (room_name) REFERENCES Rooms(room_name),
    FOREIGN KEY (event_name) REFERENCES Events(event_name)
);--организация бронирования(вроде распуталась)
--Да прибудет с вами проверка работоспособности этой штуки
INSERT INTO Rooms (room_name) VALUES
    ('Зал №1'),
    ('Зал N№2');
INSERT INTO EventsType (event_type, room_name) VALUES
    ('Презентация', 'Зал №1'),
    ('Встреча', 'Зал N№2');
INSERT INTO Events (event_name, event_type)
VALUES
    ('Презентация проекта', 'Презентация'),
    ('Презентация продукта', 'Презентация'),
    ('Планёрка команды', 'Встреча');
INSERT INTO RoomBookings (booking_time, room_name, event_name)
VALUES
    ('2026-11-20 10:00:00', 'Зал №1', 'Презентация проекта'),
    ('2026-11-20 11:00:00', 'Зал №1', 'Презентация продукта'),
    ('2026-11-20 10:00:00', 'Зал N№2', 'Планёрка команды');
    SELECT
    b.booking_time,
    b.room_name,
    b.event_name,
    e.event_type
FROM RoomBookings b
JOIN Events e ON e.event_name = b.event_name
ORDER BY b.booking_time, b.room_name; --работает