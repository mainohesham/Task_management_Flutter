import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button/custom_button.dart';
import '../../../../core/widgets/custom_field/custom_field.dart';
import '../../../../core/widgets/custom_label/custom_label.dart';
import '../../../auth/model/model/user_model.dart';
import '../../view_model/cubit/profile_cubit.dart';
import '../../view_model/state/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();

  int? _selectedLevel;
  String? _profilePhotoPath;
  bool _isEditing = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadUser(widget.userId);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  void _fillFields(User user) {
    _fullNameController.text = user.fullName;
    _selectedLevel = user.academicLevel;
    _profilePhotoPath = user.profilePhoto;
  }

  // ── Pick Image from Gallery only ──────────────────
  Future<void> _pickFromGallery() async {
    Navigator.pop(context);
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
      );
      if (picked != null) {
        setState(() => _profilePhotoPath = picked.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      }
    }
  }

  // ── Pick Image from Camera ────────────────────────
  Future<void> _pickFromCamera() async {
    Navigator.pop(context);
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      // ✅ Fix for web/desktop — use gallery if camera not supported
      if (!Platform.isAndroid && !Platform.isIOS) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera not supported on this platform'),
          ),
        );
        return;
      }
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 800,
      );
      if (picked != null) {
        setState(() => _profilePhotoPath = picked.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera not available. Please use Gallery instead.'),
          ),
        );
      }
    }
  }

  // ── Image Source Bottom Sheet ─────────────────────
  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Photo From',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Mycolors.mainColor,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Mycolors.mainColor.withOpacity(0.1),
                child: Icon(Icons.camera_alt, color: Mycolors.mainColor),
              ),
              title: const Text('Camera'),
              subtitle: Platform.isAndroid || Platform.isIOS
                  ? null
                  : const Text(
                      'Not supported on this device',
                      style: TextStyle(color: Colors.red, fontSize: 11),
                    ),
              onTap: _pickFromCamera,
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Mycolors.mainColor.withOpacity(0.1),
                child: Icon(Icons.photo_library, color: Mycolors.mainColor),
              ),
              title: const Text('Gallery'),
              onTap: _pickFromGallery,
            ),
          ],
        ),
      ),
    );
  }

  // ── Submit Profile ────────────────────────────────
  void _submitProfile(User currentUser) {
    if (_formKey.currentState!.validate()) {
      final updatedUser = currentUser.copyWith(
        fullName: _fullNameController.text.trim(),
        academicLevel: _selectedLevel,
        profilePhoto: _profilePhotoPath,
      );
      context.read<ProfileCubit>().updateProfile(updatedUser);
      setState(() => _isEditing = false);
    }
  }

  // ── Info Tile ─────────────────────────────────────
  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Mycolors.mainColor.withOpacity(0.1),
            child: Icon(icon, color: Mycolors.mainColor, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Mycolors.mainColor,
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontStyle: FontStyle.italic,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.close : Icons.edit,
              color: Colors.white,
            ),
            onPressed: () => setState(() => _isEditing = !_isEditing),
          ),
        ],
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            _fillFields(state.user);
          }
          if (state is ProfileUpdated) {
            _fillFields(state.user);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Profile Updated ✅')));
          }
          if (state is ProfileFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileLoaded || state is ProfileUpdated) {
            final user = state is ProfileLoaded
                ? state.user
                : (state as ProfileUpdated).user;

            return SingleChildScrollView(
              child: Column(
                children: [
                  // ── Profile Header ──────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    decoration: BoxDecoration(
                      color: Mycolors.mainColor,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        // ── Photo + edit icon ─────────────
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.white.withOpacity(0.3),
                              backgroundImage: _profilePhotoPath != null
                                  ? FileImage(File(_profilePhotoPath!))
                                  : null,
                              child: _profilePhotoPath == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 55,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),

                            // ✅ Camera icon ONLY appears in edit mode
                            if (_isEditing)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _showImageSourcePicker,
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Mycolors.mainColor,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Name
                        Text(
                          user.fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Email
                        Text(
                          user.email,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── View Mode ───────────────────────────
                  if (!_isEditing) ...[
                    _infoTile(
                      icon: Icons.person,
                      label: 'Full Name',
                      value: user.fullName,
                    ),
                    _infoTile(
                      icon: Icons.badge,
                      label: 'Student ID',
                      value: user.studentID,
                    ),
                    _infoTile(
                      icon: Icons.email,
                      label: 'University Email',
                      value: user.email,
                    ),
                    _infoTile(
                      icon: Icons.wc,
                      label: 'Gender',
                      value: user.gender ?? 'Not set',
                    ),
                    _infoTile(
                      icon: Icons.school,
                      label: 'Academic Level',
                      value: user.academicLevel != null
                          ? 'Level ${user.academicLevel}'
                          : 'Not set',
                    ),
                  ],

                  // ── Edit Mode ───────────────────────────
                  if (_isEditing) ...[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Full Name
                          MyLabel(text: 'Full Name'),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: CustomField(
                              hintText: 'Full Name',
                              icon: Icons.person,
                              controller: _fullNameController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Academic Level
                          MyLabel(text: 'Academic Level'),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: SizedBox(
                              width: 315,
                              child: DropdownButtonFormField<int>(
                                value: _selectedLevel,
                                hint: const Text('Select Level'),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.school,
                                    color: Mycolors.mainColor,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide(
                                      color: Mycolors.mainColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide(
                                      color: Mycolors.mainColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide(
                                      color: Mycolors.mainColor,
                                      width: 3,
                                    ),
                                  ),
                                ),
                                items: [1, 2, 3, 4].map((level) {
                                  return DropdownMenuItem(
                                    value: level,
                                    child: Text('Level $level'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() => _selectedLevel = value);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Save Button
                          CustomButton(
                            title: 'Save Changes',
                            bgColor: Mycolors.mainColor,
                            textColor: Colors.white,
                            onpressed: () => _submitProfile(user),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
