import 'package:flutter/material.dart';

class FormRow extends StatelessWidget {
  const FormRow({
    super.key,
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
    required this.color,
  });

  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).textTheme.bodyMedium!.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 15,
    );
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? color.withValues(alpha: .7) : Colors.white12,
              width: selected ? 1.6 : 1.0,
            ),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 90,
              child: Text(label, style: base.copyWith(fontWeight: FontWeight.w500)),
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.left,
                style: base,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
