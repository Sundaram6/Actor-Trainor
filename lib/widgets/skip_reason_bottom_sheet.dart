import 'package:flutter/material.dart';

class SkipReasonBottomSheet extends StatefulWidget {
  final String blockName;
  const SkipReasonBottomSheet({super.key, required this.blockName});

  @override
  State<SkipReasonBottomSheet> createState() => _SkipReasonBottomSheetState();
}

class _SkipReasonBottomSheetState extends State<SkipReasonBottomSheet> {
  String? _selected;
  final _otherController = TextEditingController();
  final _reasons = ['Low energy', 'Time constraint', 'Physical discomfort', 'Prioritization'];

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD4AF37);
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24,
        left: 24,
        right: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Skip ${widget.blockName}',
            style: const TextStyle(
              color: gold,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Why are you skipping this block?\nThis helps you track patterns.',
            style: TextStyle(color: Colors.white54, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 20),
          ..._reasons.map((r) => _ReasonTile(
                reason: r,
                selected: _selected == r,
                onTap: () => setState(() => _selected = r),
              )),
          _ReasonTile(
            reason: 'Other',
            selected: _selected == 'Other',
            onTap: () => setState(() => _selected = 'Other'),
          ),
          if (_selected == 'Other') ...[
            const SizedBox(height: 12),
            TextField(
              controller: _otherController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Specify...',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                filled: true,
                fillColor: const Color(0xFF1A1A1A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: gold),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: gold,
                foregroundColor: const Color(0xFF0A0A0A),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              onPressed: () {
                String? reason = _selected;
                if (reason == 'Other') reason = _otherController.text.trim();
                if (reason == null || reason.isEmpty) reason = 'Skipped';
                Navigator.pop(context, reason);
              },
              child: const Text('CONFIRM SKIP'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('CANCEL', style: TextStyle(color: Colors.white38, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReasonTile extends StatelessWidget {
  final String reason;
  final bool selected;
  final VoidCallback onTap;

  const _ReasonTile({required this.reason, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD4AF37);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? gold.withValues(alpha: 0.1) : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? gold : Colors.white.withValues(alpha: 0.06)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                reason,
                style: TextStyle(
                  color: selected ? gold : Colors.white70,
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
            if (selected) const Icon(Icons.check_rounded, color: gold, size: 18),
          ],
        ),
      ),
    );
  }
}
