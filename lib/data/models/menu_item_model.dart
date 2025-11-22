import 'package:equatable/equatable.dart';

enum DietaryType { veg, nonVeg, vegan, eggetarian }

class MenuItem extends Equatable {
  final String name;
  final DietaryType type;
  final List<String> allergens;
  final String? nutritionalInfo;

  const MenuItem({
    required this.name,
    required this.type,
    this.allergens = const [],
    this.nutritionalInfo,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'] as String,
      type: _parseDietaryType(json['type'] as String),
      allergens: (json['allergens'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      nutritionalInfo: json['nutritional_info'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': _dietaryTypeToString(type),
      'allergens': allergens,
      'nutritional_info': nutritionalInfo,
    };
  }

  static DietaryType _parseDietaryType(String type) {
    switch (type.toLowerCase()) {
      case 'veg':
        return DietaryType.veg;
      case 'non_veg':
      case 'nonveg':
        return DietaryType.nonVeg;
      case 'vegan':
        return DietaryType.vegan;
      case 'eggetarian':
        return DietaryType.eggetarian;
      default:
        return DietaryType.veg;
    }
  }

  static String _dietaryTypeToString(DietaryType type) {
    switch (type) {
      case DietaryType.veg:
        return 'veg';
      case DietaryType.nonVeg:
        return 'non_veg';
      case DietaryType.vegan:
        return 'vegan';
      case DietaryType.eggetarian:
        return 'eggetarian';
    }
  }

  @override
  List<Object?> get props => [name, type, allergens, nutritionalInfo];
}
