import 'package:isar/isar.dart';

/* 
Run command to generate isar files: 
dart run build_runner build
*/
part 'app_settings.g.dart';

@Collection()
class AppSettings {
  Id id = Isar.autoIncrement;
  DateTime? firstLaunchDate;
}
