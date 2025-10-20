import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'checkpoint_section_data.dart';
import 'checkpoint_values/business_account_values.dart';
import 'checkpoint_values/business_partners_values.dart';
import 'checkpoint_values/personal_account_values.dart';
import '../../enum/checkpoint_enum.dart';

/// Classe principal que representa todos os dados do checkpoint de abertura de
/// conta.
///
/// Esta classe gerencia o estado completo do processo de checkpoint, incluindo:
/// - O estágio atual do processo
/// - Status de completude
/// - Dados de todas as seções já preenchidas
///
/// A classe é imutável e utiliza o padrão copy-with para atualizações.
class CheckpointData extends Equatable {
  /// O estágio atual do processo de checkpoint.
  final CheckpointStage currentStage;

  /// Indica se todo o processo de checkpoint foi completado.
  final bool isCompleted;

  /// Mapa contendo os dados de cada seção já preenchida do checkpoint.
  /// A chave é o estágio e o valor são os dados correspondentes.
  final Map<CheckpointStage, CheckpointSectionData> sections;

  const CheckpointData({
    required this.currentStage,
    required this.isCompleted,
    this.sections = const {},
  });

  /// Factory constructor que cria uma instância vazia de [CheckpointData].
  ///
  /// Útil para inicializar um novo processo de checkpoint.
  /// Inicia no estágio [CheckpointStage.noExistAccount] e não completado.
  factory CheckpointData.empty() => const CheckpointData(
    currentStage: CheckpointStage.noExistAccount,
    isCompleted: false,
  );

  Map<String, dynamic> toMap() {
    final sectionsData = <String, Map<String, dynamic>>{};

    for (final entry in sections.entries) {
      sectionsData[entry.key.stageName] = {
        'data': entry.value.toMap(),
      };
    }

    return {
      'current_stage': currentStage.stageName,
      'is_completed': isCompleted,
      'sections': sectionsData,
    };
  }

  /// Factory constructor que cria uma instância de [CheckpointData] a partir de
  /// um mapa.
  ///
  /// [map] - Mapa contendo os dados serializados do checkpoint
  ///
  /// Reconstitui todas as seções baseado nos dados salvos e determina
  /// o tipo correto de cada seção baseado no estágio.
  factory CheckpointData.fromMap(Map<String, dynamic> map) {
    final sectionsMap = <CheckpointStage, CheckpointSectionData>{};
    final sectionsData = map['sections'] as Map<String, dynamic>? ?? {};

    for (final entry in sectionsData.entries) {
      final stage = CheckpointStage.fromString(entry.key);
      final sectionData = entry.value as Map<String, dynamic>;
      final data = sectionData['data'] as Map<String, dynamic>? ?? {};

      sectionsMap[stage] = CheckpointSectionData.fromMap(
        stage: stage,
        data: data,
      );
    }

    return CheckpointData(
      currentStage: CheckpointStage.fromString(map['current_stage'] ?? ''),
      isCompleted: map['is_completed'] ?? false,
      sections: sectionsMap,
    );
  }

  /// Converte os dados do checkpoint para uma string JSON.
  ///
  /// Útil para persistência ou transmissão dos dados.
  String toJson() => json.encode(toMap());

  /// Factory constructor que cria uma instância de [CheckpointData] a partir de
  /// uma string JSON.
  ///
  /// [source] - String JSON contendo os dados serializados
  ///
  /// Se a string estiver vazia, retorna uma instância vazia.
  factory CheckpointData.fromJson(String source) {
    if (source.isEmpty) return CheckpointData.empty();
    return CheckpointData.fromMap(json.decode(source));
  }

  /// Adiciona ou atualiza uma seção do checkpoint com novos dados.
  ///
  /// [stage] - O estágio da seção a ser atualizada
  /// [sectionData] - Os novos dados da seção
  /// [nextStage] - Opcional: especifica o próximo estágio, se não fornecido usa
  /// o padrão
  ///
  /// Retorna uma nova instância de [CheckpointData] com a seção atualizada
  /// e possivelmente um novo estágio atual.
  CheckpointData withSection({
    required CheckpointStage stage,
    required CheckpointSectionData sectionData,
    CheckpointStage? nextStage,
  }) {
    final updatedSections = Map<CheckpointStage, CheckpointSectionData>.from(
      sections,
    );
    updatedSections[stage] = sectionData;

    return copyWith(
      sections: updatedSections,
      currentStage: nextStage ?? _getNextStage(stage),
    );
  }

  /// Determina o próximo estágio baseado no estágio atual.
  ///
  /// Define a sequência lógica do fluxo de checkpoint:
  /// 1. noExistAccount → createPersonalAccount
  /// 2. createPersonalAccount → createBusinessAccount
  /// 3. createBusinessAccount → registerBusinessPartners
  /// 4. registerBusinessPartners → registerBusinessPartners (permite múltiplos
  /// sócios)
  CheckpointStage _getNextStage(CheckpointStage currentStage) =>
      switch (currentStage) {
        CheckpointStage.noExistAccount => CheckpointStage.createPersonalAccount,
        CheckpointStage.createPersonalAccount =>
          CheckpointStage.createBusinessAccount,
        CheckpointStage.createBusinessAccount =>
          CheckpointStage.registerBusinessPartners,
        CheckpointStage.registerBusinessPartners =>
          // Pode ter múltiplos sócios
          CheckpointStage.registerBusinessPartners,
        CheckpointStage.unknown => CheckpointStage.noExistAccount,
      };

  /// Obtém os dados de uma seção específica com type safety.
  ///
  /// [T] - Tipo específico da seção desejada
  /// [stage] - O estágio da seção a ser recuperada
  ///
  /// Retorna os dados da seção se existir e for do tipo correto, caso contrário
  /// null.
  T? getSectionData<T extends CheckpointSectionData>(CheckpointStage stage) {
    final section = sections[stage];
    return section is T ? section : null;
  }

  /// Verifica se existe dados para um estágio específico.
  ///
  /// [stage] - O estágio a ser verificado
  ///
  /// Retorna true se a seção existe e contém dados (não é uma EmptySection).
  bool hasSectionData(CheckpointStage stage) =>
      sections.containsKey(stage) && sections[stage] is! EmptySection;

  /// Marca o checkpoint como completado.
  ///
  /// Retorna uma nova instância com isCompleted = true.
  CheckpointData markAsCompleted() => copyWith(isCompleted: true);

  /// Move o checkpoint para um estágio específico.
  ///
  /// [stage] - O estágio de destino
  ///
  /// Útil para navegação manual ou correção de fluxo.
  CheckpointData moveToStage(CheckpointStage stage) =>
      copyWith(currentStage: stage);

  /// Cria uma cópia da instância com os valores especificados alterados.
  ///
  /// Implementa o padrão copy-with para imutabilidade.
  CheckpointData copyWith({
    CheckpointStage? currentStage,
    bool? isCompleted,
    Map<CheckpointStage, CheckpointSectionData>? sections,
  }) => CheckpointData(
    currentStage: currentStage ?? this.currentStage,
    isCompleted: isCompleted ?? this.isCompleted,
    sections: sections ?? this.sections,
  );

  @override
  List<Object?> get props => [currentStage, isCompleted, sections];
}

/// Extension que adiciona getters convenientes para acessar dados específicos
/// do checkpoint.
///
/// Simplifica o acesso aos dados das seções sem adicionar complexidade
/// desnecessária.
extension CheckpointDataExtensions on CheckpointData {
  /// Obtém os dados da conta pessoal se disponíveis.
  ///
  /// Retorna null se os dados pessoais ainda não foram preenchidos.
  PersonalAccountValues? get personalAccountValues {
    final section = getSectionData<CheckpointSection<PersonalAccountValues>>(
      CheckpointStage.createPersonalAccount,
    );
    return section?.values;
  }

  /// Obtém os dados da conta empresarial se disponíveis.
  ///
  /// Retorna null se os dados empresariais ainda não foram preenchidos.
  BusinessAccountValues? get businessAccountValues {
    final section = getSectionData<CheckpointSection<BusinessAccountValues>>(
      CheckpointStage.createBusinessAccount,
    );
    return section?.values;
  }

  /// Obtém todos os sócios empresariais cadastrados.
  ///
  /// Atualmente suporta apenas um sócio, mas a estrutura permite
  /// expansão futura para múltiplos sócios.
  ///
  /// Retorna uma lista vazia se nenhum sócio foi cadastrado.
  List<BusinessPartnersValues> get businessPartnersValues {
    final section = getSectionData<CheckpointSection<BusinessPartnersValues>>(
      CheckpointStage.registerBusinessPartners,
    );
    return section != null ? [section.values] : [];
  }
}

/// Extension que adiciona métodos para atualizar campos específicos das seções
/// aproveitando os métodos copyWith das classes de valores.
///
/// Permite atualizações granulares sem precisar recriar objetos inteiros,
/// mantendo a imutabilidade e facilitando o uso.
extension CheckpointDataUpdateExtensions on CheckpointData {
  /// Atualiza campos específicos da conta pessoal.
  ///
  /// Apenas os campos fornecidos serão atualizados, os demais permanecerão
  /// inalterados.
  /// Se não existir uma conta pessoal, não faz nada e retorna a instância
  /// atual.
  CheckpointData updatePersonalAccount({
    String? name,
    String? cpf,
    String? email,
    String? phone,
    String? password,
    String? rgNumber,
    String? rgIssuer,
    String? rgIssuerStateId,
    String? rgIssuerStateAbbreviation,
    DateTime? rgIssueDate,
  }) {
    final currentValues = personalAccountValues;
    if (currentValues == null) return this;

    final updatedValues = currentValues.copyWith(
      name: name,
      cpf: cpf,
      email: email,
      phone: phone,
      password: password,
      rgNumber: rgNumber,
      rgIssuer: rgIssuer,
      rgIssuerStateId: rgIssuerStateId,
      rgIssuerStateAbbreviation: rgIssuerStateAbbreviation,
      rgIssueDate: rgIssueDate,
    );

    return withSection(
      stage: CheckpointStage.createPersonalAccount,
      sectionData: CheckpointSection(values: updatedValues),
      nextStage: currentStage, // Mantém o estágio atual
    );
  }

  /// Atualiza campos específicos da conta empresarial.
  ///
  /// Apenas os campos fornecidos serão atualizados, os demais permanecerão
  /// inalterados.
  /// Se não existir uma conta empresarial, não faz nada e retorna a instância
  /// atual.
  CheckpointData updateBusinessAccount({
    String? cnpj,
    String? municipalRegistration,
    String? legalName,
    String? tradeName,
    String? phone,
    String? revenueOptionId,
    String? zipCode,
    String? state,
    String? city,
    String? neighborhood,
    String? streetAddress,
    String? number,
    String? complement,
    DateTime? addressStartDate,
    String? email,
    String? openingDate,
  }) {
    final currentValues = businessAccountValues;
    if (currentValues == null) return this;

    final updatedValues = currentValues.copyWith(
      cnpj: cnpj,
      municipalRegistration: municipalRegistration,
      legalName: legalName,
      tradeName: tradeName,
      phone: phone,
      revenueOptionId: revenueOptionId,
      zipCode: zipCode,
      state: state,
      city: city,
      neighborhood: neighborhood,
      streetAddress: streetAddress,
      number: number,
      complement: complement,
      addressStartDate: addressStartDate,
      email: email,
      openingDate: openingDate,
    );

    return withSection(
      stage: CheckpointStage.createBusinessAccount,
      sectionData: CheckpointSection(values: updatedValues),
      nextStage: currentStage, // Mantém o estágio atual
    );
  }

  /// Atualiza campos específicos dos dados de sócios empresariais.
  ///
  /// Apenas os campos fornecidos serão atualizados, os demais permanecerão
  /// inalterados.
  /// Se não existir dados de sócios, não faz nada e retorna a instância atual.
  CheckpointData updateBusinessPartner({
    String? companyId,
    String? fullName,
    String? email,
    bool? isPoliticallyExposed,
    String? zipCode,
    String? state,
    String? city,
    String? district,
    String? street,
    String? number,
    String? complement,
  }) {
    final currentValues = businessPartnersValues.isNotEmpty
        ? businessPartnersValues.first
        : null;
    if (currentValues == null) return this;

    final updatedValues = currentValues.copyWith(
      companyId: companyId,
      fullName: fullName,
      email: email,
      isPoliticallyExposed: isPoliticallyExposed,
      zipCode: zipCode,
      state: state,
      city: city,
      district: district,
      street: street,
      number: number,
      complement: complement,
    );

    return withSection(
      stage: CheckpointStage.registerBusinessPartners,
      sectionData: CheckpointSection(values: updatedValues),
      nextStage: currentStage, // Mantém o estágio atual
    );
  }
}
