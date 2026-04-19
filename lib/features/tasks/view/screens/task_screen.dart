

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_bottom_navbar/custom_bottom_navbar.dart';
import '../../../auth/view/screens/login/login.dart';
import '../../../profile/view/screens/profile_screen.dart';
import '../../model/model/task_model.dart';
import '../../view_model/cubit/task_cubit.dart';
import '../../view_model/cubit/task_state.dart';
import '../widgets/task_card.dart';
import '../widgets/task_form.dart';

class TaskScreen extends StatefulWidget {
  final int userId;
  const TaskScreen({super.key, required this.userId});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  int _currentIndex = 1; // ✅ starts at Add Task

  void _showBottomSheet(BuildContext context, {Task? task}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<TaskCubit>(),
        child: TaskBottomSheet(
          task: task,
          userId: widget.userId,
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TaskCubit>().deleteTask(id, widget.userId);
              Navigator.pop(context);
            },
            child: const Text('Delete',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _onNavBarTap(BuildContext context, int index) {
    setState(() => _currentIndex = index);

    if (index == 0) {
      // ── Navigate to Profile ──────────────────────
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileScreen(userId: widget.userId),
        ),
      );
    } else if (index == 1) {
      // ── Open Add Task Bottom Sheet ───────────────
      _showBottomSheet(context);
    } else if (index == 2) {
      // ── Logout ───────────────────────────────────
      _confirmLogout(context);
    }
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Login()),
              );
            },
            child: Text('Logout',
                style: TextStyle(color: Mycolors.mainColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Mycolors.mainColor,
        title: const Text(
          'My Tasks',
          style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontStyle: FontStyle.italic),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TaskFailure) {
            return Center(child: Text(state.message));
          }

          if (state is TaskLoaded) {
            if (state.tasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.task_alt,
                        size: 80,
                        color: Mycolors.mainColor.withOpacity(0.4)),
                    const SizedBox(height: 16),
                    const Text(
                      'No tasks yet!\nTap + to add your first task',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return TaskCard(
                  task: task,
                  onEdit: () => _showBottomSheet(context, task: task),
                  onDelete: () => _confirmDelete(context, task.id!),
                  onToggleComplete: () => context
                      .read<TaskCubit>()
                      .toggleComplete(task, widget.userId),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),

      // ── Bottom NavBar ─────────────────────────────
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onNavBarTap(context, index),
      ),
    );
  }
}