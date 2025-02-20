import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart'; // Ensure this is correct!

@JsonSerializable()
class User {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "phoneNumber")
  int? phoneNumber;

  // Constructor
  User({
    this.id,
    this.name,
    this.phoneNumber,
  });

  // Factory method for JSON deserialization
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  // Method for JSON serialization
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
