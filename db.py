# ============================================================
#  db.py — ชั้นติดต่อฐานข้อมูล  ★★★ นิสิตเขียน SQL ในไฟล์นี้ ★★★
#  มองหาคำว่า  # TODO  ทุกฟังก์ชัน — ใช้ %s เป็น placeholder เสมอ (กัน SQL injection)
# ============================================================
import mysql.connector
import config


def get_connection():
    return mysql.connector.connect(
        host=config.DB_HOST, user=config.DB_USER, password=config.DB_PASSWORD,
        database=config.DB_NAME, port=config.DB_PORT)


def run_query(sql, params=None):
    """รัน SELECT คืนผลเป็น list ของ dict"""
    conn = get_connection(); cur = conn.cursor(dictionary=True)
    cur.execute(sql, params or ()); rows = cur.fetchall()
    cur.close(); conn.close(); return rows


def run_command(sql, params=None):
    """รัน INSERT / UPDATE / DELETE แล้ว commit"""
    conn = get_connection(); cur = conn.cursor()
    cur.execute(sql, params or ()); conn.commit()
    out = {"new_id": cur.lastrowid, "affected": cur.rowcount}
    cur.close(); conn.close(); return out


def blank_to_none(value):
    """ช่องที่ไม่ได้กรอกในฟอร์มจะส่งมาเป็น "" — แปลงเป็น None (= NULL ใน SQL)
    ใช้กับคอลัมน์ที่ว่างได้ เช่น return_date, paid_date  เพราะ MySQL ไม่รับ '' เป็น DATE"""
    return None if value in ("", None) else value


def _todo(name):
    raise NotImplementedError(f"TODO: ยังไม่ได้เขียนฟังก์ชัน {name} ใน db.py")


# ---------- สมาชิก (member) ----------
def search_members(filters):
    """ค้นหา สมาชิก ตามเงื่อนไข (name, gender, package_type)
    คำใบ้: เริ่มจาก sql = "SELECT * FROM member WHERE 1=1"
    แล้วต่อเงื่อนไขเฉพาะ filter ที่มีค่า (ข้อความใช้ LIKE %s, อื่น ๆ ใช้ = %s)"""
    # TODO: เขียน SQL ค้นหาแบบยืดหยุ่นตาม filters (ใช้ %s เสมอ)
    _todo("search_members")


def get_member(member_id):
    """ดึง สมาชิก 1 รายการตาม member_id (ใช้ตอนเปิดฟอร์มแก้ไข)"""
    # TODO: SELECT * FROM member WHERE member_id = %s แล้วคืนแถวเดียว
    _todo("get_member")


def create_member(data):
    """เพิ่ม สมาชิก ใหม่ — data มีคีย์: name, gender, join_date, package_type"""
    # TODO: INSERT INTO member (...) VALUES (%s, ...)
    _todo("create_member")


def update_member(member_id, data):
    """แก้ไข สมาชิก ตาม member_id"""
    # TODO: UPDATE member SET ... WHERE member_id=%s
    _todo("update_member")


def delete_member(member_id):
    """ลบ สมาชิก ตาม member_id"""
    # TODO: DELETE FROM member WHERE member_id=%s
    _todo("delete_member")

# ---------- คลาสเรียน (gym_class) ----------
def search_classes(filters):
    """ค้นหา คลาสเรียน ตามเงื่อนไข (name, room)
    ต้องแสดงคอลัมน์: class_id, name, trainer_id, room, capacity, schedule_time, seats_left (ที่นั่งว่าง)
    คำใบ้ (หลักเดียวกับคอลัมน์ available ของระบบห้องสมุด):
      - seats_left ไม่ได้เก็บเป็นคอลัมน์ → คำนวณ = capacity − จำนวนการจองที่ status = 'booked'
        (การจองที่ยกเลิกแล้วไม่นับ)
      - LEFT JOIN กับ subquery ที่นับการจองของแต่ละ class_id (... WHERE status = 'booked' GROUP BY class_id)
        แล้วใช้ IFNULL(..., 0) เพราะคลาสที่ยังไม่มีคนจองจะได้ NULL
      - name/room ใช้ LIKE %s"""
    # TODO: เขียน SQL ค้นหาแบบยืดหยุ่นตาม filters (ใช้ %s เสมอ)
    _todo("search_classes")


def get_class(class_id):
    """ดึง คลาสเรียน 1 รายการตาม class_id (ใช้ตอนเปิดฟอร์มแก้ไข)"""
    # TODO: SELECT * FROM gym_class WHERE class_id = %s แล้วคืนแถวเดียว
    _todo("get_class")


def create_class(data):
    """เพิ่ม คลาสเรียน ใหม่ — data มีคีย์: name, trainer_id, room, capacity, schedule_time"""
    # TODO: INSERT INTO gym_class (...) VALUES (%s, ...)
    _todo("create_class")


def update_class(class_id, data):
    """แก้ไข คลาสเรียน ตาม class_id"""
    # TODO: UPDATE gym_class SET ... WHERE class_id=%s
    _todo("update_class")


def delete_class(class_id):
    """ลบ คลาสเรียน ตาม class_id"""
    # TODO: DELETE FROM gym_class WHERE class_id=%s
    _todo("delete_class")

# ---------- การจอง (booking) ----------
def search_bookings(filters):
    """ค้นหา การจอง ตามเงื่อนไข (member_id, class_id, status)
    คำใบ้: เริ่มจาก sql = "SELECT * FROM booking WHERE 1=1"
    แล้วต่อเงื่อนไขเฉพาะ filter ที่มีค่า (ข้อความใช้ LIKE %s, อื่น ๆ ใช้ = %s)"""
    # TODO: เขียน SQL ค้นหาแบบยืดหยุ่นตาม filters (ใช้ %s เสมอ)
    _todo("search_bookings")


def get_booking(booking_id):
    """ดึง การจอง 1 รายการตาม booking_id (ใช้ตอนเปิดฟอร์มแก้ไข)"""
    # TODO: SELECT * FROM booking WHERE booking_id = %s แล้วคืนแถวเดียว
    _todo("get_booking")


def check_can_book(member_id, class_id, booking_id=None):
    """ตรวจก่อนบันทึกการจอง — ถ้าไม่ผ่านให้ raise ValueError("ข้อความ")
    (หน้าเว็บจะแสดงข้อความนั้นเป็น alert ให้ผู้ใช้เห็น และไม่บันทึกข้อมูล)
    1) คลาสต้องมีอยู่จริง และยังมีที่นั่งว่าง (seats_left > 0)
       seats_left = capacity − (SELECT COUNT(*) FROM booking
                                WHERE class_id = %s AND status = 'booked' AND booking_id <> %s)
    2) ห้ามจองซ้ำ: สมาชิกคนนี้มีการจอง 'booked' ในคลาสนี้อยู่แล้ว (ไม่นับแถวตัวเอง)
    ★ ตอนเพิ่มใหม่ booking_id เป็น None → ส่ง 0 แทน (booking_id or 0) จะได้ไม่ตรงกับแถวไหนเลย
    ตัวอย่าง: raise ValueError("คลาสนี้เต็มแล้ว")"""
    # TODO: เขียนการตรวจ 2 ข้อตามคำใบ้
    _todo("check_can_book")


def create_booking(data):
    """เพิ่ม การจอง ใหม่ — data มีคีย์: member_id, class_id, book_date, status
    คำใบ้:
      1) ถ้า status = 'booked' → เรียก check_can_book(data["member_id"], data["class_id"]) ก่อน
      2) INSERT INTO booking (...) VALUES (%s, ...)"""
    # TODO: เขียนตามคำใบ้
    _todo("create_booking")


def update_booking(booking_id, data):
    """แก้ไข การจอง ตาม booking_id
    คำใบ้:
      1) ถ้า status ใหม่ = 'booked' และ (เดิมเคย cancelled หรือเปลี่ยนคลาส/สมาชิก)
         → check_can_book(data["member_id"], data["class_id"], booking_id)
         (ดูค่าเดิมด้วย get_booking — การยกเลิกจองไม่ต้องตรวจ)
      2) UPDATE booking SET ... WHERE booking_id=%s"""
    # TODO: เขียนตามคำใบ้
    _todo("update_booking")


def delete_booking(booking_id):
    """ลบ การจอง ตาม booking_id"""
    # TODO: DELETE FROM booking WHERE booking_id=%s
    _todo("delete_booking")


# ============================================================
#  REPORT (รายงาน — ใช้ JOIN + GROUP BY + subquery)
#  ★ ชื่อคอลัมน์ใน SELECT จะกลายเป็นหัวตารางบนเว็บ — ใช้ AS 'ชื่อภาษาไทย' ได้
# ============================================================
def report_summary():
    """ตัวเลขสรุปบนการ์ด dashboard — คืน dict {ชื่อการ์ด: ตัวเลข}  (1 คีย์ = 1 การ์ด)
    ตอนนี้ยังไม่ได้เขียน SQL → คืนค่า None ทุกการ์ด หน้าเว็บจึงแสดง "—" รอไว้
    ★ งานของนิสิต: เขียน SQL ตามตัวอย่างด้านล่าง (1 คอลัมน์ใน SELECT = 1 การ์ด
      ชื่อหลัง AS = ข้อความใต้ตัวเลข) แล้วลบ return {...} ชุดล่างสุดทิ้ง
    ★ การ์ด "คิดเพิ่มเอง" 2 ใบ: ตั้งชื่อการ์ดใหม่ แล้วเขียน SQL เอง
    ★ ผลรวมเงินใช้ IFNULL(SUM(...), 0) — ถ้ายังไม่มีข้อมูล SUM จะได้ NULL"""
    # ---- ตัวอย่างเมื่อเขียน SQL แล้ว (เอา # ข้างหน้าออก แล้วเติมให้ครบทุกการ์ด) ----
    # sql = """SELECT
    #            (SELECT COUNT(*) FROM ...) AS 'สมาชิก',
    #            (SELECT ...)               AS 'คลาส',
    #            ...
    #          """
    # return run_query(sql)[0]      ← [0] = เอาแถวแรก (ผลมีแถวเดียว) ได้เป็น dict

    # TODO: ระหว่างที่ยังไม่ได้เขียน SQL คืนค่า None ให้การ์ดแสดง "—" รอไว้
    return {
        "สมาชิก":         None,   # (SELECT COUNT(*) FROM member)
        "คลาส":           None,   # นับคลาสทั้งหมด
        "เทรนเนอร์":      None,   # นับเทรนเนอร์ทั้งหมด
        "การจอง":         None,   # นับเฉพาะการจองที่ status = 'booked'
        "คิดเพิ่มเอง 1":  None,   # ตั้งชื่อการ์ดใหม่ + เขียน SQL เอง
        "คิดเพิ่มเอง 2":  None,   # ตั้งชื่อการ์ดใหม่ + เขียน SQL เอง
    }

def report_popular_classes():
    """📈 คลาสยอดนิยม (Most Booked)
    คำใบ้: JOIN booking→gym_class, GROUP BY class, COUNT, ORDER BY DESC, LIMIT 5"""
    # TODO: เขียน SQL รายงานนี้ (เขียน JOIN แบบ explicit INNER JOIN ... ON ...)
    _todo("report_popular_classes")

def report_trainers_above_avg():
    """🏅 เทรนเนอร์ที่มีผู้จองมากกว่าค่าเฉลี่ย (Above Average)
    คำใบ้: JOIN booking→gym_class→trainer, GROUP BY trainer, HAVING COUNT(*) > (subquery AVG)"""
    # TODO: เขียน SQL รายงานนี้ (เขียน JOIN แบบ explicit INNER JOIN ... ON ...)
    _todo("report_trainers_above_avg")

def report_class_equipment():
    """🧰 อุปกรณ์ที่ใช้ในแต่ละคลาส (Join 3 Tables)
    คำใบ้: JOIN class_equipment→gym_class, class_equipment→equipment"""
    # TODO: เขียน SQL รายงานนี้ (เขียน JOIN แบบ explicit INNER JOIN ... ON ...)
    _todo("report_class_equipment")

# ============================================================
#  รายการรายงานที่แสดงบนหน้า /report  (เรียงตามลำดับที่แสดง)
#  ★ วิธีเพิ่มรายงานใหม่ (ไม่ต้องแก้ไฟล์อื่น):
#    1) เขียนฟังก์ชัน report_xxx() ด้านบน ให้ return run_query(sql)
#    2) เพิ่ม 1 บรรทัดในรายการนี้:  ("ชื่อใน-url", "หัวข้อที่แสดง", ชื่อฟังก์ชัน)
#  ★ รายการนี้ต้องอยู่ท้ายไฟล์ (หลังฟังก์ชันทั้งหมด) ไม่งั้น Python หาชื่อฟังก์ชันไม่เจอ
#  ★ ห้ามตั้งชื่อ url ว่า "summary" (ใช้แล้วสำหรับการ์ดสรุป)
# ============================================================
REPORTS = [
    ("popular-classes", "📈 คลาสยอดนิยม (Most Booked)",                            report_popular_classes),
    ("top-trainers",    "🏅 เทรนเนอร์ที่มีผู้จองมากกว่าค่าเฉลี่ย (Above Average)", report_trainers_above_avg),
    ("class-equipment", "🧰 อุปกรณ์ที่ใช้ในแต่ละคลาส (Join 3 Tables)",             report_class_equipment),
    # ("my-report", "📋 รายงานของฉัน", report_my_report),   ← ตัวอย่างการเพิ่มรายงานที่ 4
]
