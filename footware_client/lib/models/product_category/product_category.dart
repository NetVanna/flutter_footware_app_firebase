import 'package:json_annotation/json_annotation.dart';

part 'product_category.g.dart'; // Ensure this is correct!

@JsonSerializable()
class ProductCategory {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "name")
  String? name;

  // Constructor
  ProductCategory({
    this.id,
    this.name,
  });

  // Factory method for JSON deserialization
  factory ProductCategory.fromJson(Map<String, dynamic> json) => _$ProductCategoryFromJson(json);

  // Method for JSON serialization
  Map<String, dynamic> toJson() => _$ProductCategoryToJson(this);
}
