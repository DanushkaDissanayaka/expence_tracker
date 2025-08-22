import 'package:flutter/material.dart';
import 'form_row.dart';
import 'segmented.dart';
import 'account_panel.dart';
import 'category_panel.dart';
import 'income_category_panel.dart';
import 'transfer_category_panel.dart';
import 'number_pad.dart';


enum FocusField { none, amount, category, account }

class ExpenseEntryScreen extends StatefulWidget {
  const ExpenseEntryScreen({super.key});

  @override
  State<ExpenseEntryScreen> createState() => _ExpenseEntryScreenState();
}

class _ExpenseEntryScreenState extends State<ExpenseEntryScreen> {
  final FocusNode noteFocusNode = FocusNode();
  int selectedTab = 1; // 0=Income, 1=Expense, 2=Transfer
  FocusField focus = FocusField.none;

  // Values
  String amount = '';
  String category = '';
  String account = '';
  String note = '';
  DateTime selectedDateTime = DateTime.now();

  String get formattedDate {
    final date = "${selectedDateTime.day.toString().padLeft(2, '0')}/${selectedDateTime.month.toString().padLeft(2, '0')}/${selectedDateTime.year}";
    final weekday = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][selectedDateTime.weekday - 1];
    return "$date ($weekday)";
  }

  Future<void> _pickDate() async {
    noteFocusNode.unfocus();
    FocusScope.of(context).unfocus();
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        selectedDateTime = DateTime(date.year, date.month, date.day);
      });
      noteFocusNode.unfocus();
    }
  }
  void _setFocus(FocusField f) {
    if (f == FocusField.amount || f == FocusField.category || f == FocusField.account) {
      FocusScope.of(context).unfocus();
    }
    setState(() => focus = f);
  }

  @override
  Widget build(BuildContext context) {
    final divider = Divider(color: Colors.grey.shade300, height: 1);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text("Expense"),
        actions: const [Padding(padding: EdgeInsets.only(right: 12), child: Icon(Icons.star_border))],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
          _setFocus(FocusField.none);
        },
        child: Stack(
          children: [
            // Main form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Segmented(
                    index: selectedTab,
                    onChanged: (i) => setState(() => selectedTab = i),
                  ),
                  const SizedBox(height: 16),

                  // Date row
                  FormRow(
                    label: "Date",
                    value: formattedDate,
                    selected: false,
                    onTap: _pickDate,
                  ),
                  divider,

                  // Amount
                  FormRow(
                    label: "Amount",
                    value: amount,
                    selected: focus == FocusField.amount,
                    onTap: () => _setFocus(FocusField.amount),
                  ),
                  divider,

                  // Category
                  FormRow(
                    label: "Category",
                    value: category,
                    selected: focus == FocusField.category,
                    onTap: () => _setFocus(FocusField.category),
                  ),
                  divider,

                  // Account
                  FormRow(
                    label: "Account",
                    value: account,
                    selected: focus == FocusField.account,
                    onTap: () => _setFocus(FocusField.account),
                  ),
                  divider,

                  // Note (TextField)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 90,
                          child: Text("Note", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15, fontWeight: FontWeight.w500)),
                        ),
                        Expanded(
                          child: Focus(
                            onFocusChange: (hasFocus) {
                              if (hasFocus && focus != FocusField.none) {
                                setState(() => focus = FocusField.none);
                              }
                            },
                            child: TextField(
                              focusNode: noteFocusNode,
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, fontSize: 15),
                              decoration: InputDecoration(
                                hintText: "Enter note...",
                                hintStyle: TextStyle(fontWeight: FontWeight.w500),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 8),
                              ),
                              maxLines: 2,
                              onChanged: (v) => setState(() => note = v),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  divider,

                  const SizedBox(height: 14),

                  // const Spacer(),

                  // Buttons (stay above bottom panels)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Theme.of(context).colorScheme.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            // Validation logic
                            String? error;
                            if (amount.trim().isEmpty) {
                              error = 'Amount is required.';
                            } else if (category.trim().isEmpty) {
                              error = 'Category is required.';
                            } else if (account.trim().isEmpty) {
                              error = 'Account is required.';
                            } else if (selectedDateTime == null) {
                              error = 'Date is required.';
                            }
                            if (error != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error), backgroundColor: Colors.red)
                              );
                              return;
                            }
                            // Log all values to the console
                            print('--- Expense Entry ---');
                            print('Type: ${selectedTab == 0 ? "Income" : selectedTab == 1 ? "Expense" : "Transfer"}');
                            print('Date: $formattedDate');
                            print('Amount: $amount');
                            print('Category: $category');
                            print('Account: $account');
                            print('Note: $note');
                            print('---------------------');
                          },
                          child: const Text("Save"),
                        ),
                      ),
                      const SizedBox(width: 12)
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            // Bottom panels
            if (focus != FocusField.none)
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: switch (focus) {
                    FocusField.amount => NumberPad(
                        key: const ValueKey('pad'),
                        onAppend: (s) => setState(() => amount += s),
                        onDelete: () => setState(() {
                          if (amount.isNotEmpty) amount = amount.substring(0, amount.length - 1);
                        }),
                        onDone: () => _setFocus(FocusField.none),
                      ),
                    FocusField.category => selectedTab == 0
                        ? IncomeCategoryPanel(
                            key: const ValueKey('income_cat'),
                            onClose: () => _setFocus(FocusField.none),
                            onPick: (v) => setState(() {
                              category = v;
                              _setFocus(FocusField.none);
                            }),
                          )
                        : selectedTab == 2
                            ? TransferCategoryPanel(
                                key: const ValueKey('transfer_cat'),
                                onClose: () => _setFocus(FocusField.none),
                                onPick: (v) => setState(() {
                                  category = v;
                                  _setFocus(FocusField.none);
                                }),
                              )
                            : CategoryPanel(
                                key: const ValueKey('cat'),
                                onClose: () => _setFocus(FocusField.none),
                                onPick: (v) => setState(() {
                                  category = v;
                                  _setFocus(FocusField.none);
                                }),
                              ),
                    FocusField.account => AccountPanel(
                        key: const ValueKey('acc'),
                        onClose: () => _setFocus(FocusField.none),
                        onPick: (v) => setState(() {
                          account = v;
                          _setFocus(FocusField.none);
                        }),
                      ),
                    _ => const SizedBox.shrink(),
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}