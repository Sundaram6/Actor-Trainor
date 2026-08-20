import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'session_screen.dart';

class CheckInScreen extends ConsumerStatefulWidget {
  final String intention;
  const CheckInScreen({super.key, required this.intention});

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  final TextEditingController _roleController = TextEditingController();
  int _energy = 3;
  int _focus = 3;
  int _physical = 3;

  @override
  void dispose() {
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD4AF37);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'STATE OF THE ACTOR',
          style: TextStyle(color: gold, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 1.2),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white70, size: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Before you begin, mark where you are right now. This helps you track how your condition affects your work over time.',
                style: TextStyle(color: Colors.white38, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _roleController,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Role or scene (e.g. Hamlet, Commercial Audition)',
                  hintStyle: const TextStyle(color: Colors.white24),
                  filled: true,
                  fillColor: const Color(0xFF1A1A1A),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFD4AF37))),
                  prefixIcon: const Icon(Icons.theaters_outlined, color: Colors.white24, size: 20),
                ),
              ),
              const SizedBox(height: 24),
              _buildSlider('Energy', 'How awake and vital do you feel?', _energy, (v) => setState(() => _energy = v)),
              const SizedBox(height: 24),
              _buildSlider('Focus', 'How present is your attention?', _focus, (v) => setState(() => _focus = v)),
              const SizedBox(height: 24),
              _buildSlider('Body', 'How loose and available is your instrument?', _physical, (v) => setState(() => _physical = v)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gold,
                    foregroundColor: const Color(0xFF0A0A0A),
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  onPressed: () {
                    final role = _roleController.text.trim();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => SessionScreen(
                          initialIntention: widget.intention,
                          initialEnergy: _energy,
                          initialFocus: _focus,
                          initialPhysical: _physical,
                          roleTag: role.isNotEmpty ? role : null,
                        ),
                      ),
                    );
                  },
                  child: const Text('BEGIN SESSION'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider(String label, String subtitle, int value, ValueChanged<int> onChanged) {
    const gold = Color(0xFFD4AF37);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (i) {
            final index = i + 1;
            final isSelected = index == value;
            return GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: isSelected ? 48 : 36,
                height: isSelected ? 48 : 36,
                decoration: BoxDecoration(
                  color: isSelected ? gold : const Color(0xFF1A1A1A),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? gold : Colors.white24,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF0A0A0A) : Colors.white70,
                      fontSize: isSelected ? 18 : 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
