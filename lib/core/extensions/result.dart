import 'package:result_dart/result_dart.dart';

/// Executa uma função síncrona e encapsula seu resultado em [Result].
Result<T> toResult<T extends Object>(T Function() action) {
  try {
    return Success(action());
  } catch (err) {
    return Failure(Exception(err));
  }
}

/// Executa uma função assíncrona e encapsula seu resultado em [AsyncResult].
Future<Result<T>> toAsyncResult<T extends Object>(
  Future<T> Function() action,
) async {
  try {
    final value = await action();
    return Success(value);
  } catch (err) {
    return Failure(Exception(err));
  }
}
