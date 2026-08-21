import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';

final roleProvider = StateProvider<String?>((ref) => null);
final sceneProvider = StateProvider<String?>((ref) => null);

class RoleSceneDialog extends ConsumerWidget {
  final VoidCallback onStart;

  const RoleSceneDialog({super.key, required this.onStart});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleCtrl = TextEditingController(text: ref.read(roleProvider) ?? '');
    final sceneCtrl = TextEditingController(text: ref.read(sceneProvider) ?? '');

    return AlertDialog(
      backgroundColor: const Color(0xFF141419),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Tag This Session', style: TextStyle(color: AppColors.goldAccent, fontWeight: FontWeight.w600)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: roleCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: _decoration('Role / Character'),
            onChanged: (v) => ref.read(roleProvider.notifier).state = v.trim().isEmpty ? null : v.trim(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: sceneCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: _decoration('Scene / Project'),
            onChanged: (v) => ref.read(sceneProvider.notifier).state = v.trim().isEmpty ? null : v.trim(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(roleProvider.notifier).state = null;
            ref.read(sceneProvider.notifier).state = null;
            onStart();
          },
          child: const Text('SKIP', style: TextStyle(color: Colors.white54)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.goldAccent, foregroundColor: Colors.black),
          onPressed: () {
            ref.read(roleProvider.notifier).state = roleCtrl.text.trim().isEmpty ? null : roleCtrl.text.trim();
            ref.read(sceneProvider.notifier).state = sceneCtrl.text.trim().isEmpty ? null : sceneCtrl.text.trim();
            onStart();
          },
          child: const Text('START SESSION'),
        ),
      ],
    );
  }

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF1A1A1A),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.goldAccent)),
      );
}
