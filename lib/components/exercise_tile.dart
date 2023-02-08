import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isDone;
  void Function(bool?)? onChanged;
  ExerciseTile(
      {super.key,
      required this.exerciseName,
      required this.weight,
      required this.reps,
      required this.sets,
      required this.isDone,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.yellow, borderRadius: BorderRadius.circular(10)),
      child: ListTile(
          title: Text(exerciseName),
          subtitle: Row(children: [
            Chip(
              label: Text("$weight kg"),
            ),
            Chip(
              label: Text("$reps reps"),
            ),
            Chip(
              label: Text("$sets sets"),
            )
          ]),
          trailing: Checkbox(
            value: isDone,
            onChanged: (value) => onChanged!(value),
          )),
    );
  }
}
