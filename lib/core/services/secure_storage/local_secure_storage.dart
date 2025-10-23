import 'package:result_dart/result_dart.dart';

abstract class LocalSecureStorage {
  AsyncResult<Unit> write(String key, String value);
  AsyncResult<String> read(String key);
  AsyncResult<Unit> delete(String key);
}
