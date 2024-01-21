// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

import '../../../auth/domain/entities/user.dart';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  final String id;
  final String title;
  final double price;
  final String description;
  final String slug;
  final int stock;
  final List<String> sizes;
  final String gender;
  // final List<String> tags;
  final List<String> images;
  final User? user;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.slug,
    required this.stock,
    required this.sizes,
    required this.gender,
    // this.tags = const [],
    required this.images,
    required this.user,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        title: json["title"],
        price: json["price"],
        description: json["description"],
        slug: json["slug"],
        stock: json["stock"],
        sizes: List<String>.from(json["sizes"].map((x) => x)),
        gender: json["gender"],
        // tags: List<String>.from(json["tags"].map((x) => tags.map(x)!)),
        images: List<String>.from(json["images"].map((x) => x)),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "description": description,
        "slug": slug,
        "stock": stock,
        "sizes": List<dynamic>.from(sizes.map((x) => x)),
        "gender": gender,
        // "tags": List<dynamic>.from(tags.map((x) => tagValues.reverse[x])),
        "images": List<dynamic>.from(images.map((x) => x)),
        "user": user?.toJson(),
      };
}
