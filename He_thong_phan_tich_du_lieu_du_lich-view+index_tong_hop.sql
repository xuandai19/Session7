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
SELECT * FROM v_revenue_above_avg;

