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
  final List<MenuItem> items;
  final String? specialNote;

  const Meal({
    required this.name,
    required this.icon,
    required this.startTime,
    required this.endTime,
    required this.items,
    this.specialNote,
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

  factory Meal.fromJson(String mealName, Map<String, dynamic> json) {
    return Meal(
      name: json['name'] as String? ?? mealName,
      icon: json['icon'] as String? ?? 'restaurant_menu',
      startTime: _parseTime(json['start_time'] as String),
      endTime: _parseTime(json['end_time'] as String),
      items: (json['items'] as List<dynamic>)
          .map((item) => MenuItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      specialNote: json['special_note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
      'start_time':
          '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
      'end_time':
          '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
      'items': items.map((item) => item.toJson()).toList(),
      'special_note': specialNote,
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
  List<Object?> get props =>
      [name, icon, startTime, endTime, items, specialNote];
}
