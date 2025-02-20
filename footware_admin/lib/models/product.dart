import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart'; // Ensure this is correct!

@JsonSerializable()
class Product {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "description")
  String? description;

  @JsonKey(name: "category")
  String? category;

  @JsonKey(name: "image")
  String? image;

  @JsonKey(name: "price")
  double? price;

  @JsonKey(name: "offer")
  bool? offer;
  @JsonKey(name: "brand")
  String? brand;

  // Constructor
  Product({
    this.id,
    this.name,
    this.description,
    this.category,
    this.image,
    this.price,
    this.offer,
    this.brand,
  });

  // Factory method for JSON deserialization
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  // Method for JSON serialization
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
