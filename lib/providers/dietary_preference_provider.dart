import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DietaryPreferenceProvider extends ChangeNotifier {
  bool _isVeg = true;
  static const String _dietaryKey = 'dietary_preference';

  bool get isVeg => _isVeg;

  DietaryPreferenceProvider() {
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isVeg = prefs.getBool(_dietaryKey) ?? true; // Default to veg
    notifyListeners();
  }

  Future<void> togglePreference() async {
    _isVeg = !_isVeg;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dietaryKey, _isVeg);
    notifyListeners();
  }

  Future<void> setPreference(bool isVeg) async {
    _isVeg = isVeg;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dietaryKey, isVeg);
    notifyListeners();
  }
}
