class ExerciseModel {
  final String name;
  final String weight;
  final String reps;
  final String sets;
  bool isDone;
  ExerciseModel({
    required this.name,
    required this.weight,
    required this.reps,
    required this.sets,
    this.isDone = false,
  });
}
