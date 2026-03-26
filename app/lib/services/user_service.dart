import 'package:flutter/material.dart';
import 'package:menstrudel/database/repositories/user_repository.dart';
import 'package:menstrudel/models/app/user_entry.dart';
import 'package:age_calculator/age_calculator.dart';

/// This app does not have users in the sense of logins and cloud. 
/// In this case, a user is just the user of the app. 
/// This serivce just lets the app get date of birth, name, age etc.
class UserService extends ChangeNotifier {
  final UserRepository _userRepo;
  
  UserService(this._userRepo) {
    loadUser();
  }

  UserEntry? _user;
  bool _isLoading = false;
  int _age = 0;

  /// The user data.
  UserEntry? get user => _user;
  /// Whether service is loading
  bool get isLoading => _isLoading;
  /// The users age. If DoB is provided.
  int get age => _age;

  /// Loads user data.
  Future<void> loadUser() async {
    if (_isLoading) return;

    debugPrint('UserService: Starting loading user.');

    _isLoading = true;
    notifyListeners();

    _user = await _userRepo.getUser();

    if (_user != null && _user!.birthDate != null) {
      _age  = AgeCalculator.age(_user!.birthDate!).years;
    }

    _isLoading = false;    
    notifyListeners();
  }
}