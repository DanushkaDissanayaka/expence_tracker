import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Map<String, dynamic>> transactionData = [
  {
    'icon': const Icon(FontAwesomeIcons.burger, color: Colors.white),
    'color':Colors.yellow[700],
    'name':'food',
    'totalAmount':'-45.00',
    'date':'Today'
  },
  {
    'icon':const Icon(FontAwesomeIcons.bagShopping, color: Colors.white),
    'color':Colors.purple,
    'name':'Shopping',
    'totalAmount':'-235.00',
    'date':'Today'
  },
  {
    'icon':const Icon(FontAwesomeIcons.heartCircleCheck, color: Colors.white),
    'color':Colors.green,
    'name':'Health',
    'totalAmount':'-79.00',
    'date':'Yesterday'
  },
  {
    'icon':const Icon(FontAwesomeIcons.plane, color: Colors.white),
    'color':Colors.blueAccent,
    'name':'Travel',
    'totalAmount':'-79.00',
    'date':'Yesterday'
  },
  {
    'icon':const Icon(FontAwesomeIcons.music, color: Colors.white),
    'color':Colors.red,
    'name':'Entertainment',
    'totalAmount':'-79.00',
    'date':'Yesterday'
  }
];