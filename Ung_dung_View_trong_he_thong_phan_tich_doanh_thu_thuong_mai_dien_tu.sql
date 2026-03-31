CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    region VARCHAR(50)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    total_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20)
);

CREATE TABLE product (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2),
    category VARCHAR(50)
);

CREATE TABLE order_detail (
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES product(product_id),
    quantity INT
);

INSERT INTO customer (full_name, region)
VALUES ('Nguyễn Văn A', 'Hà Nội'),
    ('Trần Thị B', 'Đà Nẵng'),
    ('Lê Văn C', 'TP.HCM'),
    ('Phạm Minh D', 'Hà Nội'),
    ('Hoàng Thị E', 'Cần Thơ');

INSERT INTO product (name, price, category)
VALUES ('Laptop Dell XPS', 2500.00, 'Electronics'),
    ('iPhone 15 Pro', 1200.00, 'Electronics'),
    ('Bàn làm việc gỗ', 150.00, 'Furniture'),
    ('Ghế công thái học', 200.00, 'Furniture'),
    ('Chuột không dây', 25.50, 'Accessories');

INSERT INTO orders (customer_id, total_amount, order_date, status)
VALUES (1, 2525.50, '2026-03-20', 'Shipped'),
    (2, 1200.00, '2026-03-22', 'Pending'),
    (3, 350.00, '2026-03-25', 'Delivered'),
    (1, 150.00, '2026-03-28', 'Cancelled'),
    (5, 200.00, '2026-03-30', 'Shipped');

INSERT INTO order_detail (order_id, product_id, quantity)
VALUES (1, 1, 1),
    (1, 5, 1),
    (2, 2, 1),
    (3, 3, 1),
    (3, 4, 1),
    (5, 4, 1);

CREATE VIEW v_revenue_by_region AS
SELECT c.region, SUM(o.total_amount) AS total_revenue
FROM customer c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.region;

SELECT region, total_revenue
FROM v_revenue_by_region
ORDER BY total_revenue DESC
LIMIT 3;

CREATE VIEW v_revenue_above_avg AS
SELECT region, total_revenue
FROM v_revenue_by_region
WHERE total_revenue > (SELECT AVG(total_revenue) FROM v_revenue_by_region);

SELECT * FROM v_revenue_above_avg;
