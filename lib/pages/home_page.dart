import 'package:flutter/material.dart';
import 'package:minimalist_habit_tracker/components/my_drawer.dart';
import 'package:minimalist_habit_tracker/components/my_habit_tile.dart';
import 'package:minimalist_habit_tracker/database/habit_database.dart';
import 'package:minimalist_habit_tracker/models/habit.dart';
import 'package:minimalist_habit_tracker/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // Read existing habits on app startup
    Provider.of<HabitDatabase>(context, listen: false).readHabits();

    super.initState();
  }

  // Text Editing Controller
  final TextEditingController habitNameController = TextEditingController();

  // Dialog For Create New Habit
  void showCreateHabitDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: TextField(
              controller: habitNameController,
              decoration: InputDecoration(hintText: "Create a new habit"),
            ),
            actions: [
              // Save Button
              MaterialButton(onPressed: createHabit, child: Text('Save')),
              // Cancel Button
              MaterialButton(
                onPressed: () {
                  // Clear the Text Field
                  habitNameController.clear();
                  // Close the Dialog
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          ),
    );
  }

  // Dialog For Edit Habit
  void showEditHabitDialog(Habit habit) {
    // Pre-Set the Habit Name in the Text Field
    habitNameController.text = habit.name;

    // Show the Dialog
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: TextField(
              controller: habitNameController,
              decoration: InputDecoration(hintText: "Edit habit name"),
            ),
            actions: [
              // Save Button
              MaterialButton(
                onPressed: () => editHabit(habit.id),
                child: Text('Save'),
              ),
              // Cancel Button
              MaterialButton(
                onPressed: () {
                  // Clear the Text Field
                  habitNameController.clear();
                  // Close the Dialog
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          ),
    );
  }

  // Dialog For Delete Habit
  void showDeleteHabitDialog(Habit habit) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Delete Habit"),
            content: Text("Are you sure you want to delete \"${habit.name}\""),
            actions: [
              // Save Button
              MaterialButton(
                onPressed: () => deleteHabit(habit.id),
                child: Text('Confirm'),
              ),
              // Cancel Button
              MaterialButton(
                onPressed: () {
                  // Close the Dialog
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          ),
    );
  }

  // Add Habit to Database
  void createHabit() {
    // Get New Habit Name
    final String newHabitName = habitNameController.text;
    // Save the Habit to Database
    context.read<HabitDatabase>().addHabit(newHabitName);
    // Clear the Text Field
    habitNameController.clear();
    // Close the Dialog
    Navigator.pop(context);
  }

  // Edit Habit in Database
  void editHabit(int id) {
    // Get New Habit Name
    final String newHabitName = habitNameController.text;
    // Save the Habit to Database
    context.read<HabitDatabase>().updateHabitName(id, newHabitName);
    // Clear the Text Field
    habitNameController.clear();
    // Close the Dialog
    Navigator.pop(context);
  }

  // Delete Habit from Database
  void deleteHabit(int id) {
    // Save the Habit to Database
    context.read<HabitDatabase>().deleteHabit(id);
    // Close the Dialog
    Navigator.pop(context);
  }

  // Check Habit On/Off
  void checkHabitOnOff(bool? value, Habit habit) {
    // Ensure value is not Null
    if (value == null) return;
    // Update Habit Completion Status
    context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: showCreateHabitDialog,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
      ),
      body: _buildHabitsList(),
    );
  }

  // Construct Habits List Interface
  Widget _buildHabitsList() {
    // Habits Database
    final habitDatabase = context.watch<HabitDatabase>();

    // Current Habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    // Return the ListView
    return ListView.builder(
      itemCount: currentHabits.length,
      itemBuilder: (context, index) {
        // Get the Habit at the current index
        Habit habit = currentHabits[index];
        // Check if Habit is Completed
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);
        // Return the ListTile
        return MyHabitTile(
          habitNameText: habit.name,
          isCompleted: isCompletedToday,
          onChecked: (value) => checkHabitOnOff(value, habit),
          editHabit: (context) => showEditHabitDialog(habit),
          deleteHabit: (context) => showDeleteHabitDialog(habit),
        );
      },
    );
  }
}
