import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:minimalist_habit_tracker/models/app_settings.dart';
import 'package:minimalist_habit_tracker/models/habit.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  /* =============================
   * Setup Database
   * ========================== */

  // Initialize Database
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      HabitSchema,
      AppSettingsSchema,
    ], directory: dir.path);
  }

  // Save First Date of App Startup for Heatmap
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // Get First Date of App Startup for Heatmap
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  /* =============================
   * Database Crud Operations
   * ========================== */

  // List of Habits
  final List<Habit> currentHabits = [];

  // Add a new Habit
  Future<void> addHabit(String habitName) async {
    // Create new Habit
    final habit = Habit()..name = habitName;

    // Save to Database
    await isar.writeTxn(() => isar.habits.put(habit));

    // Re-read from Database
    readHabits();
  }

  // Read Saved Habits from Database
  Future<void> readHabits() async {
    // Fetch all Habits from Database
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    // Update Current Habits List
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    // Update UI
    notifyListeners();
  }

  // Update Habit, check on or off
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    // Find Specific Habit by ID
    final habit = await isar.habits.get(id);

    // Return if habit is null
    if (habit == null) return;

    await isar.writeTxn(() async {
      // Today
      final today = DateTime.now();

      // If Habit is Completed, Add Current Date to Completed Days List
      if (isCompleted && !habit.completedDays.contains(today)) {
        habit.completedDays.add(DateTime(today.year, today.month, today.day));
      }
      // If Habit is Uncompleted, Remove Current Date from Completed Days List
      else {
        habit.completedDays.removeWhere(
          (date) =>
              date.day == today.day &&
              date.month == today.month &&
              date.year == today.year,
        );
      }

      // Save Updated Habits to Database
      await isar.habits.put(habit);

      // Re-read from Database
      readHabits();
    });
  }

  Future<void> updateHabitName(int id, String newName) async {
    // Find Specific Habit by ID
    final habit = await isar.habits.get(id);

    // Return if habit is null
    if (habit == null) return;

    await isar.writeTxn(() async {
      // Update Habit Name
      habit.name = newName;

      // Save Updated Habits to Database
      await isar.habits.put(habit);

      // Re-read from Database
      readHabits();
    });
  }

  // Delete Habit
  Future<void> deleteHabit(int id) async {
    // Delete Habit from Database
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });

    // Re-read from Database
    readHabits();
  }
}
