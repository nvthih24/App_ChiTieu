import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(
  typeId: 1,
) // Lưu ý: typeId phải khác 0 (vì 0 đã dùng cho Transaction rồi)
class Category extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int iconCode; // Chúng ta lưu mã số của Icon (IconData.codePoint)

  @HiveField(3)
  final int colorValue; // Chúng ta lưu mã màu (Color.value)

  @HiveField(4)
  final String type; // 'income' hoặc 'expense'

  Category({
    required this.id,
    required this.name,
    required this.iconCode,
    required this.colorValue,
    required this.type,
  });
}
