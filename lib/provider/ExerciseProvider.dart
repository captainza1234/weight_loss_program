import 'package:flutter/material.dart';
import 'package:account/model/ExerciseItem.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';  // นำเข้าเพิ่มเติม
import 'package:path_provider/path_provider.dart';  // สำหรับหาที่เก็บไฟล์
import 'package:path/path.dart';  // สำหรับการเชื่อมต่อ path

class ExerciseProvider extends ChangeNotifier {
  List<ExerciseItem> exercises = [];

  // ฟังก์ชันนี้ใช้เพื่อโหลดข้อมูลจากฐานข้อมูล
  Future<void> initData() async {
    final db = await _openDatabase();
    final store = intMapStoreFactory.store('exercises');
    final records = await store.find(db);
    exercises = records
        .map((record) => ExerciseItem.fromMap(record.value))
        .toList();
    notifyListeners(); // แจ้งให้ UI รีเฟรชข้อมูล
  }

  // ฟังก์ชันนี้ใช้เพื่อเพิ่มข้อมูล
  Future<void> addExercise(ExerciseItem item) async {
    final db = await _openDatabase();
    final store = intMapStoreFactory.store('exercises');
    await store.add(db, item.toMap());
    exercises.add(item); // เพิ่มข้อมูลใน list
    notifyListeners(); // แจ้งให้ UI รีเฟรชข้อมูล
  }

  // ฟังก์ชันนี้ใช้เพื่อลบข้อมูล
  Future<void> deleteExercise(ExerciseItem item) async {
    final db = await _openDatabase();
    final store = intMapStoreFactory.store('exercises');
    await store.delete(db, finder: Finder(filter: Filter.byKey(item.keyID)));
    exercises.removeWhere((e) => e.keyID == item.keyID); // ลบข้อมูลจาก list
    notifyListeners(); // แจ้งให้ UI รีเฟรชข้อมูล
  }

  // ฟังก์ชันนี้ใช้เพื่อเปิดฐานข้อมูล
  Future<Database> _openDatabase() async {
    final directory = await getApplicationDocumentsDirectory(); // ใช้ getApplicationDocumentsDirectory แทน
    final path = join(directory.path, 'exercise.db');
    final database = await databaseFactoryIo.openDatabase(path);
    return database;
  }
  Future<void> updateExercise(ExerciseItem item) async {
  final db = await _openDatabase();
  final store = intMapStoreFactory.store('exercises');
  
  // ใช้ Finder เพื่อหาข้อมูลที่จะอัพเดต
  await store.update(db, item.toMap(), finder: Finder(filter: Filter.byKey(item.keyID)));

  // อัพเดตข้อมูลใน List exercises
  int index = exercises.indexWhere((e) => e.keyID == item.keyID);
  if (index != -1) {
    exercises[index] = item;
  }
  notifyListeners(); // แจ้งให้ UI รีเฟรชข้อมูล
}

}
