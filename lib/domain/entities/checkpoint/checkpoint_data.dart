import 'dart:convert';

import '/domain/enums/checkpoint_enum.dart';
import 'package:equatable/equatable.dart';

import 'checkpoint_section_data.dart';
import 'checkpoint_values/business_account_values.dart';
import 'checkpoint_values/business_partners_values.dart';
import 'checkpoint_values/personal_account_values.dart';

export '/domain/enums/checkpoint_enum.dart';
export 'checkpoint_section_data.dart';
export 'checkpoint_values/business_account_values.dart';
export 'checkpoint_values/business_partners_values.dart';
export 'checkpoint_values/personal_account_values.dart';

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
  final CheckpointStage currentStage;
  final bool isCompleted;
  final Map<CheckpointStage, CheckpointSectionData> sections;

  const CheckpointData({
    required this.currentStage,
    required this.isCompleted,
    this.sections = const {},
  });

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

  String toJson() => json.encode(toMap());

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
    // CheckpointStage? nextStage,
  }) {
    final updatedSections = Map<CheckpointStage, CheckpointSectionData>.from(
      sections,
    );
    updatedSections[stage] = sectionData;

    return copyWith(
      sections: updatedSections,
      currentStage: stage, // nextStage ?? _getNextStage(stage),
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
  // CheckpointStage _getNextStage(CheckpointStage currentStage) =>
  //     switch (currentStage) {
  //       CheckpointStage.noExistAccount => CheckpointStage.createPersonalAccount,
  //       CheckpointStage.createPersonalAccount =>
  //         CheckpointStage.createBusinessAccount,
  //       CheckpointStage.createBusinessAccount =>
  //         CheckpointStage.registerBusinessPartners,
  //       CheckpointStage.registerBusinessPartners =>
  //         // Pode ter múltiplos sócios
  //         CheckpointStage.registerBusinessPartners,
  //       CheckpointStage.unknown => CheckpointStage.noExistAccount,
  //     };

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
  PersonalAccountValues? get personalAccountValues =>
      switch (sections[CheckpointStage.createPersonalAccount]) {
        CheckpointSection<PersonalAccountValues> section => section.values,
        _ => null,
      };

  /// Obtém os dados da conta empresarial se disponíveis.
  ///
  /// Retorna null se os dados empresariais ainda não foram preenchidos.
  BusinessAccountValues? get businessAccountValues =>
      switch (sections[CheckpointStage.createBusinessAccount]) {
        CheckpointSection<BusinessAccountValues> section => section.values,
        _ => null,
      };

  /// Obtém todos os sócios empresariais cadastrados.
  ///
  /// Retorna uma lista com todos os sócios cadastrados no processo.
  /// Se nenhum sócio foi cadastrado, retorna uma lista vazia.
  List<BusinessPartnerData> get businessPartnersValues =>
      switch (sections[CheckpointStage.registerBusinessPartners]) {
        CheckpointSection<BusinessPartnersValues> section =>
          section.values.partners,
        _ => <BusinessPartnerData>[],
      };

  /// Obtém a coleção completa de sócios empresariais.
  ///
  /// Retorna null se a seção de sócios ainda não foi inicializada.
  BusinessPartnersValues? get businessPartnersCollection =>
      switch (sections[CheckpointStage.registerBusinessPartners]) {
        CheckpointSection<BusinessPartnersValues> section => section.values,
        _ => null,
      };
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
    String? passwordConfirmation,
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
      passwordConfirmation: passwordConfirmation,
      rgNumber: rgNumber,
      rgIssuer: rgIssuer,
      rgIssuerStateId: rgIssuerStateId,
      rgIssuerStateAbbreviation: rgIssuerStateAbbreviation,
      rgIssueDate: rgIssueDate,
    );

    return withSection(
      stage: CheckpointStage.createPersonalAccount,
      sectionData: CheckpointSection(values: updatedValues),
      // nextStage: currentStage, // Mantém o estágio atual
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
      // nextStage: currentStage, // Mantém o estágio atual
    );
  }

  /// Adiciona um novo sócio empresarial.
  ///
  /// [partner] - Dados do novo sócio a ser adicionado
  ///
  /// Retorna uma nova instância com o sócio adicionado.
  CheckpointData addBusinessPartner(BusinessPartnerData partner) {
    final currentCollection =
        businessPartnersCollection ?? const BusinessPartnersValues();

    final updatedCollection = currentCollection.addPartner(partner);

    return withSection(
      stage: CheckpointStage.registerBusinessPartners,
      sectionData: CheckpointSection(values: updatedCollection),
      // nextStage: currentStage, // Mantém no mesmo estágio para adicionar mais
    );
  }

  /// Remove um sócio empresarial pelo índice.
  ///
  /// [index] - Índice do sócio a ser removido
  ///
  /// Retorna uma nova instância sem o sócio removido.
  /// Se o índice for inválido ou não existir coleção, retorna a instância atual.
  CheckpointData removeBusinessPartner(int index) {
    final currentCollection = businessPartnersCollection;
    if (currentCollection == null) return this;

    final updatedCollection = currentCollection.removePartner(index);

    return withSection(
      stage: CheckpointStage.registerBusinessPartners,
      sectionData: CheckpointSection(values: updatedCollection),
      // nextStage: currentStage,
    );
  }

  /// Atualiza um sócio específico.
  ///
  /// [index] - Índice do sócio a ser atualizado
  /// [partner] - Novos dados do sócio
  ///
  /// Retorna uma nova instância com o sócio atualizado.
  /// Se o índice for inválido ou não existir coleção, retorna a instância atual.
  CheckpointData updateBusinessPartner(int index, BusinessPartnerData partner) {
    final currentCollection = businessPartnersCollection;
    if (currentCollection == null) return this;

    final updatedCollection = currentCollection.updatePartner(index, partner);

    return withSection(
      stage: CheckpointStage.registerBusinessPartners,
      sectionData: CheckpointSection(values: updatedCollection),
      // nextStage: currentStage,
    );
  }

  /// Atualiza campos específicos de um sócio empresarial.
  ///
  /// [index] - Índice do sócio a ser atualizado
  /// Apenas os campos fornecidos serão atualizados, os demais permanecerão
  /// inalterados.
  /// Se não existir coleção ou o índice for inválido, retorna a instância atual.
  CheckpointData updateBusinessPartnerFields(
    int index, {
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
    final partners = businessPartnersValues;
    if (index < 0 || index >= partners.length) return this;

    final updatedPartner = partners[index].copyWith(
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

    return updateBusinessPartner(index, updatedPartner);
  }
}
