import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _storage = FlutterSecureStorage();

  Future writeStorageData(String key, String value) async {
    var writeData = await _storage.write(key: key, value: value);
    return writeData;
  }

  Future readStorageData(String key) async {
    var readData = await _storage.read(key: key);
    return readData;
  }

  Future deleteStorageData(String key) async {
    var deleteData = await _storage.delete(key: key);
    return deleteData;
  }
}
