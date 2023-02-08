import 'package:fitness_tracker/data/date_time.dart';
import 'package:fitness_tracker/models/exercise_model.dart';
import 'package:hive/hive.dart';
import '../models/workout_model.dart';

//! ****************DATABASE STARTS***************************
class HiveDatabase {
  //? reference of hive box
  final _myBox = Hive.box('database');

  //? check if data is already stored, if not then putting the start date
  bool dataExists() {
    if (_myBox.isEmpty) {
      print('My Box is empty');
      _myBox.put('Start_Date', todayDate());
      return false;
    } else {
      return true;
    }
  }

//? getting start date
  String getStartDate() {
    return _myBox.get('Start_Date');
  }

//? Write data
  void saveToDB(List<WorkoutModel> workouts) {
    //converting workout and exercises into list
    final workoutList = objToWorkoutList(workouts);
    final exerciseList = objToExerciseList(workouts);

    if (exerciseCompleted(workouts)) {
      _myBox.put(
        'Completion_Status_${todayDate()}',
        1,
      );
    } else {
      _myBox.put(
        'Completion_Status_${todayDate()}',
        0,
      );
    }

    //? save into hive
    _myBox.put('Workouts', workoutList);
    _myBox.put('Exercises', exerciseList);
  }

//? read data and return a list of workout
  List<WorkoutModel> readDB() {
    List<WorkoutModel> savedWorkouts = [];

    List<String> workoutNames = _myBox.get('Workouts');
    final exercisesDetails = _myBox.get('Exercises');

    for (int i = 0; i < workoutNames.length; i++) {
      List<ExerciseModel> exerciseInEachWorkout = [];
      for (int j = 0; j < exercisesDetails[i].length; j++) {
        // adding each exercise into a list
        exerciseInEachWorkout.add(
          ExerciseModel(
            name: exercisesDetails[i][j][0],
            weight: exercisesDetails[i][j][1],
            reps: exercisesDetails[i][j][2],
            sets: exercisesDetails[i][j][3],
            isDone: exercisesDetails[i][j][4] == "true" ? true : false,
          ),
        );
        //create individual workout
        WorkoutModel workoutModel = WorkoutModel(
            name: workoutNames[i], exercises: exerciseInEachWorkout);

        // add this workoutmodel into overall list
        savedWorkouts.add(workoutModel);
      }
    }
    return savedWorkouts;
  }

//? check if any exercises have been done
  bool exerciseCompleted(List<WorkoutModel> workouts) {
    //going through each workout
    for (var workout in workouts) {
      //going through each exercise in workout
      for (var exersice in workout.exercises) {
        if (exersice.isDone) {
          return true;
        }
      }
    }
    return false;
  }

//? return completion status of a given date
  int getCompletionStatus(String yyyymmdd) {
    int completionStatus = _myBox.get('Completion_Status_$yyyymmdd') ?? 0;
    return completionStatus;
  }
}

//! ********************DATABASE END********************************

//****CONVERT WORKOUT OBJECT INTO LIST*****//
List<String> objToWorkoutList(List<WorkoutModel> workouts) {
  List<String> workoutList = [];

  for (int i = 0; i < workouts.length; i++) {
    workoutList.add(workouts[i].name);
  }

  return workoutList;
}

//****CONVERT EXERCISES OBJECT INTO LIST*****//
List<List<List<String>>> objToExerciseList(List<WorkoutModel> workouts) {
  List<List<List<String>>> exerciseList = [];
  /*
  belly[ [kg, reps, sets], [kg, reps, sets]]
  Abs[ [kg, reps, sets], [kg, reps, sets], [kg, reps, sets]]

  */

  //? going through each workout
  for (int i = 0; i < workouts.length; i++) {
    List<ExerciseModel> exerciseInWorkout = workouts[i].exercises;
    List<List<String>> individualWorkout = [
      //   belly[ [kg, reps, sets], [kg, reps, sets]]
    ];

    //?going through each exercise into exerciseList
    for (int j = 0; j < exerciseInWorkout.length; j++) {
      List<String> individualExercise = [
        //  [kg, reps, sets]
      ];
      individualExercise.addAll([
        exerciseInWorkout[j].name,
        exerciseInWorkout[j].weight,
        exerciseInWorkout[j].reps,
        exerciseInWorkout[j].sets,
        exerciseInWorkout[j].isDone.toString(),
      ]);
      individualWorkout.add(individualExercise);
    }

    exerciseList.add(individualWorkout);
  }

  return exerciseList;
}
