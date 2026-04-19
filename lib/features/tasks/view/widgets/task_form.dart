import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../model/model/task_model.dart';
import '../../view_model/cubit/task_cubit.dart';


class TaskBottomSheet extends StatefulWidget {
  final Task? task; // null = add, not null = edit
  final int userId;

  const TaskBottomSheet({super.key, this.task, required this.userId});

  @override
  State<TaskBottomSheet> createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  String _priority = 'Medium';
  DateTime? _dueDate;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    // If editing, fill fields with existing task data
    if (_isEditing) {
      _titleController.text = widget.task!.title;
      _descController.text = widget.task!.description ?? '';
      _priority = widget.task!.priority;
      _dueDate = widget.task!.dueDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Mycolors.mainColor),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_dueDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a due date')),
        );
        return;
      }

      final task = Task(
        id: widget.task?.id,
        title: _titleController.text.trim(),
        description: _descController.text.trim().isEmpty
            ? null
            : _descController.text.trim(),
        dueDate: _dueDate!,
        priority: _priority,
        isCompleted: widget.task?.isCompleted ?? false,
        userId: widget.userId,
      );

      if (_isEditing) {
        context.read<TaskCubit>().updateTask(task,widget.userId);
      } else {
        context.read<TaskCubit>().addTask(task,widget.userId);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Header ─────────────────────────────────
              Center(
                child: Text(
                  _isEditing ? 'Edit Task' : 'Add New Task',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Mycolors.mainColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Title (Mandatory) ───────────────────────
              TextFormField(
                controller: _titleController,
                decoration: _inputDecoration('Task Title *', Icons.title),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter task title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Description (Optional) ──────────────────
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: _inputDecoration(
                    'Description (optional)', Icons.description),
              ),
              const SizedBox(height: 16),

              // ── Due Date (Mandatory) ────────────────────
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Mycolors.mainColor, width: 1.5),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Mycolors.mainColor),
                      const SizedBox(width: 10),
                      Text(
                        _dueDate == null
                            ? 'Select Due Date *'
                            : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                        style: TextStyle(
                          color: _dueDate == null
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Priority (Mandatory) ────────────────────
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: _inputDecoration('Priority', Icons.flag),
                items: ['Low', 'Medium', 'High'].map((p) {
                  return DropdownMenuItem(value: p, child: Text(p));
                }).toList(),
                onChanged: (value) {
                  setState(() => _priority = value!);
                },
              ),
              const SizedBox(height: 24),

              // ── Submit Button ───────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Mycolors.mainColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: _submit,
                  child: Text(
                    _isEditing ? 'Update Task' : 'Add Task',
                    style: const TextStyle(
                        fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Mycolors.mainColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: Mycolors.mainColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: Mycolors.mainColor, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: Mycolors.mainColor, width: 3),
      ),
    );
  }
}