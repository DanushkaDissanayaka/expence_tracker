import 'package:expenses_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Person> persons = [
  Person(
    personId: '1',
    name: 'Sam',
    icon: const Icon(FontAwesomeIcons.personDress),
    color: Colors.pink,
  ),
  Person(
    personId: '2',
    name: 'Shawn',
    icon: const Icon(FontAwesomeIcons.person),
    color: Colors.blue,
  ),
];

BudgetType saving = BudgetType(
  budgetTypeId: '1',
  name: 'Saving',
  icon: const Icon(Icons.savings_outlined),
  color: Color(0xFFF59E0B),
);

BudgetType income = BudgetType(
  budgetTypeId: '2',
  name: 'Income',
  icon: const Icon(Icons.trending_up),
  color: Color(0xFF10B981),
);

BudgetType expenses = BudgetType(
  budgetTypeId: '3',
  name: 'Expenses',
  icon: const Icon(Icons.trending_down),
  color: Color(0xFFEF4444),
);

List<BudgetType> budgetTypeOption = [saving, income, expenses];

List<SubCategory> subCategories = [
  // Fixed expenses
  SubCategory(
    categoryId: '1',
    name: 'House rental',
    icon: const Icon(FontAwesomeIcons.house),
    parentId: '1',
  ),
  SubCategory(
    categoryId: '2',
    name: 'Electricity bill',
    icon: const Icon(FontAwesomeIcons.bolt),
    parentId: '1',
  ),
  SubCategory(
    categoryId: '3',
    name: 'Water bill',
    icon: const Icon(FontAwesomeIcons.water),
    parentId: '1',
  ),
  SubCategory(
    categoryId: '4',
    name: 'Loan',
    icon: const Icon(FontAwesomeIcons.moneyBill),
    parentId: '1',
  ),
  SubCategory(
    categoryId: '5',
    name: 'Broadband Bill',
    icon: const Icon(FontAwesomeIcons.wifi),
    parentId: '1',
  ),
  SubCategory(
    categoryId: '6',
    name: 'Cellphone Reload',
    icon: const Icon(FontAwesomeIcons.mobile),
    parentId: '1',
  ),
  SubCategory(
    categoryId: '7',
    name: 'Credit card',
    icon: const Icon(FontAwesomeIcons.creditCard),
    parentId: '1',
  ),

  // House Maintenance
  SubCategory(
    categoryId: '8',
    name: 'Groceries',
    icon: const Icon(FontAwesomeIcons.basketShopping),
    parentId: '2',
  ),
  SubCategory(
    categoryId: '10',
    name: 'LP Gas',
    icon: const Icon(FontAwesomeIcons.fire),
    parentId: '2',
  ),
  SubCategory(
    categoryId: '11',
    name: 'Family Support',
    icon: const Icon(FontAwesomeIcons.handHoldingHeart),
    parentId: '2',
  ),
  SubCategory(
    categoryId: '12',
    name: 'Fast Food',
    icon: const Icon(FontAwesomeIcons.burger),
    parentId: '2',
  ),
  // Activity
  SubCategory(
    categoryId: '13',
    name: 'Food/Dining Out',
    icon: const Icon(FontAwesomeIcons.utensils),
    parentId: '3',
  ),
  SubCategory(
    categoryId: '14',
    name: 'Entertainment / Movie',
    icon: const Icon(FontAwesomeIcons.film),
    parentId: '3',
  ),
  SubCategory(
    categoryId: '15',
    name: 'Travel',
    icon: const Icon(FontAwesomeIcons.plane),
    parentId: '3',
  ),
  SubCategory(
    categoryId: '16',
    name: 'Other activities',
    icon: const Icon(FontAwesomeIcons.iceCream),
    parentId: '3',
  ),
  SubCategory(
    categoryId: '17',
    name: 'Shopping',
    icon: const Icon(FontAwesomeIcons.personHalfDress),
    parentId: '3',
  ),
  // Personal
  SubCategory(
    categoryId: '18',
    name: 'Medical + Health Insurance',
    icon: const Icon(FontAwesomeIcons.heart),
    parentId: '4',
  ),
  SubCategory(
    categoryId: '19',
    name: 'Pocket Money',
    icon: const Icon(FontAwesomeIcons.wallet),
    parentId: '4',
  ),
  SubCategory(
    categoryId: '20',
    name: 'Fitness',
    icon: const Icon(FontAwesomeIcons.dumbbell),
    parentId: '4',
  ),
  // Transport
  SubCategory(
    categoryId: '21',
    name: 'Car Maintenance/Insurance',
    icon: const Icon(FontAwesomeIcons.car),
    parentId: '5',
  ),
  SubCategory(
    categoryId: '22',
    name: 'Gasoline',
    icon: const Icon(FontAwesomeIcons.gasPump),
    parentId: '5',
  ),
  SubCategory(
    categoryId: '23',
    name: 'Public Transportation / Taxi',
    icon: const Icon(FontAwesomeIcons.taxi),
    parentId: '5',
  ),
  SubCategory(
    categoryId: '24',
    name: 'Parking',
    icon: const Icon(FontAwesomeIcons.squareParking),
    parentId: '5',
  ),
];

List<SubCategory> subCategoriesIncome = [
  SubCategory(
    categoryId: '25',
    name: 'Salary',
    icon: const Icon(FontAwesomeIcons.moneyBill),
    parentId: '6',
  ),
  SubCategory(
    categoryId: '26',
    name: 'Business',
    icon: const Icon(FontAwesomeIcons.briefcase),
    parentId: '6',
  ),
  SubCategory(
    categoryId: '27',
    name: 'Allowance',
    icon: const Icon(FontAwesomeIcons.gift),
    parentId: '6',
  ),
  SubCategory(
    categoryId: '28',
    name: 'Other Income',
    icon: const Icon(FontAwesomeIcons.coins),
    parentId: '6',
  ),
  SubCategory(
    categoryId: '29',
    name: 'Petty Cash',
    icon: const Icon(FontAwesomeIcons.moneyCheckDollar),
    parentId: '6',
  ),
];

List<SubCategory> subCategoriesSaving = [
  SubCategory(
    categoryId: '30',
    name: 'Fixed Deposit',
    icon: const Icon(FontAwesomeIcons.coins),
    parentId: '7',
  ),
  SubCategory(
    categoryId: '31',
    name: 'Bank Savings',
    icon: const Icon(FontAwesomeIcons.piggyBank),
    parentId: '7',
  ),
  SubCategory(
    categoryId: '32',
    name: 'Investment',
    icon: const Icon(FontAwesomeIcons.arrowUpRightDots),
    parentId: '7',
  ),
];

List<SubCategory> parentCategories = [
  SubCategory(
    categoryId: '1',
    name: 'Fixed expenses',
    icon: const Icon(FontAwesomeIcons.dollarSign),
    parentId: null,
  ),
  SubCategory(
    categoryId: '2',
    name: 'House Maintenance',
    icon: const Icon(FontAwesomeIcons.house),
    parentId: null,
  ),
  SubCategory(
    categoryId: '3',
    name: 'Activity',
    icon: const Icon(FontAwesomeIcons.iceCream),
    parentId: null,
  ),
  SubCategory(
    categoryId: '4',
    name: 'Personal',
    icon: const Icon(FontAwesomeIcons.user),
    parentId: null,
  ),
  SubCategory(
    categoryId: '5',
    name: 'Transport',
    icon: const Icon(FontAwesomeIcons.planeUp),
    parentId: null,
  ),
  SubCategory(
    categoryId: '6',
    name: 'Income',
    icon: const Icon(FontAwesomeIcons.wallet),
    parentId: null,
  ),
  SubCategory(
    categoryId: '7',
    name: 'Savings',
    icon: const Icon(FontAwesomeIcons.piggyBank),
    parentId: null,
  ),
];

List<ParentCategory> getCategories() {
  List<ParentCategory> categoriesWithSub = [];

  for (var parent in parentCategories) {
    var subs = subCategories
        .where((sub) => sub.parentId == parent.categoryId.toString())
        .toList();
    categoriesWithSub.add(ParentCategory(parent: parent, children: subs));
  }
  return categoriesWithSub;
}
