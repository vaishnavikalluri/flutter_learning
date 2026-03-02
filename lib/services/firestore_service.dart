// Cloud Firestore Service
// Handles real-time database operations for tasks/todos

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Task Model - Represents a task in Firestore
class Task {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final String userId;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.createdAt,
    required this.userId,
  });

  /// Create Task from Firestore document
  factory Task.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      userId: data['userId'] ?? '',
    );
  }

  /// Convert Task to Firestore document format
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
      'userId': userId,
    };
  }

  /// Create a copy with updated fields
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    String? userId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
    );
  }
}

/// FirestoreService - Manages all Cloud Firestore operations
/// Provides CRUD operations and real-time updates for tasks
class FirestoreService {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _tasksCollection => _firestore.collection('tasks');

  /// ADD - Create a new task
  /// Returns the document ID of the created task
  Future<String?> addTask({
    required String title,
    required String userId,
    String description = '',
  }) async {
    try {
      final docRef = await _tasksCollection.add({
        'title': title,
        'description': description,
        'isCompleted': false,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': userId,
      });
      
      print('✅ Task added: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Error adding task: $e');
      return null;
    }
  }

  /// READ - Get all tasks for a specific user (Stream for real-time updates)
  /// This automatically updates when data changes in Firestore
  Stream<List<Task>> getTasks(String userId) {
    return _tasksCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
    });
  }

  /// READ - Get a single task by ID (Stream)
  Stream<Task?> getTask(String taskId) {
    return _tasksCollection.doc(taskId).snapshots().map((doc) {
      if (doc.exists) {
        return Task.fromFirestore(doc);
      }
      return null;
    });
  }

  /// READ - Get all tasks (one-time read, not real-time)
  Future<List<Task>> getTasksOnce(String userId) async {
    try {
      final snapshot = await _tasksCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
    } catch (e) {
      print('❌ Error fetching tasks: $e');
      return [];
    }
  }

  /// UPDATE - Update an existing task
  Future<bool> updateTask({
    required String taskId,
    String? title,
    String? description,
    bool? isCompleted,
  }) async {
    try {
      final Map<String, dynamic> updates = {};
      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (isCompleted != null) updates['isCompleted'] = isCompleted;

      await _tasksCollection.doc(taskId).update(updates);
      print('✅ Task updated: $taskId');
      return true;
    } catch (e) {
      print('❌ Error updating task: $e');
      return false;
    }
  }

  /// UPDATE - Toggle task completion status
  Future<bool> toggleTaskCompletion(String taskId, bool currentStatus) async {
    return updateTask(taskId: taskId, isCompleted: !currentStatus);
  }

  /// DELETE - Remove a task
  Future<bool> deleteTask(String taskId) async {
    try {
      await _tasksCollection.doc(taskId).delete();
      print('✅ Task deleted: $taskId');
      return true;
    } catch (e) {
      print('❌ Error deleting task: $e');
      return false;
    }
  }

  /// DELETE - Remove all tasks for a user
  Future<bool> deleteAllTasks(String userId) async {
    try {
      final snapshot = await _tasksCollection
          .where('userId', isEqualTo: userId)
          .get();

      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }

      print('✅ All tasks deleted for user: $userId');
      return true;
    } catch (e) {
      print('❌ Error deleting all tasks: $e');
      return false;
    }
  }

  /// QUERY - Get completed tasks
  Stream<List<Task>> getCompletedTasks(String userId) {
    return _tasksCollection
        .where('userId', isEqualTo: userId)
        .where('isCompleted', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
    });
  }

  /// QUERY - Get pending tasks
  Stream<List<Task>> getPendingTasks(String userId) {
    return _tasksCollection
        .where('userId', isEqualTo: userId)
        .where('isCompleted', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
    });
  }

  /// BATCH WRITE - Add multiple tasks at once
  Future<bool> addTasksBatch(List<Map<String, dynamic>> tasks) async {
    try {
      final batch = _firestore.batch();

      for (final task in tasks) {
        final docRef = _tasksCollection.doc();
        batch.set(docRef, {
          ...task,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
      print('✅ Batch write completed: ${tasks.length} tasks added');
      return true;
    } catch (e) {
      print('❌ Error in batch write: $e');
      return false;
    }
  }
}

// ============================================================================
// EXAMPLE USAGE IN A FLUTTER SCREEN
// ============================================================================

/// TaskListScreen - Example implementation using FirestoreService
class TaskListScreen extends StatefulWidget {
  final String userId;

  const TaskListScreen({super.key, required this.userId});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  /// Add a new task
  Future<void> _addTask() async {
    if (_taskController.text.trim().isEmpty) return;

    await _firestoreService.addTask(
      title: _taskController.text.trim(),
      userId: widget.userId,
    );

    _taskController.clear();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task added successfully!')),
      );
    }
  }

  /// Delete a task with confirmation
  Future<void> _deleteTask(String taskId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _firestoreService.deleteTask(taskId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Task List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Add task input
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      hintText: 'Enter task title',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),

          // Real-time task list using StreamBuilder
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: _firestoreService.getTasks(widget.userId),
              builder: (context, snapshot) {
                // Loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Error state
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                // No data state
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No tasks yet. Add one above!',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                // Display tasks
                final tasks = snapshot.data!;
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskTile(
                      task: task,
                      onToggle: () => _firestoreService.toggleTaskCompletion(
                        task.id,
                        task.isCompleted,
                      ),
                      onDelete: () => _deleteTask(task.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// TaskTile - Individual task widget
class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Text(
          'Created: ${task.createdAt.toString().substring(0, 16)}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
