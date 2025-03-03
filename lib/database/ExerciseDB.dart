import 'dart:io';
import 'package:account/model/ExerciseItem.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class ExerciseDB {
  String dbName;

  ExerciseDB({required this.dbName});

  Future<Database> openDatabase() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDir.path, dbName);

    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  Future<int> insertDatabase(ExerciseItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('exercise');
    Future<int> keyID = store.add(db, {
      'exerciseType': item.exerciseType,
      'duration': item.duration,
      'caloriesBurned': item.caloriesBurned,
      'date': item.date?.toIso8601String()
    });
    db.close();
    print("Inserted exercise with keyID: $keyID"); // ตรวจสอบว่าได้ keyID หรือไม่
    return keyID;
  }

  Future<List<ExerciseItem>> loadAllData() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('exercise');
    var snapshot = await store.find(db, finder: Finder(sortOrders: [SortOrder('date', false)]));

    List<ExerciseItem> exercises = [];
    for (var record in snapshot) {
      ExerciseItem item = ExerciseItem(
        keyID: record.key,
        exerciseType: record['exerciseType'].toString(),
        duration: int.parse(record['duration'].toString()),
        caloriesBurned: double.parse(record['caloriesBurned'].toString()),
        date: DateTime.parse(record['date'].toString())
      );
      exercises.add(item);
    }
    db.close();
    print("Loaded exercises from DB: $exercises"); // ตรวจสอบข้อมูลที่โหลด
    return exercises;
  }

  deleteData(ExerciseItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('exercise');
    store.delete(db, finder: Finder(filter: Filter.equals(Field.key, item.keyID)));
    db.close();
  }

  updateData(ExerciseItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('exercise');
    store.update(
      db,
      {
        'exerciseType': item.exerciseType,
        'duration': item.duration,
        'caloriesBurned': item.caloriesBurned,
        'date': item.date?.toIso8601String()
      },
      finder: Finder(filter: Filter.equals(Field.key, item.keyID))
    );
    db.close();
  }
}
