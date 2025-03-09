// Given a Habit List of Completion Days, Is the Habit Completed Today?
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
