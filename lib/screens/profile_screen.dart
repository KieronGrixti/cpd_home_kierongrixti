import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;

  static const _fileName = 'profile.jpg';

  @override
  void initState() {
    super.initState();
    _loadSavedImage();
  }

  Future<void> _loadSavedImage() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, _fileName));
    if (await file.exists()) {
      setState(() => _profileImage = file);
    }
  }

  Future<void> _takePhoto() async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 800,
    );

    if (picked == null) return;

    final dir = await getApplicationDocumentsDirectory();
    final savedPath = p.join(dir.path, _fileName);

    final savedFile = await File(picked.path).copy(savedPath);

    setState(() => _profileImage = savedFile);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile photo updated')),
    );
  }

  Future<void> _removePhoto() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, _fileName));
    if (await file.exists()) {
      await file.delete();
    }
    setState(() => _profileImage = null);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile photo removed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            CircleAvatar(
              radius: 64,
              backgroundColor: cs.primary.withOpacity(0.15),
              backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
              child: _profileImage == null
                  ? Icon(Icons.person, size: 64, color: cs.primary)
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              'Your Profile',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tap below to take a profile picture.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _takePhoto,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take Photo'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _profileImage == null ? null : _removePhoto,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Remove Photo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
