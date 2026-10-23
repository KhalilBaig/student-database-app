import 'package:flutter/material.dart';
import '../database/dbHelper.dart';

class StudentdbScreen extends StatefulWidget {
  const StudentdbScreen({super.key});

  @override
  State<StudentdbScreen> createState() => _StudentdbScreenState();
}

class _StudentdbScreenState extends State<StudentdbScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rollNoController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();

  List<Map<String, dynamic>> students = [];

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  // READ
  Future<void> loadStudents() async {
    final data = await dbHelper.instance.getStudents();

    setState(() {
      students = data;
    });
  }

  // CREATE
  Future<void> addStudent() async {
    if (nameController.text.isEmpty ||
        rollNoController.text.isEmpty ||
        courseController.text.isEmpty ||
        semesterController.text.isEmpty) {
      return;
    }

    await dbHelper.instance.insertStudent({
      'name': nameController.text,
      'rollNo': rollNoController.text,
      'course': courseController.text,
      'semester': semesterController.text,
    });

    clearFields();
    loadStudents();
  }

  // UPDATE
  Future<void> updateStudent(int id) async {
    await dbHelper.instance.updateStudent(id, {
      'name': nameController.text,
      'rollNo': rollNoController.text,
      'course': courseController.text,
      'semester': semesterController.text,
    });

    clearFields();
    loadStudents();
  }

  // DELETE
  Future<void> deleteStudent(int id) async {
    await dbHelper.instance.deleteStudent(id);
    loadStudents();
  }

  void clearFields() {
    nameController.clear();
    rollNoController.clear();
    courseController.clear();
    semesterController.clear();
  }

  void editStudent(Map<String, dynamic> student) {
    nameController.text = student['name'];
    rollNoController.text = student['rollNo'];
    courseController.text = student['course'];
    semesterController.text = student['semester'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Student'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Student Name',
                ),
              ),
              TextField(
                controller: rollNoController,
                decoration: const InputDecoration(
                  labelText: 'Roll Number',
                ),
              ),
              TextField(
                controller: courseController,
                decoration: const InputDecoration(
                  labelText: 'Course',
                ),
              ),
              TextField(
                controller: semesterController,
                decoration: const InputDecoration(
                  labelText: 'Semester',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                clearFields();
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                updateStudent(student['id']);
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Management'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            // Student Name
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Student Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // Roll Number
            TextField(
              controller: rollNoController,
              decoration: const InputDecoration(
                labelText: 'Roll Number',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // Course
            TextField(
              controller: courseController,
              decoration: const InputDecoration(
                labelText: 'Course',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // Semester
            TextField(
              controller: semesterController,
              decoration: const InputDecoration(
                labelText: 'Semester',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // Add Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addStudent,
                child: const Text('Add Student'),
              ),
            ),

            const SizedBox(height: 15),

            // Students List
            Expanded(
              child: students.isEmpty
                  ? const Center(
                child: Text('No Students Found'),
              )
                  : ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {

                  final student = students[index];

                  return Card(
                    child: ListTile(
                      title: Text(
                        student['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      subtitle: Text(
                        'Roll No: ${student['rollNo']}\n'
                            'Course: ${student['course']}\n'
                            'Semester: ${student['semester']}',
                      ),

                      isThreeLine: true,

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          // Edit
                          IconButton(
                            onPressed: () {
                              editStudent(student);
                            },
                            icon: const Icon(Icons.edit),
                          ),

                          // Delete
                          IconButton(
                            onPressed: () {
                              deleteStudent(student['id']);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    rollNoController.dispose();
    courseController.dispose();
    semesterController.dispose();

    super.dispose();
  }
}