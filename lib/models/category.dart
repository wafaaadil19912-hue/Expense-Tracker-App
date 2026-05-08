import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
class Category extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int colorValue;

  @HiveField(3)
  int iconCodePoint;

  @HiveField(4)
  bool isCustom;

  Category({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.iconCodePoint,
    this.isCustom = false,
  });

  Color get color => Color(colorValue);
  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');
}
