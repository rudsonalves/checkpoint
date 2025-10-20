import 'package:checkpoint/src/domain/entities/checkpoint/checkpoint_data.dart';
import 'package:checkpoint/src/domain/entities/checkpoint/checkpoint_section_data.dart';
import 'package:checkpoint/src/domain/enum/checkpoint_enum.dart';
import 'package:checkpoint/src/domain/repositories/checkpoint_data_repository.dart';
import 'package:checkpoint/src/core/services/secure_storage/local_secure_storage.dart';
import 'package:result_dart/result_dart.dart';

class CheckpointDataRepositoryImpl implements CheckpointDataRepository {
  final LocalSecureStorage _secureStorage;

  CheckpointData _currentCheckpointData = CheckpointData.empty();

  static const String _storageKey = 'checkpoint_data';

  CheckpointDataRepositoryImpl(this._secureStorage);

  @override
  CheckpointData get currentCheckpointData => _currentCheckpointData;

  @override
  AsyncResult<CheckpointData> loadCheckpointData() async {
    try {
      final result = await _secureStorage.read(_storageKey);

      return result.fold(
        (source) {
          try {
            _currentCheckpointData = CheckpointData.fromJson(source);
            return Success(_currentCheckpointData);
          } catch (err) {
            _currentCheckpointData = CheckpointData.empty();
            return Failure(Exception('Erro ao carregar dados: $err'));
          }
        },
        (failure) {
          _currentCheckpointData = CheckpointData.empty();
          return Success(_currentCheckpointData);
        },
      );
    } catch (err) {
      return Failure(Exception('Erro inesperado ao carregar dados: $err'));
    }
  }

  @override
  AsyncResult<Unit> saveCheckpointData(CheckpointData checkpointData) async {
    try {
      _currentCheckpointData = checkpointData;
      final jsonString = checkpointData.toJson();

      return await _secureStorage.write(_storageKey, jsonString);
    } catch (err) {
      return Failure(Exception('Erro ao salvar dados: $err'));
    }
  }

  @override
  AsyncResult<CheckpointData> updateSection({
    required CheckpointStage stage,
    required CheckpointSectionData sectionData,
    CheckpointStage? nextStage,
  }) async {
    try {
      final updatedCheckpoint = _currentCheckpointData.withSection(
        stage: stage,
        sectionData: sectionData,
        nextStage: nextStage,
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
  AsyncResult<CheckpointData> moveToNextStage(CheckpointStage nextStage) async {
    try {
      final updatedCheckpoint = _currentCheckpointData.moveToStage(nextStage);

      final saveResult = await saveCheckpointData(updatedCheckpoint);

      return saveResult.fold(
        (failure) => Failure(Exception('Falha ao salvar estágio: $failure')),
        (_) => Success(updatedCheckpoint),
      );
    } catch (err) {
      return Failure(Exception('Erro ao mover para próximo estágio: $err'));
    }
  }

  @override
  AsyncResult<CheckpointData> completeCheckpoint() async {
    try {
      final completedCheckpoint = _currentCheckpointData.markAsCompleted();

      final saveResult = await saveCheckpointData(completedCheckpoint);

      return saveResult.fold(
        (failure) =>
            Failure(Exception('Falha ao completar checkpoint: $failure')),
        (_) => Success(completedCheckpoint),
      );
    } catch (err) {
      return Failure(Exception('Erro ao completar checkpoint: $err'));
    }
  }

  @override
  AsyncResult<Unit> clearCheckpointData() async {
    try {
      _currentCheckpointData = CheckpointData.empty();
      return await _secureStorage.delete(_storageKey);
    } catch (err) {
      return Failure(Exception('Erro ao limpar dados: $err'));
    }
  }

  @override
  AsyncResult<Unit> syncWithApi() async {
    try {
      // TODO: Implementar sincronização com API quando necessário
      return const Success(unit);
    } catch (err) {
      return Failure(Exception('Erro na sincronização: $err'));
    }
  }

  @override
  T? getSectionData<T extends CheckpointSectionData>(CheckpointStage stage) {
    return _currentCheckpointData.getSectionData<T>(stage);
  }

  @override
  bool hasSectionData(CheckpointStage stage) {
    return _currentCheckpointData.hasSectionData(stage);
  }
}
