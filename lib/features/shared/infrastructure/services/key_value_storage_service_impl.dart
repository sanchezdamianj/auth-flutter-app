import 'package:shared_preferences/shared_preferences.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service.dart';

class KeyValueStorageServiceImpl implements KeyValueStorageService {
  Future<SharedPreferences> getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final prefs = await getSharedPreferences();
    switch (T) {
      case int:
        return prefs.getInt(key) as T?;

      case String:
        return prefs.getString(key) as T?;

      default:
        throw UnimplementedError(
            'Get not implemented for type: ${T.runtimeType}');
    }
  }

  @override
  Future<bool> removeKey(String key) async {
    final pref = await getSharedPreferences();
    return pref.remove(key);
  }

  @override
  Future<void> setValueValue<T>(String key, T value) async {
    final prefs = await getSharedPreferences();
    switch (T) {
      case int:
        prefs.setInt(key, value as int);
        break;
      case String:
        prefs.setString(key, value as String);
        break;
      case double:
        prefs.setDouble(key, value as double);
        break;
      case bool:
        prefs.setBool(key, value as bool);
        break;
      default:
        throw UnimplementedError(
            'Set not implemented for type: ${T.runtimeType}');
    }
  }
}
