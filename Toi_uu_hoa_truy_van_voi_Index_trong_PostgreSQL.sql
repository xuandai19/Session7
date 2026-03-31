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


