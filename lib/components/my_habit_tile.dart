import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHabitTile extends StatelessWidget {
  final void Function(bool?)? onChecked;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;
  final String habitNameText;
  final bool isCompleted;

  const MyHabitTile({
    super.key,
    required this.habitNameText,
    required this.isCompleted,
    required this.onChecked,
    required this.editHabit,
    required this.deleteHabit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            // Edit Option
            SlidableAction(
              onPressed: editHabit,
              backgroundColor: Colors.grey.shade800,
              icon: Icons.settings,
              label: 'Edit',
            ),
            // Delete Option
            SlidableAction(
              onPressed: deleteHabit,
              backgroundColor: Colors.red.shade600,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
          ],
        ),
        child: _buildListTile(context),
      ),
    );
  }

  // Build Habit Tile
  Widget _buildListTile(BuildContext context) {
    return GestureDetector(
      // Toggle Habit Completion Status when Tapped
      onTap: () {
        if (onChecked != null) {
          onChecked!(!isCompleted);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: getCompletedTileColor(context),
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.all(12.0),
        // Tile with Checkbox and Habit Name
        child: ListTile(
          title: Text(
            habitNameText,
            style: TextStyle(color: getCompletedTextColor(context)),
          ),
          leading: Checkbox(
            activeColor: getCompletedTileColor(context),
            value: isCompleted,
            onChanged: onChecked,
          ),
        ),
      ),
    );
  }

  Color getCompletedTileColor(BuildContext context) =>
      isCompleted
          ? Colors.green.shade700
          : Theme.of(context).colorScheme.secondary;

  Color getCompletedTextColor(BuildContext context) =>
      isCompleted ? Colors.white : Theme.of(context).colorScheme.inversePrimary;
}
