abstract class LocalStorage {
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);
  Future<void> setBool(String key, bool value);
  Future<bool?> getBool(String key);
  Future<void> setInt(String key, int value);
  Future<int?> getInt(String key);
  Future<void> setDouble(String key, double value);
  Future<double?> getDouble(String key);
  Future<void> remove(String key);
  Future<void> clear();
}

class LocalStorageImpl implements LocalStorage {
  // Implementation will use shared_preferences package
  
  @override
  Future<void> setString(String key, String value) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString(key, value);
  }
  
  @override
  Future<String?> getString(String key) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // return prefs.getString(key);
    return null;
  }
  
  @override
  Future<void> setBool(String key, bool value) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setBool(key, value);
  }
  
  @override
  Future<bool?> getBool(String key) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // return prefs.getBool(key);
    return null;
  }
  
  @override
  Future<void> setInt(String key, int value) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setInt(key, value);
  }
  
  @override
  Future<int?> getInt(String key) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // return prefs.getInt(key);
    return null;
  }
  
  @override
  Future<void> setDouble(String key, double value) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setDouble(key, value);
  }
  
  @override
  Future<double?> getDouble(String key) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // return prefs.getDouble(key);
    return null;
  }
  
  @override
  Future<void> remove(String key) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove(key);
  }
  
  @override
  Future<void> clear() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
  }
} 