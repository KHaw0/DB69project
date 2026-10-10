DROP TABLE IF EXISTS class_equipment;
DROP TABLE IF EXISTS booking;
DROP TABLE IF EXISTS gym_class;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS trainer;
DROP TABLE IF EXISTS member;

SHOW TABLES

-- ============================================================
--  schema.sql — ระบบฟิตเนส (นิสิตออกแบบและเขียนเอง)
--  กติกา: การจอง = M:N (member × gym_class), อุปกรณ์ต่อคลาส = M:N (gym_class × equipment),
--         แต่ละคลาสมีเทรนเนอร์ (1:M จาก trainer)
-- ============================================================
CREATE TABLE member (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    gender ENUM('Male', 'Female') NOT NULL,
    phone VARCHAR(20) NOT NULL,
    join_date DATE NOT NULL,
    package_type ENUM('basic', 'premium') NOT NULL,
    born_date DATE
    -- TODO: name, gender, join_date, package_type
);
CREATE TABLE trainer (
    trainer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialty VARCHAR(100),
    phone VARCHAR(20),
    born_date DATE
    -- TODO: name, specialty, phone
);
CREATE TABLE gym_class (          -- 1:M จาก trainer
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    trainer_id INT,
    name VARCHAR(100) NOT NULL,
    room VARCHAR(30) NOT NULL,
    capacity INT NOT NULL,
    schedule_time VARCHAR(50) NOT NULL,
    difficulty ENUM('beginner','intermediate','advanced') NOT NULL,
    price DECIMAL(8, 2) NOT NULL,

    FOREIGN KEY (trainer_id) REFERENCES trainer(trainer_id)
    -- TODO: trainer_id (FK), name, room, capacity, schedule_time
    -- ★ ไม่ต้องมีคอลัมน์ที่นั่งว่าง — คำนวณจาก capacity − การจอง (ดู search_classes ใน db.py)
);
CREATE TABLE booking (            -- M:N: member × gym_class
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    class_id INT NOT NULL,
    book_date DATE NOT NULL,
    status ENUM('booked', 'cancelled') NOT NULL DEFAULT 'booked',

    Foreign Key (member_id) REFERENCES member (member_id),
    Foreign Key (class_id) REFERENCES gym_class(class_id)
    -- TODO: member_id (FK), class_id (FK), book_date, status ENUM('booked','cancelled')
);
CREATE TABLE equipment (
    equip_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    zone VARCHAR(30),
    status ENUM('available', 'unavailable') NOT NULL DEFAULT 'available'
    -- TODO: name, zone, status
);
CREATE TABLE class_equipment (    -- M:N: gym_class × equipment
    -- TODO: class_id (FK), equip_id (FK), quantity ; PRIMARY KEY (class_id, equip_id)
    class_id INT NOT NULL,
    equip_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,

    Foreign Key (class_id) REFERENCES gym_class(class_id),
    Foreign Key (equip_id) REFERENCES equipment(equip_id),
    PRIMARY KEY (class_id, equip_id)
);
-- TODO: INSERT ข้อมูลตัวอย่างทุกตาราง
--   ★ ควรมีคลาสที่ถูกจองเต็ม capacity อย่างน้อย 1 คลาส ไว้ทดสอบ "คลาสเต็มจองไม่ได้"

-- ============================================================
-- 1. MEMBERS (20 members)
-- ============================================================
INSERT INTO member (name, gender, phone, join_date, package_type) VALUES
('John Miller', 'Male', '081-100-0001', '2026-01-05', 'premium'),
('Sarah Connor', 'Female', '081-100-0002', '2026-01-08', 'basic'),
('Michael Chang', 'Male', '081-100-0003', '2026-01-12', 'premium'),
('Emily Watson', 'Female', '081-100-0004', '2026-01-15', 'basic'),
('David Beckham', 'Male', '081-100-0005', '2026-01-20', 'premium'),
('Jessica Alba', 'Female', '081-100-0006', '2026-01-25', 'basic'),
('Robert Downey', 'Male', '081-100-0007', '2026-02-01', 'premium'),
('Emma Stone', 'Female', '081-100-0008', '2026-02-03', 'basic'),
('Chris Evans', 'Male', '081-100-0009', '2026-02-10', 'premium'),
('Scarlett Johansson', 'Female', '081-100-0010', '2026-02-14', 'premium'),
('Tom Holland', 'Male', '081-100-0011', '2026-02-18', 'basic'),
('Zendaya Coleman', 'Female', '081-100-0012', '2026-02-22', 'premium'),
('Bruce Wayne', 'Male', '081-100-0013', '2026-03-01', 'premium'),
('Diana Prince', 'Female', '081-100-0014', '2026-03-02', 'premium'),
('Clark Kent', 'Male', '081-100-0015', '2026-03-05', 'basic'),
('Natasha Romanoff', 'Female', '081-100-0016', '2026-03-08', 'basic'),
('Peter Parker', 'Male', '081-100-0017', '2026-03-10', 'basic'),
('Tony Stark', 'Male', '081-100-0018', '2026-03-12', 'premium'),
('Wanda Maximoff', 'Female', '081-100-0019', '2026-03-15', 'premium'),
('Steve Rogers', 'Male', '081-100-0020', '2026-03-18', 'basic');

-- ============================================================
-- 2. TRAINERS (6 trainers)
-- ============================================================
INSERT INTO trainer (name, specialty, phone) VALUES
('Alex Hunter', 'Bodybuilding', '082-200-0001'),
('Sophia Turner', 'Yoga', '082-200-0002'),
('Marcus Vance', 'HIIT', '082-200-0003'),
('Elena Rostova', 'Zumba', '082-200-0004'),
('Liam Cooper', 'Cycling', '082-200-0005'),
('Chloe Bennett', 'Boxing', '082-200-0006');

-- ============================================================
-- 3. GYM CLASSES (8 classes, includes difficulty + price)
-- ★ Class 6 capacity=2, Class 8 capacity=3 (will be fully booked)
-- ============================================================
INSERT INTO gym_class (trainer_id, name, room, capacity, schedule_time, difficulty, price) VALUES
(2, 'Vinyasa Flow Yoga', 'Studio A', 15, '08:00 - 09:00', 'beginner', 250.00),
(1, 'Hypertrophy Upper Body', 'Weight Room', 12, '10:00 - 11:00', 'intermediate', 350.00),
(3, 'Extreme HIIT Circuit', 'Functional Zone', 10, '12:00 - 13:00', 'advanced', 400.00),
(4, 'Zumba Dance Fiesta', 'Studio B', 20, '17:00 - 18:00', 'beginner', 200.00),
(5, 'Sprint Spin Cycling', 'Spin Studio', 12, '18:00 - 19:00', 'intermediate', 300.00),
(1, 'Powerlifting Masterclass', 'Power Cage 1', 2, '19:00 - 20:00', 'advanced', 500.00),
(2, 'Core Pilates Rehab', 'Studio A', 8, '10:00 - 11:00', 'beginner', 280.00),
(6, 'Elite Boxing Camp', 'Ring Studio', 3, '16:00 - 17:00', 'advanced', 450.00);

-- ============================================================
-- 4. EQUIPMENT (10 items)
-- ============================================================
INSERT INTO equipment (name, zone, status) VALUES
('Eco Yoga Mat', 'Studio A', 'available'),
('Adjustable Dumbbell Pair (2-24kg)', 'Weight Room', 'available'),
('Cast Iron Kettlebell 16kg', 'Functional Zone', 'available'),
('Olympic Barbell 20kg & Bumper Plates', 'Power Cage 1', 'available'),
('Cardio Step Platform', 'Studio B', 'available'),
('Heavy Resistance Bands Set', 'Functional Zone', 'available'),
('Commercial Stationary Spin Bike', 'Spin Studio', 'available'),
('Pro Boxing Gloves (14oz)', 'Ring Studio', 'available'),
('Heavy Punching Bag', 'Ring Studio', 'available'),
('Pilates Foam Roller', 'Studio A', 'available');

-- ============================================================
-- 5. CLASS EQUIPMENT
-- ============================================================
INSERT INTO class_equipment (class_id, equip_id, quantity) VALUES
(1, 1, 15),
(1, 10, 8),
(2, 2, 12),
(3, 3, 10),
(3, 6, 10),
(4, 5, 20),
(5, 7, 12),
(6, 4, 2),
(7, 1, 8),
(7, 10, 8),
(8, 8, 6),
(8, 9, 3);

-- ============================================================
-- 6. BOOKINGS (34 bookings)
-- ★ Class 6 (capacity=2): FULLY BOOKED 2/2
-- ★ Class 8 (capacity=3): FULLY BOOKED 3/3
-- ★ Cancelled bookings in class 1, 2, 5 (don't count toward seats)
-- ============================================================
INSERT INTO booking (member_id, class_id, book_date, status) VALUES
(1, 1, '2026-03-01', 'booked'),
(2, 1, '2026-03-01', 'booked'),
(4, 1, '2026-03-01', 'booked'),
(6, 1, '2026-03-02', 'booked'),
(8, 1, '2026-03-02', 'booked'),
(10, 1, '2026-03-02', 'cancelled'),
(3, 2, '2026-03-02', 'booked'),
(5, 2, '2026-03-02', 'booked'),
(7, 2, '2026-03-03', 'booked'),
(9, 2, '2026-03-03', 'booked'),
(11, 2, '2026-03-03', 'cancelled'),
(12, 3, '2026-03-03', 'booked'),
(13, 3, '2026-03-04', 'booked'),
(14, 3, '2026-03-04', 'booked'),
(15, 3, '2026-03-04', 'booked'),
(2, 4, '2026-03-04', 'booked'),
(4, 4, '2026-03-05', 'booked'),
(6, 4, '2026-03-05', 'booked'),
(8, 4, '2026-03-05', 'booked'),
(10, 4, '2026-03-05', 'booked'),
(12, 4, '2026-03-06', 'booked'),
(16, 5, '2026-03-06', 'booked'),
(17, 5, '2026-03-06', 'booked'),
(18, 5, '2026-03-06', 'booked'),
(19, 5, '2026-03-07', 'booked'),
(20, 5, '2026-03-07', 'cancelled'),
(1, 6, '2026-03-07', 'booked'),
(3, 6, '2026-03-07', 'booked'),
(14, 7, '2026-03-08', 'booked'),
(16, 7, '2026-03-08', 'booked'),
(18, 7, '2026-03-08', 'booked'),
(5, 8, '2026-03-08', 'booked'),
(7, 8, '2026-03-09', 'booked'),
(9, 8, '2026-03-09', 'booked');