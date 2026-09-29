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
    join_date DATE NOT NULL,
    package_type ENUM('basic', 'premium') NOT NULL
    -- TODO: name, gender, join_date, package_type
);
CREATE TABLE trainer (
    trainer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialty VARCHAR(100),
    phone VARCHAR(20)
    -- TODO: name, specialty, phone
);
CREATE TABLE gym_class (          -- 1:M จาก trainer
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    trainer_id INT,
    name VARCHAR(100) NOT NULL,
    room VARCHAR(30) NOT NULL,
    capacity INT NOT NULL,
    schedule_time VARCHAR(50) NOT NULL,

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
-- 1. MEMBERS (male / female)
-- ============================================================
INSERT INTO member (name, gender, join_date, package_type) VALUES
('John Miller', 'Male', '2026-01-05', 'premium'),
('Sarah Connor', 'Female', '2026-01-08', 'basic'),
('Michael Chang', 'Male', '2026-01-12', 'premium'),
('Emily Watson', 'Female', '2026-01-15', 'basic'),
('David Beckham', 'Male', '2026-01-20', 'premium'),
('Jessica Alba', 'Female', '2026-01-25', 'basic'),
('Robert Downey', 'Male', '2026-02-01', 'premium'),
('Emma Stone', 'Female', '2026-02-03', 'basic'),
('Chris Evans', 'Male', '2026-02-10', 'premium'),
('Scarlett Johansson', 'Female', '2026-02-14', 'premium'),
('Tom Holland', 'Male', '2026-02-18', 'basic'),
('Zendaya Coleman', 'Female', '2026-02-22', 'premium'),
('Bruce Wayne', 'Male', '2026-03-01', 'premium'),
('Diana Prince', 'Female', '2026-03-02', 'premium'),
('Clark Kent', 'Male', '2026-03-05', 'basic'),
('Natasha Romanoff', 'Female', '2026-03-08', 'basic'),
('Peter Parker', 'Male', '2026-03-10', 'basic'),
('Tony Stark', 'Male', '2026-03-12', 'premium'),
('Wanda Maximoff', 'Female', '2026-03-15', 'premium'),
('Steve Rogers', 'Male', '2026-03-18', 'basic');

-- ============================================================
-- 2. TRAINERS (6 Trainers with diverse specialties)
-- ============================================================
INSERT INTO trainer (name, specialty, phone) VALUES
('Alex Hunter', 'Bodybuilding & Powerlifting', '081-555-0101'),
('Sophia Turner', 'Yoga & Pilates', '082-555-0102'),
('Marcus Vance', 'CrossFit & HIIT', '083-555-0103'),
('Elena Rostova', 'Zumba & Cardio Dance', '084-555-0104'),
('Liam Cooper', 'Spinning & Cycling', '085-555-0105'),
('Chloe Bennett', 'Boxing & Self Defense', '086-555-0106');

-- ============================================================
-- 3. GYM CLASSES (8 Classes)
-- ★ Class 6 (Powerlifting Masterclass) capacity = 2 (จะถูกจองเต็ม 2/2)
-- ★ Class 8 (Elite Boxing Camp) capacity = 3 (จะถูกจองเต็ม 3/3)
-- ============================================================
INSERT INTO gym_class (trainer_id, name, room, capacity, schedule_time) VALUES
(2, 'Vinyasa Flow Yoga', 'Studio A', 15, '08:00 - 09:00'),
(1, 'Hypertrophy Upper Body', 'Weight Room', 12, '10:00 - 11:00'),
(3, 'Extreme HIIT Circuit', 'Functional Zone', 10, '12:00 - 13:00'),
(4, 'Zumba Dance Fiesta', 'Studio B', 20, '17:00 - 18:00'),
(5, 'Sprint Spin Cycling', 'Spin Studio', 12, '18:00 - 19:00'),
(1, 'Powerlifting Masterclass', 'Power Cage 1', 2, '19:00 - 20:00'),
(2, 'Core Pilates Rehab', 'Studio A', 8, '10:00 - 11:00'),
(6, 'Elite Boxing Camp', 'Ring Studio', 3, '16:00 - 17:00');

-- ============================================================
-- 4. EQUIPMENT (10 Items across various zones)
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
-- 5. CLASS EQUIPMENT (Multi-item setup per class)
-- ============================================================
INSERT INTO class_equipment (class_id, equip_id, quantity) VALUES
(1, 1, 15), -- Vinyasa Flow Yoga: 15 Yoga Mats
(1, 10, 8), -- Vinyasa Flow Yoga: 8 Foam Rollers
(2, 2, 12), -- Hypertrophy: 12 Dumbbell Pairs
(3, 3, 10), -- Extreme HIIT: 10 Kettlebells
(3, 6, 10), -- Extreme HIIT: 10 Resistance Bands
(4, 5, 20), -- Zumba Fiesta: 20 Step Platforms
(5, 7, 12), -- Spin Cycling: 12 Spin Bikes
(6, 4, 2),  -- Powerlifting: 2 Olympic Barbells
(7, 1, 8),  -- Core Pilates: 8 Yoga Mats
(7, 10, 8), -- Core Pilates: 8 Foam Rollers
(8, 8, 6),  -- Boxing Camp: 6 Pairs Boxing Gloves
(8, 9, 3);  -- Boxing Camp: 3 Heavy Punching Bags

-- ============================================================
-- 6. BOOKINGS (35 Bookings)
-- Includes:
-- - FULL CLASS #6: capacity 2, booked 2 (Members 1, 3)
-- - FULL CLASS #8: capacity 3, booked 3 (Members 5, 7, 9)
-- - Multiple cancelled bookings for testing seat calculation
-- ============================================================
INSERT INTO booking (member_id, class_id, book_date, status) VALUES
-- Class 1 (Yoga): 5 booked, 1 cancelled
(1, 1, '2026-03-01', 'booked'),
(2, 1, '2026-03-01', 'booked'),
(4, 1, '2026-03-01', 'booked'),
(6, 1, '2026-03-02', 'booked'),
(8, 1, '2026-03-02', 'booked'),
(10, 1, '2026-03-02', 'cancelled'),

-- Class 2 (Upper Body): 4 booked, 1 cancelled
(3, 2, '2026-03-02', 'booked'),
(5, 2, '2026-03-02', 'booked'),
(7, 2, '2026-03-03', 'booked'),
(9, 2, '2026-03-03', 'booked'),
(11, 2, '2026-03-03', 'cancelled'),

-- Class 3 (HIIT): 4 booked
(12, 3, '2026-03-03', 'booked'),
(13, 3, '2026-03-04', 'booked'),
(14, 3, '2026-03-04', 'booked'),
(15, 3, '2026-03-04', 'booked'),

-- Class 4 (Zumba): 6 booked
(2, 4, '2026-03-04', 'booked'),
(4, 4, '2026-03-05', 'booked'),
(6, 4, '2026-03-05', 'booked'),
(8, 4, '2026-03-05', 'booked'),
(10, 4, '2026-03-05', 'booked'),
(12, 4, '2026-03-06', 'booked'),

-- Class 5 (Spinning): 4 booked, 1 cancelled
(16, 5, '2026-03-06', 'booked'),
(17, 5, '2026-03-06', 'booked'),
(18, 5, '2026-03-06', 'booked'),
(19, 5, '2026-03-07', 'booked'),
(20, 5, '2026-03-07', 'cancelled'),

-- Class 6 (Powerlifting - Capacity = 2) ★ FULLY BOOKED (2/2) ★
(1, 6, '2026-03-07', 'booked'),
(3, 6, '2026-03-07', 'booked'),

-- Class 7 (Pilates): 3 booked
(14, 7, '2026-03-08', 'booked'),
(16, 7, '2026-03-08', 'booked'),
(18, 7, '2026-03-08', 'booked'),

-- Class 8 (Boxing - Capacity = 3) ★ FULLY BOOKED (3/3) ★
(5, 8, '2026-03-08', 'booked'),
(7, 8, '2026-03-09', 'booked'),
(9, 8, '2026-03-09', 'booked');