import 'package:flutter/material.dart';
import 'panel_header.dart';

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
      "1", "2", "3", "DEL",
      "4", "5", "6", "-",
      "7", "8", "9", ".",
      "0", "DONE"
    ];

    // Light theme only
    final keyColor = Theme.of(context).colorScheme.surfaceDim;
    final doneColor = Theme.of(context).colorScheme.primary;

    return Material(
      // color: backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PanelHeader(title: "Amount"),
          GridView.builder(
            shrinkWrap: true,
            itemCount: keys.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.6,
            ),
            itemBuilder: (_, i) {
              final k = keys[i];
              final isDone = k == "DONE";
              final isDel = k == "DEL";
              return Padding(
                padding: const EdgeInsets.all(4),
                child: InkWell(
                  onTap: () {
                    if (isDone) {
                      onDone();
                    } else if (isDel) {
                      onDelete();
                    } else {
                      onAppend(k);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: keyColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isDone ? doneColor : Colors.transparent),
                    ),
                    child: isDel
                        ? const Icon(Icons.backspace_outlined, color: Colors.black)
                        : Text(
                            isDone ? "Done" : k,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
