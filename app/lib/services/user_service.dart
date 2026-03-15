import 'package:flutter/material.dart';
import 'package:menstrudel/database/repositories/user_repository.dart';
import 'package:menstrudel/models/app/user_entry.dart';

/// This app does not have users in the sense of logins and cloud. 
/// In this case, a user is just the user of the app. 
/// This serivce just lets the app get date of birth, name etc.
class UserService extends ChangeNotifier {
  final UserRepository _userRepo;
  
  UserService(this._userRepo) {
    loadUser();
  }

  UserEntry? _user;
  bool _isLoading = false;

  /// The user data.
  UserEntry? get user => _user;
  /// Whether service is loading
  bool get isLoading => _isLoading;

  /// Loads user data.
  Future<void> loadUser() async {
    if (_isLoading) return;

    debugPrint('UserService: Starting loading user.');

    _isLoading = true;
    notifyListeners();

    _user = await _userRepo.getUser();

    _isLoading = false;    
    notifyListeners();
  }
}