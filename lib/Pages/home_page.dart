import 'package:fitness_tracker/Pages/workout_page.dart';
import 'package:fitness_tracker/components/heat_map.dart';
import 'package:fitness_tracker/data/workout_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final workoutNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  @override
  void dispose() {
    super.dispose();
    workoutNameController.dispose();
  }

  void createWorkout() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Create a Workout'),
              content: TextField(
                controller: workoutNameController,
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
    Provider.of<WorkoutData>(context, listen: false)
        .addWorkout(workoutNameController.text);

    Navigator.pop(context);
    clearText();
  }

  void cancel() {
    Navigator.pop(context);
    clearText();
  }

  void clearText() {
    workoutNameController.clear();
  }

  void gotoWorkoutPage(String workoutName) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WorkoutPage(
                workoutName: workoutName,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
        builder: (context, value, child) => Scaffold(
            appBar: AppBar(
              title: const Text('Fitness Tracker'),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: createWorkout,
              child: const Icon(Icons.add),
            ),
            body: ListView(
              children: [
                //? HEAT MAP
                MyHeatMap(
                  datasets: value.heatMapDataSet,
                  startDate: value.getStartDate(),
                ),

                //? WORKOUT LIST
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.getWorkoutList().length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(value.getWorkoutList()[index].name),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                          ),
                          onPressed: () => gotoWorkoutPage(
                              value.getWorkoutList()[index].name),
                        ),
                      );
                    }),
              ],
            )));
  }
}
