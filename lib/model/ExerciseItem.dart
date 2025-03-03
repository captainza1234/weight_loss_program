class ExerciseItem {
  final int keyID;  // ID ที่ไม่ซ้ำกัน
  final String exerciseType;  // ประเภทการออกกำลังกาย
  final int duration;  // ระยะเวลา (นาที)
  final double caloriesBurned;  // แคลอรี่ที่เผาผลาญ
  final DateTime? date;  // วันที่ออกกำลังกาย

  // คอนสตรัคเตอร์
  ExerciseItem({
    required this.keyID,
    required this.exerciseType,
    required this.duration,
    required this.caloriesBurned,
    required this.date,
  });

  // ฟังก์ชันแปลงข้อมูลจาก Map เป็น ExerciseItem
  factory ExerciseItem.fromMap(Map<String, dynamic> map) {
    return ExerciseItem(
      keyID: map['keyID'],  // รับ keyID จากฐานข้อมูล
      exerciseType: map['exerciseType'],
      duration: map['duration'],
      caloriesBurned: map['caloriesBurned'],
      date: DateTime.parse(map['date']),  // แปลงวันที่จาก String
    );
  }

  // ฟังก์ชันแปลงข้อมูลจาก ExerciseItem เป็น Map
  Map<String, dynamic> toMap() {
    return {
      'keyID': keyID,  // ส่งค่า keyID
      'exerciseType': exerciseType,
      'duration': duration,
      'caloriesBurned': caloriesBurned,
      'date': date?.toIso8601String(),  // แปลงวันที่เป็น String
    };
  }

  // ฟังก์ชันที่ใช้สำหรับสร้างข้อมูลใหม่และให้ค่า keyID อัตโนมัติ
  static ExerciseItem createNew({
    required String exerciseType,
    required int duration,
    required double caloriesBurned,
  }) {
    return ExerciseItem(
      keyID: DateTime.now().millisecondsSinceEpoch,  // สร้าง keyID จากเวลาปัจจุบัน
      exerciseType: exerciseType,
      duration: duration,
      caloriesBurned: caloriesBurned,
      date: DateTime.now(),  // ใช้วันที่ปัจจุบัน
    );
  }
}
