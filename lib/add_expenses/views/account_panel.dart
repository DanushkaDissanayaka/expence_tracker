import 'package:flutter/material.dart';
import 'package:expense_tracker/common/widgets/panel_header.dart';

class AccountPanel extends StatelessWidget {
  const AccountPanel({super.key, required this.onPick, required this.onClose});

  final ValueChanged<String> onPick;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final tiles = const [
      ("Cash", Icons.payments_outlined),
      ("Accounts", Icons.account_balance_outlined),
      ("Card", Icons.credit_card),
    ];

    final keyColor = Theme.of(context).colorScheme.surfaceDim;

    return Material(
      // color: const Color(0xFF23272C),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PanelHeader(
            title: "Accounts"
          ),
          SizedBox(
            height: 92,
            child: Row(
              children: tiles
                  .map(
                    (t) => Expanded(
                      child: InkWell(
                        onTap: () => onPick(t.$1),
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: keyColor,
                            borderRadius: BorderRadius.circular(6),
                            // border: Border.all(color: const Color(0xFF2C3238)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(t.$2, size: 22),
                              const SizedBox(height: 6),
                              Text(t.$1, style: const TextStyle( fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
