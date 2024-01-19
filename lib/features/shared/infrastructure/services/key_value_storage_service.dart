abstract class KeyValueStorageService {
  Future<void> setValueValue<T>(String key, T value);
  Future<T?> getValue<T>(String key);

  Future<bool> removeKey(String key);
}
