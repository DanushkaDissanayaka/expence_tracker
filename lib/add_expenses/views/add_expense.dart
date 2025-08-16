import 'package:expense_tracker/add_expenses/blocs/create_categorybloc/create_category_bloc.dart';
import 'package:expense_tracker/add_expenses/views/category_create.dart';
import 'package:expenses_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final TextEditingController expenseController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surface),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Add Expenses', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
              const SizedBox(height: 16),
              _buildExpenseField(context),
              const SizedBox(height: 16),
              _buildCategoryField(context),
              const SizedBox(height: 16),
              _buildDateField(context),
              const SizedBox(height: 32),
              _buildSaveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpenseField(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextFormField(
        controller: expenseController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(FontAwesomeIcons.dollarSign, size: 16, color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildCategoryField(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextFormField(
        readOnly: true,
        controller: categoryController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(FontAwesomeIcons.list, size: 16, color: Colors.grey),
          suffixIcon: IconButton(
            onPressed: () async {
              final result = await showDialog<String>(
                context: context,
                builder: (ctx) => BlocProvider.value(
                  value: context.read<CreateCategoryBloc>(),
                  child: CategoryCreate(),
                ),
              );
              if (result != null) {
                setState(() {
                  categoryController.text = result;
                });
              }
            },
            icon: const Icon(FontAwesomeIcons.plus, size: 16, color: Colors.grey),
          ),
          hintText: 'Category',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextFormField(
        controller: dateController,
        textAlignVertical: TextAlignVertical.center,
        readOnly: true,
        onTap: () async {
          DateTime? newDate = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          );
          if (newDate != null) {
            setState(() {
              dateController.text = DateFormat('dd/MM/yyyy').format(newDate);
              selectedDate = newDate;
            });
          }
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(FontAwesomeIcons.clock, size: 16, color: Colors.grey),
          hintText: 'Date',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: kToolbarHeight,
      child: TextButton(
        onPressed: () {
          // TODO: Implement save logic
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('Save', style: TextStyle(fontSize: 22, color: Colors.white)),
      ),
    );
  }
}
