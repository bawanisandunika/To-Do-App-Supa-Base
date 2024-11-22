import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg
import 'task_form.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final response = await _supabase
        .from('tasks')
        .select()
        .eq('user_id', _supabase.auth.currentUser!.id)
        .order('created_at', ascending: false);
    setState(() {
      _tasks = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> _deleteTask(dynamic taskId) async {
    try {
      // Check if the ID is an int (for bigint) or String (for uuid), and delete accordingly
      await _supabase.from('tasks').delete().eq('id', taskId);
      _fetchTasks(); // Refresh the list of tasks after deletion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting task: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background to black
      appBar: AppBar(
        title: const Text('To-Do List'),
        backgroundColor: const Color.fromARGB(255, 117, 119, 122),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _supabase.auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Center the image at the top of the screen
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SvgPicture.asset(
              'assets/images/pending_img.svg', // Path to your SVG image
              width: 150, // Adjust the width as needed
              height: 150, // Adjust the height as needed
            ),
          ),

          // Show the list of tasks
          Expanded(
            child: _tasks.isEmpty
                ? const Center(
                    child: Text(
                      'No tasks yet.',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return ListTile(
                        title: Text(
                          task['title'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          task['description'] ?? '',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            // Call _deleteTask with the correct type of task id
                            _deleteTask(task[
                                'id']); // Ensure task['id'] matches the correct data type
                          },
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TaskForm(task: task, onSave: _fetchTasks),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Floating action button to add tasks
          FloatingActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskForm(onSave: _fetchTasks),
              ),
            ),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
