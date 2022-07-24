import 'package:flutter/material.dart';

Color getTypeColor(String type) {
  switch (type) {
    case "normal":
      return Colors.green;
    case "fire":
      return Colors.red;
    case "water":
      return Colors.blue;
    case "electric":
      return Colors.yellow;
    case "grass":
      return Colors.green;
    case "ice":
      return Colors.cyan;
    case "fighting":
      return Colors.red;
    case "poison":
      return Colors.purple;
    case "ground":
      return Colors.brown;
    case "flying":
      return Colors.blue;
    case "psychic":
      return Colors.pink;
    case "bug":
      return Colors.yellow;
    case "rock":
      return Colors.brown;
    case "ghost":
      return Colors.purple;
    case "dragon":
      return Colors.purple;
    case "dark":
      return Colors.purple;
    case "steel":
      return Colors.grey;
    case "fairy":
      return Colors.pink;
    default:
      return Colors.grey;
  }
}
