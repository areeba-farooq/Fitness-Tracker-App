import 'package:fitness_tracker/data/date_time.dart';
import 'package:fitness_tracker/database/database.dart';
import 'package:fitness_tracker/models/exercise_model.dart';
import 'package:fitness_tracker/models/workout_model.dart';
import 'package:flutter/material.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();

  List<WorkoutModel> workoutDataList = [
    WorkoutModel(name: 'Belly', exercises: [
      ExerciseModel(
        name: 'Lower belly',
        weight: '60',
        reps: '23',
        sets: '3',
      )
    ])
  ];

  //*****************IF ALREADY EXISTS WORKOUTS******************//
  void initializeWorkoutList() {
    if (db.dataExists()) {
      workoutDataList = db.readDB(); //we should read from database
    } else {
      //first time user has used the app
      db.saveToDB(workoutDataList);
    }

    loadHeatMap();
  }

  //************GETTING LIST OF WORKOUTS ******************//
  List<WorkoutModel> getWorkoutList() {
    return workoutDataList;
  }

  //************GETTING LENGTH OF EXERCISES IN WORKOUT ******************//
  int lengthOfExercises(String workoutName) {
    WorkoutModel relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.length;
  }

  //************ADDING WORKOUTS ******************//
  void addWorkout(String name) {
    workoutDataList.add(
      WorkoutModel(
        name: name,
        exercises: [],
      ),
    );
    notifyListeners();
    db.saveToDB(workoutDataList);
  }

  //************ADD AND EXERCISE TO WORKOUTS ******************//
  void addExercise(
    String workoutName,
    String exerciseName,
    String weight,
    String reps,
    String sets,
  ) {
    //?find the relevent workout
    WorkoutModel relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(
      ExerciseModel(
        name: exerciseName,
        weight: weight,
        reps: reps,
        sets: sets,
      ),
    );
    notifyListeners();
    db.saveToDB(workoutDataList);
  }

  //************CHECKING OFF THE EXERCISES******************//
  void checkOffExercise(String workoutName, String exerciseName) {
    ExerciseModel relevantExercises =
        getRelevantExercise(workoutName, exerciseName);

    relevantExercises.isDone = !relevantExercises.isDone;
    notifyListeners();
    db.saveToDB(workoutDataList);
    loadHeatMap();
  }

  //************RETURNING RELEVANT LIST OF WORKOUTS ******************//
  WorkoutModel getRelevantWorkout(String workoutName) {
    WorkoutModel relevantWorkout =
        workoutDataList.firstWhere((workout) => workout.name == workoutName);
    return relevantWorkout;
  }

  //************RETURNING RELEVANT LIST OF EXERCISES ******************//
  ExerciseModel getRelevantExercise(String workoutName, String exerciseName) {
    WorkoutModel relevantWorkout = getRelevantWorkout(workoutName);

    ExerciseModel relevantExercise = relevantWorkout.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }

//******GET START DATE***********//
  String getStartDate() {
    return db.getStartDate();
  }

  Map<DateTime, int> heatMapDataSet = {};

  //******HEAT MAP LOADER***********//
  void loadHeatMap() {
    DateTime startDate = createDateTimeObj(getStartDate());

    //? count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    //? go from start date to today, and add each completion to DB
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTime(
        startDate.add(
          Duration(days: i),
        ),
      );

      int completionStatus = db.getCompletionStatus(yyyymmdd);

      int year = startDate.add(Duration(days: i)).year;
      int month = startDate.add(Duration(days: i)).month;
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): completionStatus
      };

      //? ADD TO THE HEAT MAP DATASETS
      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }
}
