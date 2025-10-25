import 'package:result_dart/result_dart.dart';

import '/domain/entities/checkpoint/checkpoint_data.dart';
import '/domain/entities/checkpoint/checkpoint_values/base_checkpoint_values.dart';

abstract interface class CheckpointDataRepository {
  CheckpointData get checkpointData;

  AsyncResult<CheckpointData> getCheckpointData();

  AsyncResult<Unit> createCheckpointSection<T extends BaseCheckpointValues>(
    T values,
  );

  AsyncResult<Unit> saveCheckpointData();

  AsyncResult<Unit> syncWithApi();

  bool hasSectionData(CheckpointStage stage);

  AsyncResult<Unit> clearCheckpointData({String? cpf});
}
