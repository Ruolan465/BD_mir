--Таблица запускается и по сути работает, но она совершенно непрактична и с ней невозможно работаь.
CREATE TABLE Projects_False (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(255),
    team_members VARCHAR(1000) -- Пример: 'Алексеев, Борисов, Васильева'
);
--она выглядит так, будто хотели сделать связь M:N, но совсем не понимают как это работает в целом.
--Что бы исправить ошибку и привести к 1НФ, нужно разбить данные на две таблицы и создать переходную меж ними 
--она нарушает 1НФ, так как в ней хранится несколько значений в одном поле,
--что делает невозможным нормальное использование данных. 
CREATE TABLE members (
    member_id INT PRIMARY KEY,
    member_name VARCHAR(255)
);
CREATE TABLE Projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(255)
);

CREATE TABLE Teamwork (
    project_id INT,
    member_id INT,
    PRIMARY KEY (project_id, member_id),--составной первичный ключ
    FOREIGN KEY (project_id) REFERENCES projects(project_id),--внешние ключи для связи с бд
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
INSERT INTO members (member_id, member_name) VALUES
(1, 'Мария Петрова'),
(2, 'Иван Иванов'),
(3, 'Алексей Смирнов'),
(4, 'Ольга Кузнецова'),
(5, 'Дмитрий Соколов');
INSERT INTO projects (project_id, project_name) VALUES
(1, 'Проект A'),
(2, 'Проект B'),
(3, 'Проект C'),
(4, 'Проект D');
insert into teamwork (project_id, member_id) values
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(4, 1),
(4, 3);--заполнила таблицы данными 
select 
p.project_name, 
m.member_name
from teamwork t
join projects p on t.project_id = p.project_id
join members m on t.member_id = m.member_id;--проверила работоспособность











--заданеи2
CREATE TABLE EquipmentRentals (--Нарушение НФ2
    client_id INT,
    equipment_id INT,
    client_name VARCHAR(255),    -- Имя клиента определяеся по айди клиента
    client_email VARCHAR(255),   -- Email клиента по айди клиента
    equipment_name VARCHAR(255), -- Название оборудования по айди оборудования
    rental_date DATE,            -- Дата аренды от первичного ключа
    PRIMARY KEY (client_id, equipment_id)--составной первичный ключ
);
-- некоторыее столбцы в частичной фунциональной зависимости, зависят только от части составного ключа
--для НФ2 кажждый неключевой атрибут должен полностью зависеть от первичного ключа
CREATE TABLE clients(--разбила на 2 основные таблицы
    client_id INT PRIMARY KEY,
    client_name VARCHAR(255),
    client_email VARCHAR(255)
);
CREATE Table equipment (
    equipment_id INT PRIMARY KEY,
    equipment_name VARCHAR(255)
);
CREATE TABLE rental (---создала таблицу для связи между ними
    client_id INT,
    equipment_id INT,
    rental_date DATE,
    PRIMARY KEY (client_id, equipment_id),--составной первичный ключ
    FOREIGN KEY (client_id) REFERENCES clients(client_id),--внешние ключи для связи с бд
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id)
);
INSERT INTO clients (client_id, client_name, client_email) VALUES
(1, 'Алексей Петров', 'aleksey.petrov@example.com'),
(2, 'Мария Иванова', 'maria.ivanova@example.com'),
(3, 'Иван Смирнов', 'ivan.smirnov@example.com'),
(4, 'Ольга Кузнецова', 'olga.kuznetsova@example.com');
INSERT INTO equipment (equipment_id, equipment_name) VALUES
(1, 'Проектор'),
(2, 'Компьютер'),
(3, 'Микрофон'),
(4, 'Камера'),
(5, 'Принтер'),
(6, 'Сканер');
INSERT INTO rental (client_id, equipment_id, rental_date) VALUES
(1, 1, '2024-01-15'),
(1, 2, '2024-01-20'),
(2, 3, '2024-02-05'),
(2, 4, '2024-02-10'),
(3, 5, '2024-03-01'),
(3, 6, '2024-03-05'),
(3, 1, '2024-04-10'),
(4, 3, '2024-04-15');

SELECT 
    c.client_name, 
    c.client_email, 
    e.equipment_name, 
    r.rental_date
FROM rental r
JOIN clients c ON r.client_id = c.client_id
JOIN equipment e ON r.equipment_id = e.equipment_id;-- ура,работает!










--задание3

CREATE TABLE StudentGrades (-- нарушение НФ1 и НФ2,главный босс
    student_id INT,
    course_id INT,
    student_name VARCHAR(255),--НФ2, поле зависит только от части составного ключа
    course_professor VARCHAR(255),--ФН2, поле зависит только от части составного ключа
    assignments_and_grades TEXT, -- НФ1, поле содержит несколько значений
    PRIMARY KEY (student_id, course_id)--составной первичный ключ
);
--решается путем разделения на три таблицы
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(255)
);
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(255),
    course_professor VARCHAR(255)
);

CREATE TABLE grades (
    student_id INT,
    course_id INT,
    assignments VARCHAR(250),
    grade INT,
    PRIMARY KEY (student_id, course_id, assignments),--составной первичный ключ
    FOREIGN KEY (student_id) REFERENCES students(student_id),--внешние ключи для связи с бд
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
INSERT INTO students (student_id, student_name) VALUES
(1, 'Алексей Петров');
INSERT INTO courses (course_id, course_name, course_professor) VALUES
(1, 'Математика', 'Профессор Иванов'),
(2, 'Физика', 'Профессор Смирнов'),
(3, 'Химия', 'Профессор Кузнецова'),
(4, 'Биология', 'Профессор Соколов');
INSERT INTO grades (student_id, course_id, assignments, grade) VALUES
(1, 1, 'Задание 1', 85),
(1, 1, 'Задание 2', 90),
(1, 2, 'Задание 1', 78),
(1, 3, 'Задание 1', 92),
(1, 4, 'Задание 1', 88),
(1, 4, 'Задание 2', 95),
(1, 4, 'Задание 3', 80),
(1, 4, 'Задание 4', 87),
(1, 4, 'Задание 5', 91);
SELECT 
    s.student_name, 
    c.course_professor, 
    c.course_name,
    g.assignments, 
    g.grade
    FROM grades g
JOIN students s ON g.student_id = s.student_id
JOIN courses c ON g.course_id = c.course_id;    
SELECT
    c.course_name,
    AVG(g.grade) AS avgMAT
FROM grades g
JOIN courses c ON g.course_id = c.course_id
WHERE c.course_name = 'Математика'
GROUP BY c.course_name;--проверила работоспособность кода
