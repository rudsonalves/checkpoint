import '/domain/enums/checkpoint_enum.dart';
import 'business_account_values.dart';
import 'business_partners_values.dart';
import 'personal_account_values.dart';

export '/domain/enums/checkpoint_enum.dart';
export 'business_account_values.dart';
export 'business_partners_values.dart';
export 'personal_account_values.dart';

abstract class BaseCheckpointValues {
  BaseCheckpointValues();

  CheckpointStage get stage;

  /// Campos alterados (nomes de chave da API).
  final Set<String> dirtyFields = {};

  /// Marca um campo como alterado.
  void markDirty(String field) => dirtyFields.add(field);

  /// Limpa o estado de alterações (após sincronização).
  void markClean() => dirtyFields.clear();

  /// Verifica se há alterações pendentes.
  bool get isDirty => dirtyFields.isNotEmpty;

  /// Retorna o mapa completo (implementado pela subclasse).
  Map<String, dynamic> toMap();

  /// Retorna apenas os campos modificados.
  Map<String, dynamic> toDirtyMap() {
    final full = toMap();
    return {for (final key in dirtyFields) key: full[key]};
  }

  String toJson();
}

extension BaseCheckpointValuesStage on BaseCheckpointValues {
  CheckpointStage get stage {
    return switch (this) {
      PersonalAccountValues _ => CheckpointStage.createPersonalAccount,
      BusinessAccountValues _ => CheckpointStage.createBusinessAccount,
      BusinessPartnersValues _ => CheckpointStage.registerBusinessPartners,
      _ => CheckpointStage.unknown,
    };
  }
}
