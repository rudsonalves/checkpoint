import 'package:equatable/equatable.dart';

import 'checkpoint_values/base_checkpoint_values.dart';
import 'checkpoint_values/business_account_values.dart';
import 'checkpoint_values/business_partners_values.dart';
import 'checkpoint_values/personal_account_values.dart';
import '../../enum/checkpoint_enum.dart';

/// Classe base abstrata que representa os dados de uma seção do checkpoint.
///
/// Esta classe define a interface comum para todas as seções do checkpoint,
/// permitindo diferentes tipos de dados serem tratados de forma uniforme.
/// Utiliza o padrão sealed class para garantir que todas as implementações
/// sejam conhecidas em tempo de compilação.
sealed class CheckpointSectionData extends Equatable {
  const CheckpointSectionData();

  /// Factory constructor que cria uma instância de [CheckpointSectionData]
  /// baseada no estágio do checkpoint e nos dados fornecidos.
  ///
  /// [stage] - O estágio atual do checkpoint que determina o tipo de dados
  /// [data] - Mapa contendo os dados específicos da seção
  ///
  /// Retorna a implementação apropriada de [CheckpointSectionData] baseada no
  /// estágio:
  /// - [CheckpointStage.createPersonalAccount]: Retorna seção com dados
  ///   pessoais
  /// - [CheckpointStage.createBusinessAccount]: Retorna seção com dados
  ///   empresariais
  /// - [CheckpointStage.registerBusinessPartners]: Retorna seção com dados de
  ///   sócios
  /// - Outros estágios: Retorna uma seção vazia
  factory CheckpointSectionData.fromMap({
    required CheckpointStage stage,
    required Map<String, dynamic> data,
  }) {
    switch (stage) {
      case CheckpointStage.createPersonalAccount:
        return CheckpointSection(
          values: PersonalAccountValues.fromMap(data),
        );

      case CheckpointStage.createBusinessAccount:
        return CheckpointSection(
          values: BusinessAccountValues.fromMap(data),
        );

      case CheckpointStage.registerBusinessPartners:
        return CheckpointSection(
          values: BusinessPartnersValues.fromMap(data),
        );

      case CheckpointStage.noExistAccount:
      case CheckpointStage.unknown:
        return const EmptySection();
    }
  }

  /// Converte os dados da seção para um mapa de dados.
  ///
  /// Deve ser implementado por todas as subclasses para permitir
  /// serialização dos dados específicos da seção.
  Map<String, dynamic> toMap();
}

/// Implementação de [CheckpointSectionData] para seções vazias.
///
/// Utilizada quando não há dados específicos para uma seção,
/// como nos estágios [CheckpointStage.noExistAccount] e
/// [CheckpointStage.unknown].
class EmptySection extends CheckpointSectionData {
  const EmptySection();

  @override
  Map<String, dynamic> toMap() => {};

  @override
  List<Object?> get props => [];
}

/// Implementação genérica de [CheckpointSectionData] que contém valores
/// específicos.
///
/// Esta classe encapsula dados específicos de uma seção do checkpoint,
/// onde [T] deve ser uma subclasse de [BaseCheckpointValues].
class CheckpointSection<T extends BaseCheckpointValues>
    extends CheckpointSectionData {
  /// Os valores específicos desta seção do checkpoint.
  final T values;

  const CheckpointSection({required this.values});

  @override
  Map<String, dynamic> toMap() => values.toMap();

  @override
  List<Object?> get props => [values];
}
