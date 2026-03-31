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

SELECT * FROM v_revenue_above_avg;

