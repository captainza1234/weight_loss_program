import 'package:account/model/ExerciseItem.dart';
import 'package:account/provider/ExerciseProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();
  final exerciseTypeController = TextEditingController();
  final durationController = TextEditingController();
  final caloriesBurnedController = TextEditingController();

  String weeklyRecommendation = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('กรอกข้อมูลการออกกำลังกาย'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'ประเภทการออกกำลังกาย'),
                autofocus: true,
                controller: exerciseTypeController,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "กรุณาป้อนประเภทการออกกำลังกาย";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'ระยะเวลา (นาที)'),
                keyboardType: TextInputType.number,
                controller: durationController,
                validator: (String? value) {
                  try {
                    int duration = int.parse(value!);
                    if (duration <= 0) {
                      return "กรุณาป้อนระยะเวลาเป็นตัวเลขที่มากกว่า 0";
                    }
                  } catch (e) {
                    return "กรุณาป้อนเป็นตัวเลขเท่านั้น";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'แคลอรี่ที่ต้องการลด'),
                keyboardType: TextInputType.number,
                controller: caloriesBurnedController,
                validator: (String? value) {
                  try {
                    double calories = double.parse(value!);
                    if (calories <= 0) {
                      return "กรุณาป้อนแคลอรี่ที่เผาผลาญที่มากกว่า 0";
                    }
                  } catch (e) {
                    return "กรุณาป้อนเป็นตัวเลขเท่านั้น";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text(
                'คำแนะนำสำหรับสัปดาห์นี้:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                weeklyRecommendation,
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // ทำการเพิ่มข้อมูล
                    var provider = Provider.of<ExerciseProvider>(context, listen: false);

                    // สร้าง ExerciseItem ใหม่โดยใช้ createNew
                    ExerciseItem item = ExerciseItem.createNew(
                      exerciseType: exerciseTypeController.text,
                      duration: int.parse(durationController.text),
                      caloriesBurned: double.parse(caloriesBurnedController.text),
                    );

                    // คำนวณคำแนะนำสำหรับสัปดาห์นี้
                    setState(() {
                      weeklyRecommendation = _generateWeeklyRecommendation(item.caloriesBurned);
                    });

                    // เพิ่มข้อมูลลงใน provider
                    provider.addExercise(item);

                    // ปิดหน้าจอ
                    Navigator.pop(context);
                  }
                },
                child: const Text('เพิ่มข้อมูล'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ฟังก์ชั่นคำนวณคำแนะนำสำหรับสัปดาห์นี้
  String _generateWeeklyRecommendation(double caloriesBurned) {
    if (caloriesBurned < 200) {
      return "คุณอาจต้องการออกกำลังกายเพิ่มเติมเพื่อให้บรรลุเป้าหมายการลดน้ำหนักในสัปดาห์นี้";
    } else if (caloriesBurned < 500) {
      return "ดีมาก! คุณกำลังก้าวไปในทางที่ดีในการลดน้ำหนัก";
    } else {
      return "ยอดเยี่ยม! คุณกำลังก้าวข้ามเป้าหมายที่ตั้งไว้";
    }
  }
}
