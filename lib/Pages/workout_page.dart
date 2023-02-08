import 'package:fitness_tracker/components/exercise_tile.dart';
import 'package:fitness_tracker/data/workout_data.dart';
import 'package:fitness_tracker/models/exercise_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    exerciseNameController.dispose();
    weightController.dispose();
    repsController.dispose();
    setsController.dispose();
  }

  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  void createExercises() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add Exercise'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: exerciseNameController,
                  ),
                  TextField(
                    controller: weightController,
                  ),
                  TextField(
                    controller: repsController,
                  ),
                  TextField(
                    controller: setsController,
                  ),
                ],
              ),
              actions: [
                MaterialButton(
                  onPressed: save,
                  child: const Text('save'),
                ),
                MaterialButton(
                  onPressed: cancel,
                  child: const Text('cancel'),
                )
              ],
            ));
  }

  void save() {
    Provider.of<WorkoutData>(context, listen: false).addExercise(
      widget.workoutName,
      exerciseNameController.text,
      weightController.text,
      repsController.text,
      setsController.text,
    );

    Navigator.pop(context);
    clearText();
  }

  void cancel() {
    Navigator.pop(context);
    clearText();
  }

  void clearText() {
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(widget.workoutName),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createExercises,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.lengthOfExercises(widget.workoutName),
          itemBuilder: (context, index) {
            ExerciseModel exerciseModel =
                value.getRelevantWorkout(widget.workoutName).exercises[index];
            return ExerciseTile(
              exerciseName: exerciseModel.name,
              weight: exerciseModel.weight,
              reps: exerciseModel.reps,
              sets: exerciseModel.sets,
              isDone: exerciseModel.isDone,
              onChanged: (val) =>
                  onCheckBoxChanged(widget.workoutName, exerciseModel.name),
            );
          },
        ),
      ),
    );
  }
}
