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
    gender ENUM('male', 'female') NOT NULL,
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
    room VARCHAR(10) NOT NULL,
    capacity INT NOT NULL,
    schedule_time DATE NOT NULL,

    FOREIGN KEY (trainer_id) REFERENCES trainer(trainer_id)
    -- TODO: trainer_id (FK), name, room, capacity, schedule_time
    -- ★ ไม่ต้องมีคอลัมน์ที่นั่งว่าง — คำนวณจาก capacity − การจอง (ดู search_classes ใน db.py)
);
CREATE TABLE booking (            -- M:N: member × gym_class
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    
    -- TODO: member_id (FK), class_id (FK), book_date, status ENUM('booked','cancelled')
);
CREATE TABLE equipment (
    equip_id INT AUTO_INCREMENT PRIMARY KEY
    -- TODO: name, zone, status
);
CREATE TABLE class_equipment (    -- M:N: gym_class × equipment
    -- TODO: class_id (FK), equip_id (FK), quantity ; PRIMARY KEY (class_id, equip_id)
    class_id INT, equip_id INT
);
-- TODO: INSERT ข้อมูลตัวอย่างทุกตาราง
--   ★ ควรมีคลาสที่ถูกจองเต็ม capacity อย่างน้อย 1 คลาส ไว้ทดสอบ "คลาสเต็มจองไม่ได้"
