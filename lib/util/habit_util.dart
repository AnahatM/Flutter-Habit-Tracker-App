// Given a Habit List of Completion Days, Is the Habit Completed Today?
import 'package:minimalist_habit_tracker/models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completionDays) {
  // Get the Current Date
  final today = DateTime.now();
  // Check if Today is in the Completion Days
  return completionDays.any(
    (date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day,
  );
}

// Prepare Heatmap Dataset
Map<DateTime, int> prepareHeatmapDataset(List<Habit> habits) {
  // Initialize the Dataset
  Map<DateTime, int> dataset = {};

  // Iterate through the Habits
  for (var habit in habits) {
    // Iterate through the Habit's Completion Days
    for (var date in habit.completedDays) {
      // Normalize the Date to Avoid Time Discrepancies
      final normalizedDate = DateTime(date.year, date.month, date.day);
      // Increment the Count if Date Exists in Dataset
      if (dataset.containsKey(normalizedDate)) {
        dataset[normalizedDate] = dataset[normalizedDate]! + 1;
      }
      // Otherwise, Initialize Date With Count of 1
      else {
        dataset[normalizedDate] = 1;
      }
    }
  }

  // Return the Dataset
  return dataset;
}
