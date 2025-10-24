import 'package:result_dart/result_dart.dart';

import '/core/extensions/result.dart';
import '/core/services/secure_storage/local_secure_storage.dart';
import '/domain/entities/checkpoint/checkpoint_data.dart';
import '/domain/entities/checkpoint/checkpoint_values/base_checkpoint_values.dart';
import '/domain/repositories/checkpoint_data_repository.dart';

class CheckpointDataRepositoryImpl implements CheckpointDataRepository {
  final LocalSecureStorage _secureStorage;

  CheckpointDataRepositoryImpl(this._secureStorage);

  static const String _storageKey = 'checkpoint_data';

  CheckpointData _checkpointData = CheckpointData.empty();
  bool _isEdited = false;

  @override
  CheckpointData get checkpointData => _checkpointData;

  @override
  AsyncResult<CheckpointData> getCheckpointData() async {
    return await _secureStorage
        .read(_storageKey)
        .flatMap(
          (source) => toResult(() => CheckpointData.fromJson(source)).fold(
            (checkpoint) {
              _checkpointData = checkpoint;
              return Success(checkpoint);
            },
            (err) {
              _checkpointData = CheckpointData.empty();
              return Failure(Exception('Erro ao carregar dados: $err'));
            },
          ),
        );
    // TODO: Rudson - load from API if no checkpoint data found in local storage
    //       Eventually search the API first!!!
  }

  @override
  AsyncResult<Unit> createCheckpointSection<T extends BaseCheckpointValues>(
    T values,
  ) async {
    final CheckpointStage stage = values.stage;

    if (_checkpointData.hasSectionData(stage)) {
      return Success(unit);
    }

    final updatedSections = Map<CheckpointStage, CheckpointSectionData>.from(
      _checkpointData.sections,
    );
    updatedSections[stage] = CheckpointSection<T>(values: values);
    final newCheckpointData = _checkpointData.copyWith(
      sections: updatedSections,
      currentStage: stage,
    );
    return await saveCheckpointData(newCheckpointData);
  }

  @override
  AsyncResult<Unit> saveCheckpointData(CheckpointData checkpointData) async {
    try {
      final jsonString = checkpointData.toJson();
      final writeResult = await _secureStorage.write(_storageKey, jsonString);

      return writeResult.fold(
        (success) {
          _isEdited = _isEdited || _checkpointData != checkpointData;
          _checkpointData = checkpointData;
          return Success(unit);
        },
        (error) {
          return Failure(Exception('Erro ao salvar dados: $error'));
        },
      );
    } catch (err) {
      return Failure(Exception('Erro ao salvar dados: $err'));
    }
  }

  @override
  AsyncResult<Unit> syncWithApi() async {
    try {
      if (!_isEdited) return Success(unit);
      // TODO: Implementar sincronização com API quando necessário
      _isEdited = false;
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
  AsyncResult<CheckpointData> updateSection({
    required CheckpointStage stage,
    required CheckpointSectionData sectionData,
    CheckpointStage? nextStage,
  }) async {
    try {
      final updatedSections = Map<CheckpointStage, CheckpointSectionData>.from(
        _checkpointData.sections,
      );
      updatedSections[stage] = sectionData;
      final updatedCheckpoint = _checkpointData.copyWith(
        sections: updatedSections,
        currentStage: nextStage ?? stage,
      );
      final saveResult = await saveCheckpointData(updatedCheckpoint);
      return saveResult.fold(
        (failure) => Failure(Exception('Falha ao salvar seção: $failure')),
        (_) => Success(updatedCheckpoint),
      );
    } catch (err) {
      return Failure(Exception('Erro ao atualizar seção: $err'));
    }
  }

  @override
  AsyncResult<Unit> clearCheckpointData() async {
    try {
      _checkpointData = CheckpointData.empty();
      // TODO: Rudson - update in the api too
      return await _secureStorage.delete(_storageKey);
    } catch (err) {
      return Failure(Exception('Erro ao limpar dados: $err'));
    }
  }
}
