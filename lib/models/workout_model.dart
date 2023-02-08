// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'exercise_model.dart';

class WorkoutModel {
  final String name;
  //? each workout going to have list of exercises
  final List<ExerciseModel> exercises;
  WorkoutModel({
    required this.name,
    required this.exercises,
  });
}
