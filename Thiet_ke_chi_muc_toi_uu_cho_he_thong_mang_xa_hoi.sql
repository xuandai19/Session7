CREATE TABLE post (
    post_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT,
    tags TEXT[],
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_public BOOLEAN DEFAULT TRUE
);

CREATE TABLE post_like (
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    liked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, post_id)
);

INSERT INTO post (user_id, content, tags, is_public)
VALUES (1, 'Hôm nay mình đi du lịch Đà Lạt, không khí thật tuyệt vời!', '{du lich, da lat, chill}', TRUE),
    (2, 'Chia sẻ kinh nghiệm du lịch tự túc tại Phú Quốc cho gia đình.', '{du lich, phu quoc, travel}', TRUE),
    (1, 'Đang học lập trình PostgreSQL cơ bản tại nhà.', '{coding, database, sql}', TRUE),
    (3, 'Review món bún chả cực ngon tại Hà Nội.', '{food, ha noi, review}', TRUE),
    (2, 'Nhật ký cá nhân - Không công khai.', '{private, diary}', FALSE),
    (4, 'Top 5 địa điểm du lịch mạo hiểm nhất Việt Nam.', '{du lich, adventure, vnam}', TRUE),
    (3, 'Thời tiết hôm nay thật thích hợp để đi du lịch biển.', '{weather, du lich, summer}', TRUE);

INSERT INTO post_like (user_id, post_id)
VALUES (2, 1),
    (3, 1),
    (1, 2),
    (4, 2),
    (2, 4),
    (1, 6);

SELECT * FROM post
WHERE is_public = TRUE AND content ILIKE '%du lịch%';

CREATE INDEX idx_post_content_lower ON post(LOWER(content));

EXPLAIN ANALYZE SELECT * FROM post
WHERE LOWER(content) LIKE '%du lịch%';

SELECT * FROM post
WHERE tags @> ARRAY['travel'];

CREATE INDEX idx_post_tags ON post USING GIN (tags) ;
EXPLAIN ANALYZE SELECT * FROM post
WHERE tags @> ARRAY['travel'];

CREATE INDEX idx_post_recent_public
ON post(created_at DESC)
WHERE is_public = TRUE;

SELECT * FROM post
WHERE is_public = TRUE AND created_at > NOW() - INTERVAL '7 days';

CREATE INDEX idx_user_created_at ON post (user_id, created_at DESC);

EXPLAIN ANALYZE SELECT * FROM post
WHERE user_id IN (1, 2, 3)
ORDER BY created_at DESC
LIMIT 10;
