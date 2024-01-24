// To parse this JSON data, do
//
//     final catrgoryModel = catrgoryModelFromJson(jsonString);

import 'dart:convert';

CatergoryModel catergoryModelFromJson(String str) =>
    CatergoryModel.fromJson(json.decode(str));

class CatergoryModel {
  List<Category> categories;

  CatergoryModel({
    required this.categories,
  });

  factory CatergoryModel.fromJson(Map<String, dynamic> json) => CatergoryModel(
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
      );
}

class Category {
  String name;
  List<String> subcategories;

  Category({
    required this.name,
    required this.subcategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
        subcategories: List<String>.from(json["subcategories"].map((x) => x)),
      );
}
