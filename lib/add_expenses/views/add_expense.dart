import 'package:expense_tracker/add_expenses/blocs/create_categorybloc/create_category_bloc.dart';
import 'package:expense_tracker/add_expenses/blocs/create_expensebloc/create_expense_bloc.dart';
import 'package:expense_tracker/add_expenses/blocs/get_categoriesbloc/get_categories_bloc.dart';
import 'package:expense_tracker/add_expenses/views/category_create.dart';
import 'package:expenses_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final TextEditingController expenseController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  late Expense expense;
  bool isLoading = false;

  @override
  void initState() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    super.initState();
    expense = Expense.empty;
    expense.expenseId = const Uuid().v1();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateExpenseBloc, CreateExpenseState>(
      listener: (context, state) {
        if (state is CreateExpenseLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is CreateExpenseSuccess) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
        } else if (state is CreateExpenseFailure) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
          body: BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
            builder: (context, state) {
              if (state is GetCategoriesSuccess) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Add Expenses',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildExpenseField(context),
                        const SizedBox(height: 16),
                        _buildCategoryField(context, state),
                        const SizedBox(height: 16),
                        _buildDateField(context),
                        const SizedBox(height: 32),
                        _buildSaveButton(context),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
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
          prefixIcon: const Icon(
            FontAwesomeIcons.dollarSign,
            size: 16,
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryField(BuildContext context, GetCategoriesSuccess state) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextFormField(
            readOnly: true,
            controller: categoryController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              prefixIcon: expense.category == Category.empty
                  ? const Icon(
                      FontAwesomeIcons.list,
                      size: 16,
                      color: Colors.grey,
                    )
                  : Image.asset(
                      'assets/${expense.category.icon}',
                      scale: 2,
                      color: Color(expense.category.color),
                    ),
              suffixIcon: IconButton(
                onPressed: () async {
                  final result = await showDialog<Category>(
                    context: context,
                    builder: (ctx) => BlocProvider.value(
                      value: context.read<CreateCategoryBloc>(),
                      child: CategoryCreate(),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      state.categories.insert(0, result);
                    });
                  }
                },
                icon: const Icon(
                  FontAwesomeIcons.plus,
                  size: 16,
                  color: Colors.grey,
                ),
              ),
              hintText: 'Category',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Container(
          height: 200,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: state.categories.length,
              itemBuilder: (context, int i) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        expense.category = state.categories[i];
                        categoryController.text = expense.category.name;
                      });
                    },
                    leading: Image.asset(
                      'assets/${state.categories[i].icon}',
                      scale: 2,
                      color: Color(state.categories[i].color),
                    ),
                    title: Text(state.categories[i].name),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
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
            initialDate: expense.date,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          );
          if (newDate != null) {
            setState(() {
              expense.date = newDate;
              dateController.text = DateFormat('dd/MM/yyyy').format(newDate);
            });
          }
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(
            FontAwesomeIcons.clock,
            size: 16,
            color: Colors.grey,
          ),
          hintText: 'Date',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: kToolbarHeight,
      child: isLoading ? const Center(child: CircularProgressIndicator()) : TextButton(
        onPressed: () {
          setState(() {
            expense.amount = int.tryParse(expenseController.text) ?? 0;
          });
          context.read<CreateExpenseBloc>().add(CreateExpense(expense));
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Save',
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
      ),
    );
  }
}
