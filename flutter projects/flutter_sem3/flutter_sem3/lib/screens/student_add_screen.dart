import 'package:flutter/material.dart';

import '../models/student_model.dart';
import '../services/student_service.dart';
import '../utils/message.dart';

class StudentAddScreen extends StatefulWidget {
  const StudentAddScreen({super.key});

  @override
  State<StudentAddScreen> createState() => _StudentAddScreenState();
}

class _StudentAddScreenState extends State<StudentAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameCtrl = TextEditingController();
  final _service = StudentService();
  bool _loading = false;

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Student')),
      body: Stack(
        children: [
          _buildBody(),
          if (_loading) _buildLoadingCover(),
        ],
      ),
    );
  }

  Widget _buildLoadingCover() {
    return Container(
      color: Colors.black38,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }

  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [_buildFullNameTextField(), _buildSaveButton()],
      ),
    );
  }

  Widget _buildFullNameTextField() {
    return TextFormField(
      controller: _fullNameCtrl,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
        hintText: 'Full Name',
      ),
      validator: (text) {
        if (text == null || text.trim().isEmpty) {
          return 'Full Name is required';
        }
        return null;
      },
    );
  }

  Widget _buildSaveButton() {
    return FilledButton.icon(
      onPressed: _loading ? null : _saveStudent,
      icon: const Icon(Icons.save_alt),
      label: const Text('SAVE'),
    );
  }

  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) return;

    final item = StudentModel(
      id: 0,
      fullName: _fullNameCtrl.text.trim(),
    );

    setState(() => _loading = true);

    try {
      final result = await _service.create(item);
      if (!mounted) return;

      if (result) {
        showMessage(context, 'Student Inserted Successfully');
        _fullNameCtrl.clear();
      }
    } catch (e) {
      if (!mounted) return;
      showMessage(context, 'Student Inserted Failed');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }
}
