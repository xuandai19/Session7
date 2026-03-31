CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    phone VARCHAR(20),
    city VARCHAR(50),
    symptoms TEXT[]
);

CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    department VARCHAR(50)
);

CREATE TABLE appointments (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    doctor_id INT REFERENCES doctors(doctor_id),
    appointment_date DATE,
    diagnosis VARCHAR(200),
    fee NUMERIC(10,2)
);

INSERT INTO patients (full_name, phone, city, symptoms)
VALUES ('Nguyễn Văn A', '0912345678', 'Hà Nội', ARRAY['ho', 'sốt', 'đau họng']),
    ('Trần Thị B', '0987654321', 'Đà Nẵng', ARRAY['đau đầu', 'chóng mặt']),
    ('Lê Văn C', '0905123456', 'Hồ Chí Minh', ARRAY['đau dạ dày', 'buồn nôn']),
    ('Phạm Minh D', '0934112233', 'Hà Nội', ARRAY['phát ban', 'ngứa']),
    ('Hoàng Thị E', '0977889900', 'Cần Thơ', ARRAY['khó thở', 'tức ngực']);

INSERT INTO doctors (full_name, department)
VALUES ('BS. Nguyễn Huy Hoàng', 'Nội khoa'),
    ('BS. Lê Kim Liên', 'Nhi khoa'),
    ('BS. Trần Quốc Toản', 'Da liễu'),
    ('BS. Đặng Thùy Trâm', 'Tim mạch'),
    ('BS. Ngô Bảo Châu', 'Tiêu hóa');

INSERT INTO appointments (patient_id, doctor_id, appointment_date, diagnosis, fee)
VALUES (1, 1, '2026-03-01', 'Viêm họng cấp', 200.00),
    (1, 2, '2026-03-10', 'Kiểm tra tổng quát', 150.00),
    (2, 2, '2026-03-05', 'Rối loạn tiền đình', 300.00),
    (3, 5, '2026-03-12', 'Viêm loét dạ dày', 500.00),
    (4, 3, '2026-03-15', 'Dị ứng thời tiết', 100.00),
    (5, 4, '2026-03-20', 'Suy tim nhẹ', 800.00),
    (2, 1, '2026-03-22', 'Cảm cúm', 150.00),
    (3, 5, '2026-03-25', 'Trào ngược dạ dày', 450.00),
    (4, 3, '2026-03-28', 'Viêm da cơ địa', 200.00),
    (5, 4, '2026-03-30', 'Huyết áp cao', 350.00);

CREATE INDEX idx_patients_phone ON patients(phone);

CREATE INDEX idx_patients_city ON patients USING hash (city);

CREATE INDEX idx_patients_symptoms ON patients USING gin (symptoms);

CREATE INDEX idx_appointments_fee ON appointments USING gist (fee);

CREATE INDEX idx_appointments_date ON appointments (appointment_date);
CLUSTER appointments USING idx_appointments_date;

CREATE VIEW view_patient_top3
AS
SELECT p.patient_id, p.full_name, p.phone, SUM(a.fee) "Total_fee"
FROM appointments a JOIN patients p ON a.patient_id = p.patient_id
GROUP BY p.patient_id, p.full_name, p.phone
ORDER BY "Total_fee" DESC
LIMIT 3;

SELECT * FROM view_patient_top3;

CREATE VIEW view_doctors
AS
SELECT d.full_name doctor_name, COUNT(a.appointment_id) "total_appointments"
FROM appointments a JOIN doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.full_name;

SELECT * FROM view_doctors;

CREATE VIEW v_patient_city
AS
SELECT p.patient_id, p.full_name, p.city
FROM patients p
WITH CHECK OPTION;

SELECT * FROM v_patient_city;

UPDATE v_patient_city
SET city = 'Đà Nẵng'
WHERE full_name = 'Nguyễn Văn A';




create table customers(
    customer_id serial primary key,
    full_name varchar(100),
    email varchar(100) unique,
    city varchar(50)
);
create table products(
    product_id serial primary key,
    product_name varchar(100),
    category text[],
    price numeric(10,2)
);
create table orders(
    order_id serial primary key,
    customer_id int references customers(customer_id),
    product_id int references products(product_id),
    order_date date,
    quantity int
);

INSERT INTO customers (full_name, email, city)
VALUES ('Nguyễn Văn An', 'an.nv@gmail.com', 'Hà Nội'),
    ('Lê Thị Bình', 'binh.lt@yahoo.com', 'Hồ Chí Minh'),
    ('Trần Văn Cường', 'cuong.tv@outlook.com', 'Đà Nẵng'),
    ('Phạm Minh Đức', 'duc.pm@gmail.com', 'Hà Nội'),
    ('Hoàng Thị Em', 'em.ht@student.edu.vn', 'Cần Thơ');

INSERT INTO products (product_name, category, price)
VALUES ('Laptop Dell XPS', ARRAY['Electronics', 'Computing'], 2500.00),
    ('iPhone 15 Pro', ARRAY['Electronics', 'Mobile'], 1200.00),
    ('Bàn phím cơ', ARRAY['Accessories', 'Computing'], 150.00),
    ('Tủ lạnh Samsung', ARRAY['Appliances', 'Kitchen'], 800.00),
    ('Chuột Logitech', ARRAY['Accessories', 'Computing'], 50.00);

INSERT INTO orders (customer_id, product_id, order_date, quantity)
VALUES (1, 1, '2026-03-01', 1), (1, 3, '2026-03-02', 2),
    (2, 2, '2026-03-05', 1), (3, 4, '2026-03-10', 1),
    (4, 5, '2026-03-12', 5), (5, 1, '2026-03-15', 1),
    (2, 3, '2026-03-18', 1), (3, 2, '2026-03-20', 1),
    (1, 5, '2026-03-22', 2), (4, 4, '2026-03-25', 1);

CREATE INDEX idx_cust_email ON customers(email);

CREATE INDEX idx_cust_city ON customers USING hash (city);

CREATE INDEX idx_prod_category ON products USING gin (category);

CREATE EXTENSION IF NOT EXISTS btree_gist;
CREATE INDEX idx_prod_price ON products USING gist (price);

CREATE INDEX idx_orders_date ON orders (order_date);
CLUSTER orders USING idx_orders_date;

CREATE VIEW v_top_customers
AS
SELECT c.full_name, SUM(o.quantity) total_quantity
FROM orders o JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.full_name
ORDER BY total_quantity DESC
LIMIT 3;

SELECT * FROM v_top_customers;

CREATE VIEW v_product_revenue
AS
SELECT p.product_name, SUM(o.quantity * p.price) total_revenue
FROM orders o JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;

SELECT * FROM v_product_revenue;

CREATE VIEW v_customer_city
AS
SELECT customer_id, full_name, city
FROM customers
WITH CHECK OPTION;

UPDATE v_customer_city
SET city = 'Hải Phòng'
WHERE full_name = 'Nguyễn Văn An';



CREATE TABLE book (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    author VARCHAR(100),
    genre VARCHAR(50),
    price DECIMAL(10,2),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO book (title, author, genre, price, description)
VALUES ('Harry Potter and the Philosophers Stone', 'J.K. Rowling', 'Fantasy', 29.99, 'A young boy discovers he is a wizard.'),
    ('Harry Potter and the Chamber of Secrets', 'J.K. Rowling', 'Fantasy', 24.50, 'Harry returns to Hogwarts for his second year.'),
    ('The Hobbit', 'J.R.R. Tolkien', 'Fantasy', 15.00, 'A hobbits journey to reclaim a treasure.'),
    ('The Da Vinci Code', 'Dan Brown', 'Mystery', 12.99, 'A murder in the Louvre leads to a religious mystery.'),
    ('A Game of Thrones', 'George R.R. Martin', 'Fantasy', 35.00, 'Noble families fight for control of the Iron Throne.'),
    ('Clean Code', 'Robert C. Martin', 'Education', 45.00, 'A handbook of agile software craftsmanship.');

SELECT * FROM book WHERE author ILIKE '%Rowling%';
SELECT * FROM book WHERE genre = 'Fantasy';

CREATE INDEX idx_author ON book(author);
CREATE INDEX idx_genre ON book(genre);

EXPLAIN ANALYZE SELECT * FROM book WHERE author ILIKE '%Rowling%';
EXPLAIN ANALYZE SELECT * FROM book WHERE genre = 'Fantasy';


CREATE INDEX idx_title ON book USING GIN (title);
CREATE INDEX idx_description ON book USING GIN (description);

CLUSTER book USING idx_genre;


