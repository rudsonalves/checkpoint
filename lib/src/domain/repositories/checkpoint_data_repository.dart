import 'package:checkpoint/src/domain/entities/checkpoint/checkpoint_data.dart';
import 'package:checkpoint/src/domain/entities/checkpoint/checkpoint_section_data.dart';
import 'package:checkpoint/src/domain/enum/checkpoint_enum.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class CheckpointDataRepository {
  /// Obtém o checkpoint atual do cache/memória
  CheckpointData get currentCheckpointData;

  /// Carrega o checkpoint do secure storage
  AsyncResult<CheckpointData> loadCheckpointData();

  /// Salva o checkpoint no secure storage
  AsyncResult<Unit> saveCheckpointData(CheckpointData checkpointData);

  /// Atualiza uma seção específica do checkpoint
  AsyncResult<CheckpointData> updateSection({
    required CheckpointStage stage,
    required CheckpointSectionData sectionData,
    CheckpointStage? nextStage,
  });

  /// Avança para o próximo estágio
  AsyncResult<CheckpointData> moveToNextStage(CheckpointStage nextStage);

  /// Marca o processo como completo
  AsyncResult<CheckpointData> completeCheckpoint();

  /// Limpa todos os dados do checkpoint
  AsyncResult<Unit> clearCheckpointData();

  /// Sincroniza com a API (implementação futura)
  AsyncResult<Unit> syncWithApi();

  /// Obtém dados de uma seção específica
  T? getSectionData<T extends CheckpointSectionData>(CheckpointStage stage);

  /// Verifica se uma seção foi preenchida
  bool hasSectionData(CheckpointStage stage);
}
