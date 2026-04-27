import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  Future<void> fetchUserProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _user = await ApiService.getUserProfile();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _user = null;
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateUserProfile(Map<String, dynamic> userData) async {
    try {
      final success = await ApiService.updateUserProfile(userData);
      if (success) {
        await fetchUserProfile();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  Future<bool> processPayment(String courseId, double amount) async {
    try {
      return await ApiService.processPayment(courseId, amount);
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
