import 'package:flutter/foundation.dart';

class DataProvider with ChangeNotifier {
  bool _hasNewNotifications = false;

  bool get hasNewNotifications => _hasNewNotifications;

  void setNewNotificationsAvailable(bool available) {
    _hasNewNotifications = available;
    notifyListeners();
  }
}
