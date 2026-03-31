CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    total_amount DECIMAL(10,2),
    order_date DATE
);

INSERT INTO customer (full_name, email, phone)
VALUES ('Nguyễn Văn A', 'vanna@gmail.com', '0912345678'),
    ('Trần Thị B', 'thib@yahoo.com', '0987654321'),
    ('Lê Văn C', 'vanc@outlook.com', '0901122334');

INSERT INTO orders (customer_id, total_amount, order_date)
VALUES (1, 150.00, '2026-03-25'),
    (1, 200.50, '2026-03-28'),
    (2, 50.00, '2026-03-30'),
    (3, 1200.00, '2026-03-31');

CREATE VIEW v_order_summary
AS
SELECT c.full_name, o.total_amount, o.order_date
FROM customer c JOIN orders o ON c.customer_id=o.customer_id;

SELECT *
FROM v_order_summary;

CREATE VIEW v_high_value_orders
AS
SELECT c.full_name, o.total_amount, o.order_date
FROM customer c JOIN orders o ON c.customer_id=o.customer_id
WHERE o.total_amount >= 1000000;

UPDATE v_high_value_orders
SET order_date = '2026-05-01'
WHERE full_name = 'Nguyễn Văn A';

CREATE VIEW v_monthly_sales
AS
SELECT
    TO_CHAR(order_date, 'YYYY-MM') month,
    SUM(o.total_amount) total_revenue
FROM orders o
GROUP BY month;

DROP VIEW v_order_summary;
