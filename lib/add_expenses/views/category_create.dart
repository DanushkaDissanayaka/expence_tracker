import 'package:expense_tracker/add_expenses/blocs/create_categorybloc/create_category_bloc.dart';
import 'package:expenses_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:uuid/uuid.dart';

class CategoryCreate extends StatefulWidget {
  const CategoryCreate({super.key});

  @override
  State<CategoryCreate> createState() => _CategoryCreateState();
}

class _CategoryCreateState extends State<CategoryCreate> {
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;
  Color selectedColor = Colors.white;
  String selectedIcon = '';
  final List<String> myCategoriesIcons = [
    'entertainment.png',
    'food.png',
    'home.png',
    'pet.png',
    'shopping.png',
    'tech.png',
    'travel.png',
  ];
  bool isExpanded = false;
  Category newCategory = Category.empty;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<CreateCategoryBloc>(),
      child: BlocListener<CreateCategoryBloc, CreateCategoryState>(
        listener: (context, state) {
          if (state is CreateCategorySuccess) {
            Navigator.pop(context, newCategory);
          } else if (state is CreateCategoryLoading) {
            setState(() {
              isLoading = true;
            });
          }
        },
        child: AlertDialog(
          title: const Text(
            'Create a Category',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => setState(() => isExpanded = !isExpanded),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Text(selectedIcon.isEmpty ? 'Icon' : selectedIcon),
                        const Spacer(),
                        Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                if (isExpanded)
                  SizedBox(
                    height: 120,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                          ),
                      itemCount: myCategoriesIcons.length,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () => setState(
                            () => selectedIcon = myCategoriesIcons[i],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: selectedIcon == myCategoriesIcons[i]
                                    ? Colors.green
                                    : Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/${myCategoriesIcons[i]}',
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => _showColorPicker(context),
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: selectedColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: const Text('Color'),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: kToolbarHeight,
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : TextButton(
                          onPressed: () {
                            setState(() {
                              newCategory.categoryId = const Uuid().v1();
                              newCategory.name = nameController.text;
                              newCategory.icon = selectedIcon.isNotEmpty
                                  ? selectedIcon
                                  : 'home.png';
                              newCategory.color = selectedColor.toARGB32();
                            });

                            context.read<CreateCategoryBloc>().add(
                              CreateCategory(newCategory),
                            );
                            // Navigator.pop(context, newCategory.name);
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx2) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ColorPicker(
                pickerColor: selectedColor,
                onColorChanged: (color) =>
                    setState(() => selectedColor = color),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx2),
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
              ),
            ],
          ),
        );
      },
    );
  }
}
