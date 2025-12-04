import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'menu_item_model.dart';

enum MealState {
  past,
  active,
  upcoming,
}

class Meal extends Equatable {
  final String name;
  final String icon;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final List<MenuItem> vegItems;
  final List<MenuItem> nonVegItems;
  final List<MenuItem> jainItems;
  final String? specialNoteVeg;
  final String? specialNoteNonVeg;

  const Meal({
    required this.name,
    required this.icon,
    required this.startTime,
    required this.endTime,
    required this.vegItems,
    required this.nonVegItems,
    required this.jainItems,
    this.specialNoteVeg,
    this.specialNoteNonVeg,
  });

  bool get isActive {
    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;
    return nowMinutes >= startMinutes && nowMinutes < endMinutes;
  }

  bool get isPast {
    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;
    return nowMinutes >= endMinutes;
  }

  MealState get state {
    if (isPast) return MealState.past;
    if (isActive) return MealState.active;
    return MealState.upcoming;
  }

  // Get items based on dietary preference
  List<MenuItem> getItems(bool isVeg) {
    if (isVeg) {
      // Combine veg and jain items
      return [...vegItems, ...jainItems];
    } else {
      // Show only non-veg items
      return nonVegItems;
    }
  }

  // Get special note based on dietary preference
  String? getSpecialNote(bool isVeg) {
    return isVeg ? specialNoteVeg : specialNoteNonVeg;
  }

  factory Meal.fromJson(String mealName, Map<String, dynamic> json) {
    return Meal(
      name: json['name'] as String? ?? mealName,
      icon: json['icon'] as String? ?? 'restaurant_menu',
      startTime: _parseTime(json['start_time'] as String),
      endTime: _parseTime(json['end_time'] as String),
      vegItems: _parseMenuItems(json['veg']),
      nonVegItems: _parseMenuItems(json['non_veg']),
      jainItems: _parseMenuItems(json['jain']),
      specialNoteVeg: json['special_note_veg'] as String?,
      specialNoteNonVeg: json['special_note_non_veg'] as String?,
    );
  }

  /// Parses menu items from either:
  /// - A List of strings: ["Item 1", "Item 2", "Item 3"]
  /// - A single comma-separated string: "Item 1, Item 2, Item 3"
  static List<MenuItem> _parseMenuItems(dynamic data) {
    if (data == null) return [];

    List<String> items = [];

    if (data is List) {
      // Check if it's a list with a single comma-separated string
      if (data.length == 1 && data[0] is String && data[0].contains(',')) {
        items = (data[0] as String)
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
      } else {
        // Normal list of items
        items = data.map((item) => item.toString().trim()).toList();
      }
    } else if (data is String) {
      // Single comma-separated string
      items = data
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }

    return items.map((item) => MenuItem(name: item)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
      'start_time':
          '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
      'end_time':
          '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
      'veg': vegItems.map((item) => item.name).toList(),
      'non_veg': nonVegItems.map((item) => item.name).toList(),
      'jain': jainItems.map((item) => item.name).toList(),
      'special_note_veg': specialNoteVeg,
      'special_note_non_veg': specialNoteNonVeg,
    };
  }

  static TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  @override
  List<Object?> get props => [
        name,
        icon,
        startTime,
        endTime,
        vegItems,
        nonVegItems,
        jainItems,
        specialNoteVeg,
        specialNoteNonVeg
      ];
}
