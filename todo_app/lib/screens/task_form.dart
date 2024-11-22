import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg

class TaskForm extends StatefulWidget {
  final Map<String, dynamic>? task; // Pass an existing task to edit
  final VoidCallback onSave; // Callback to refresh the task list after save

  const TaskForm({Key? key, this.task, required this.onSave}) : super(key: key);

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;

  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      // If editing an existing task, pre-fill the form fields
      _titleController.text = widget.task!['title'] ?? '';
      _descriptionController.text = widget.task!['description'] ?? '';
      if (widget.task!['due_date'] != null) {
        _dueDate = DateTime.parse(widget.task!['due_date']);
      }
    }
  }

  Future<void> _saveTask() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty')),
      );
      return;
    }

    final taskData = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'due_date': _dueDate?.toIso8601String(),
      'user_id': _supabase.auth.currentUser!.id,
    };

    try {
      if (widget.task == null) {
        // Create a new task
        await _supabase.from('tasks').insert(taskData);
      } else {
        // Update an existing task
        await _supabase
            .from('tasks')
            .update(taskData)
            .eq('id', widget.task!['id']);
      }
      widget.onSave();
      Navigator.pop(context); // Close the form
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving task: $e')),
      );
    }
  }

  Future<void> _pickDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() => _dueDate = pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background to black
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
        backgroundColor: const Color.fromARGB(255, 117, 119, 122),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add image at the top of the screen
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SvgPicture.asset(
                'assets/images/create_img.svg', // Path to your SVG image
                width: 150, // Adjust the width as needed
                height: 150, // Adjust the height as needed
              ),
            ),

            // Input fields for Title and Description
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 14),

            // Date picker button
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickDueDate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 92, 7, 100), // Customize button color
                  ),
                  child: Text(
                    _dueDate == null
                        ? 'Pick Due Date'
                        : 'Due Date: ${_dueDate!.toLocal()}'.split(' ')[0],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Save button
            ElevatedButton(
              onPressed: _saveTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(
                    255, 92, 7, 100), // Customize button color
              ),
              child: Text(
                widget.task == null ? 'Create Task' : 'Save Changes',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
