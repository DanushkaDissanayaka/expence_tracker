import 'package:flutter/material.dart';

class NumberPad extends StatelessWidget {
  const NumberPad({
    super.key,
    required this.onAppend,
    required this.onDelete,
    required this.onDone,
  });

  final ValueChanged<String> onAppend;
  final VoidCallback onDelete;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final keys = [
      "1", "2", "3", 
      "4", "5", "6",
      "7", "8", "9", 
      ".", "0", "DEL", "DONE"
    ];

    final doneColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () {}, // Absorb taps to prevent closing
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Enter Amount",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
          GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: keys.length - 1, // Exclude "DONE"
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.0,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemBuilder: (_, i) {
              final k = keys[i];
              final isDel = k == "DEL";
              return GestureDetector(
                onTap: () {
                  if (isDel) {
                    onDelete();
                  } else if (k != "DONE") {
                    onAppend(k);
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isDel ? Colors.grey.shade100 : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: isDel
                      ? Icon(
                          Icons.backspace_outlined,
                          color: Colors.grey.shade700,
                          size: 16,
                        )
                      : Text(
                          k,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                ),
              );
            },
          ),
          const SizedBox(height: 6),
        ],
      ),
    ),
    );
  }
}
