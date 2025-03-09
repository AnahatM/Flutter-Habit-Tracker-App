import 'package:isar/isar.dart';

/* 
Run command to generate isar files: 
dart run build_runner build
*/
part 'habit.g.dart';

@Collection()
class Habit {
  // Habit ID
  Id id = Isar.autoIncrement;

  // Habit Name
  late String name;

  // Completed Days
  List<DateTime> completedDays = [];
}
