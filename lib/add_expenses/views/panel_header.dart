import 'package:flutter/material.dart';

class PanelHeader extends StatelessWidget {
  const PanelHeader({
    super.key,
    required this.title,
    this.trailing,
  });

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceDim, borderRadius: BorderRadius.circular(0)),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          if (trailing != null) trailing!,
          const SizedBox(width: 12),
          // InkWell(
          //   onTap: () => Navigator.of(context).maybePop(),
          //   child: const Icon(Icons.close, color: Colors.grey),
          // ),
        ],
      ),
    );
  }
}
