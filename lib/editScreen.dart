import 'package:account/model/ExerciseItem.dart';
import 'package:account/provider/ExerciseProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  ExerciseItem item;

  EditScreen({super.key, required this.item});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormState>();
  final exerciseTypeController = TextEditingController();
  final durationController = TextEditingController();
  final caloriesBurnedController = TextEditingController();

  @override
  void initState() {
    super.initState();
    exerciseTypeController.text = widget.item.exerciseType;
    durationController.text = widget.item.duration.toString();
    caloriesBurnedController.text = widget.item.caloriesBurned.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Edit Exercise'),
      ),
      body: Form(
        key: formKey,
        child: Column(
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
                    return "กรุณาป้อนระยะเวลาที่มากกว่า 0";
                  }
                } catch (e) {
                  return "กรุณาป้อนเป็นตัวเลขเท่านั้น";
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'แคลอรี่ที่เผาผลาญ'),
              keyboardType: TextInputType.number,
              controller: caloriesBurnedController,
              validator: (String? value) {
                try {
                  double calories = double.parse(value!);
                  if (calories <= 0) {
                    return "กรุณาป้อนแคลอรี่ที่มากกว่า 0";
                  }
                } catch (e) {
                  return "กรุณาป้อนเป็นตัวเลขเท่านั้น";
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // ทำการแก้ไขข้อมูล
                  var provider = Provider.of<ExerciseProvider>(context, listen: false);

                  ExerciseItem item = ExerciseItem(
                    keyID: widget.item.keyID,
                    exerciseType: exerciseTypeController.text,
                    duration: int.parse(durationController.text),
                    caloriesBurned: double.parse(caloriesBurnedController.text),
                    date: widget.item.date,
                  );

                  provider.updateExercise(item);

                  // ปิดหน้าจอ
                  Navigator.pop(context);
                }
              },
              child: const Text('แก้ไขข้อมูล'),
            ),
          ],
        ),
      ),
    );
  }
}
