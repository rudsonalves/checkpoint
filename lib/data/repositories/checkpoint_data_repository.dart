import 'dart:developer';

import 'package:result_dart/result_dart.dart';

import '/core/extensions/string_extension.dart';
import '/core/services/secure_storage/local_secure_storage.dart';
import '/domain/entities/checkpoint/checkpoint_data.dart';
import '/domain/entities/checkpoint/checkpoint_values/base_checkpoint_values.dart';
import '/domain/repositories/checkpoint_data_repository.dart';

class CheckpointDataRepositoryImpl implements CheckpointDataRepository {
  final LocalSecureStorage _secureStorage;

  CheckpointDataRepositoryImpl(this._secureStorage);

  static const String _storageKey = 'checkpoint';

  CheckpointData _checkpointData = CheckpointData.empty();

  @override
  CheckpointData get checkpointData => _checkpointData;

  @override
  AsyncResult<CheckpointData> getCheckpointData() async {
    final result = await _secureStorage.read(_storageKey);

    if (result is Failure) {
      _checkpointData = CheckpointData.empty();
      return Failure(result.exceptionOrNull() ?? Exception('Internal Error'));
    }

    final source = (result as Success).getOrNull() as String;

    final checkpointData = CheckpointData.fromJson(source);

    final sections = <CheckpointStage, CheckpointSectionData>{};
    for (final stage in [
      CheckpointStage.createPersonalAccount,
      CheckpointStage.createBusinessAccount,
      CheckpointStage.registerBusinessPartners,
    ]) {
      final key = 'checkpoint_${stage.stageName}';
      final jsonStr = (await _secureStorage.read(key)).getOrNull();

      if (jsonStr != null && jsonStr.isNotEmpty) {
        try {
          sections[stage] = CheckpointSectionData.fromJson(
            stage: stage,
            json: jsonStr,
          );
        } catch (err) {
          // Ignore
        }
      }
    }
    _checkpointData = checkpointData.copyWith(sections: sections);

    return Success(_checkpointData);
  }

  @override
  AsyncResult<Unit> createCheckpointSection<T extends BaseCheckpointValues>(
    T values,
  ) async {
    final stage = values.stage;

    if (_checkpointData.hasSectionData(stage)) {
      return Success(unit);
    }

    final sections = Map<CheckpointStage, CheckpointSectionData>.from(
      _checkpointData.sections,
    );
    sections[stage] = CheckpointSection<T>(values: values);

    _checkpointData = _checkpointData.copyWith(
      currentStage: stage,
      sections: sections,
    );

    return await saveCheckpointData();
  }

  @override
  AsyncResult<Unit> saveCheckpointData() async {
    if (!_checkpointData.hasAnyDirtyFields) return Success(unit);

    return await _secureStorage
        .write(_storageKey, _checkpointData.toJson())
        .flatMap((_) async {
          for (final entry in _checkpointData.sections.entries) {
            final sectionData = entry.value;

            if (sectionData is CheckpointSection &&
                sectionData.values.isDirty) {
              final key = '${_storageKey}_${entry.key.stageName}';
              await _secureStorage.write(key, sectionData.toJson());
            }
          }

          return Success(unit);
        });
  }

  @override
  AsyncResult<Unit> syncWithApi() async {
    try {
      if (!_checkpointData.hasAnyDirtyFields) return Success(unit);
      await Future.delayed(const Duration(milliseconds: 800));

      log('----------Not implemented----------');
      log(_checkpointData.toJson());
      log('-----------------------------------');

      return const Success(unit);
    } catch (err) {
      return Failure(Exception('Erro na sincronização: $err'));
    }
  }

  @override
  bool hasSectionData(CheckpointStage stage) {
    return _checkpointData.hasSectionData(stage);
  }

  @override
  AsyncResult<Unit> clearCheckpointData({String? cpf}) async {
    try {
      _checkpointData = CheckpointData.empty();
      if (cpf == null) return await _secureStorage.delete(_storageKey);

      _checkpointData = CheckpointData.newPerson();
      _checkpointData.personalAccountValues!.cpf = cpf.onlyNumbers();

      return saveCheckpointData();
    } catch (err) {
      log(err.toString());
      return Failure(Exception('Erro ao limpar dados: $err'));
    }
  }
}
