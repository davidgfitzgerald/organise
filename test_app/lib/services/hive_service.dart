import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';

class HiveService {
  static const String _userBoxName = 'userBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserAdapter());
    await Hive.openBox<User>(_userBoxName);
  }

  static Box<User> get _userBox => Hive.box<User>(_userBoxName);

  static Future<void> saveUser(User user) async {
    await _userBox.put('currentUser', user);
  }

  static User? getUser() {
    return _userBox.get('currentUser');
  }

  static Future<void> deleteUser() async {
    await _userBox.delete('currentUser');
  }
}
