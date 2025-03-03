import 'package:account/model/ExerciseItem.dart';
import 'package:account/provider/ExerciseProvider.dart';
import 'package:flutter/material.dart';
import 'formScreen.dart';
import 'package:account/editScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) {
            return ExerciseProvider();
          })
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MyHomePage(title: 'Flutter Demo Home Page'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // เรียกใช้ provider เพื่อโหลดข้อมูลจากฐานข้อมูล
    ExerciseProvider provider = Provider.of<ExerciseProvider>(context, listen: false);
    provider.initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: Consumer<ExerciseProvider>(
        builder: (context, provider, child) {
          int itemCount = provider.exercises.length;
          print("Number of exercises: $itemCount"); // ตรวจสอบจำนวนข้อมูล
          if (itemCount == 0) {
            return Center(
              child: Text(
                'ไม่มีการบันทึกการออกกำลังกาย',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: itemCount,
              itemBuilder: (context, int index) {
                ExerciseItem data = provider.exercises[index];
                return Dismissible(
                  key: Key(data.keyID.toString()),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) {
                    provider.deleteExercise(data);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      title: Text(
                        data.exerciseType,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'เวลา: ${data.duration} นาที\nเผาผลาญ: ${data.caloriesBurned} แคลอรี่\nวันที่บันทึก: ${data.date?.toIso8601String()}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        child: FittedBox(
                          child: Text(data.caloriesBurned.toString(), style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('ยืนยันการลบ'),
                                content: Text('คุณต้องการลบรายการการออกกำลังกายนี้ใช่หรือไม่?'),
                                actions: [
                                  TextButton(
                                    child: Text('ยกเลิก'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('ลบรายการ'),
                                    onPressed: () {
                                      provider.deleteExercise(data);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return EditScreen(item: data);
                        }));
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormScreen();
          }));
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
