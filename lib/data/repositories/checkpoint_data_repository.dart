import 'package:result_dart/result_dart.dart';

import '/core/extensions/string_extension.dart';
import '/core/services/secure_storage/local_secure_storage.dart';
import '/domain/entities/checkpoint/checkpoint_data.dart';
import '/domain/entities/checkpoint/checkpoint_values/base_checkpoint_values.dart';
import '/domain/repositories/checkpoint_data_repository.dart';

const stageList = [
  CheckpointStage.createPersonalAccount,
  CheckpointStage.createBusinessAccount,
  CheckpointStage.registerBusinessPartners,
];

class CheckpointDataRepositoryImpl implements CheckpointDataRepository {
  final LocalSecureStorage _secureStorage;

  CheckpointDataRepositoryImpl(this._secureStorage);

  static const String _storageKey = 'checkpoint';

  CheckpointData _checkpointData = CheckpointData.empty();

  String _sectionKey(CheckpointStage stage) =>
      '${_storageKey}_${stage.stageName}';

  @override
  CheckpointData get checkpointData => _checkpointData;

  @override
  bool hasSectionData(CheckpointStage stage) =>
      _checkpointData.hasSectionData(stage);

  @override
  AsyncResult<CheckpointData> getCheckpointData() async {
    final result = await _secureStorage.read(_storageKey);

    if (result is Failure) {
      _checkpointData = CheckpointData.empty();
      return Failure(result.exceptionOrNull() ?? Exception('Internal Error'));
    }

    final source = (result as Success).getOrNull() as String;
    final checkpointData = CheckpointData.fromJson(source);

    for (final stage in stageList) {
      final jsonStr = (await _secureStorage.read(
        _sectionKey(stage),
      )).getOrNull();

      if (jsonStr != null && jsonStr.isNotEmpty) {
        try {
          final section = CheckpointSectionData.fromJson(
            stage: stage,
            json: jsonStr,
          );
          checkpointData.setSectionData(stage, section);
        } catch (err) {
          // Invalid section data
        }
      }
    }

    _checkpointData = checkpointData;
    return Success(_checkpointData);
  }

  @override
  AsyncResult<Unit> createCheckpointSection<T extends BaseCheckpointValues>(
    T values,
  ) async {
    final stage = values.stage;

    if (_checkpointData.hasSectionData(stage)) return Success(unit);

    _checkpointData
      ..setSection(stage, values)
      ..moveToStage(stage);

    return await saveCheckpointData();
  }

  @override
  AsyncResult<Unit> saveCheckpointData() async {
    if (!_checkpointData.hasAnyDirtyFields) return Success(unit);

    try {
      await _secureStorage.write(_storageKey, _checkpointData.toJson());

      for (final entry in _checkpointData.sections.entries) {
        final sectionData = entry.value;
        if (sectionData is CheckpointSection && sectionData.values.isDirty) {
          await _secureStorage.write(
            _sectionKey(entry.key),
            sectionData.toJson(),
          );
        }
      }

      _checkpointData.markAllClean();
      return Success(unit);
    } catch (err) {
      return Failure(Exception('Erro ao salvar dados: $err'));
    }
  }

  @override
  AsyncResult<Unit> syncWithApi() async {
    try {
      if (!_checkpointData.hasAnyDirtyFields) return Success(unit);
      await Future.delayed(const Duration(milliseconds: 800));

      // '----- SYNC NOT IMPLEMENTED -----
      return Success(unit);
    } catch (err) {
      return Failure(Exception('Erro na sincronização: $err'));
    }
  }

  @override
  AsyncResult<Unit> clearCheckpointData({String? cpf}) async {
    try {
      _checkpointData = _resetCheckpointData(cpf);
      return await _secureStorage
          .delete(_storageKey)
          .flatMap((_) => saveCheckpointData());
    } catch (err) {
      return Failure(Exception('Erro ao limpar dados: $err'));
    }
  }

  // ---------- Private ----------
  CheckpointData _resetCheckpointData(String? cpf) {
    if (cpf == null) return CheckpointData.empty();

    final data = CheckpointData.newPerson();
    data.personalAccountValues!.cpf = cpf.onlyNumbers();
    return data;
  }
}
