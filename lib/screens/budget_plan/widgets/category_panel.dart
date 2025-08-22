import 'package:flutter/material.dart';

class CategoryPanel extends StatelessWidget {
  final String title;
  final List<String> options;
  final Function(String) onSelect;
  final VoidCallback onClose;

  const CategoryPanel({
    super.key,
    required this.title,
    required this.options,
    required this.onSelect,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Colors.white,
        elevation: 8,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Container(
          height: 320,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: onClose,
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView.separated(
                  itemCount: options.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, idx) {
                    return ListTile(
                      title: Text(options[idx], style: const TextStyle(fontSize: 15)),
                      onTap: () => onSelect(options[idx]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
