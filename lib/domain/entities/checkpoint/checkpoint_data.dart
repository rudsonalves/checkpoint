import 'dart:convert';

import 'checkpoint_section_data.dart';
import 'checkpoint_values/base_checkpoint_values.dart';

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
class CheckpointData {
  CheckpointStage _currentStage;
  bool _isCompleted;
  final Map<CheckpointStage, CheckpointSectionData> _sections;

  CheckpointData({
    required CheckpointStage currentStage,
    required bool isCompleted,
    Map<CheckpointStage, CheckpointSectionData> sections = const {},
  }) : _currentStage = currentStage,
       _isCompleted = isCompleted,
       _sections = sections;

  CheckpointStage get currentStage => _currentStage;
  bool get isCompleted => _isCompleted;
  Map<CheckpointStage, CheckpointSectionData> get sections =>
      Map.unmodifiable(_sections);

  factory CheckpointData.empty() => CheckpointData(
    currentStage: CheckpointStage.noExistAccount,
    isCompleted: false,
  );

  void setSectionData(CheckpointStage stage, CheckpointSectionData section) =>
      _sections[stage] = section;

  void setSection<T extends BaseCheckpointValues>(
    CheckpointStage stage,
    T values,
  ) {
    _sections[stage] = CheckpointSection(values: values);
  }

  factory CheckpointData.newPerson() => CheckpointData(
    currentStage: CheckpointStage.createPersonalAccount,
    isCompleted: false,
    sections: <CheckpointStage, CheckpointSectionData>{
      CheckpointStage.createPersonalAccount:
          CheckpointSection<PersonalAccountValues>(
            values: PersonalAccountValues(),
          ),
    },
  );

  Map<String, dynamic> toMap() => {
    'current_stage': _currentStage.stageName,
    'is_completed': _isCompleted,
    'sections': <String, Map<String, dynamic>>{},
  };

  Map<String, dynamic> toFullMap() {
    final sectionsData = <String, Map<String, dynamic>>{};

    for (final entry in _sections.entries) {
      sectionsData[entry.key.stageName] = {
        'data': entry.value.toMap(),
      };
    }

    return {
      'current_stage': _currentStage.stageName,
      'is_completed': _isCompleted,
      'sections': sectionsData,
    };
  }

  String toFullJson() => json.encode(toFullMap());

  factory CheckpointData.fromMap(Map<String, dynamic> map) => CheckpointData(
    currentStage: CheckpointStage.fromString(map['current_stage'] ?? ''),
    isCompleted: map['is_completed'] ?? false,
    sections: <CheckpointStage, CheckpointSectionData>{},
  );

  String toJson() => json.encode(toMap());

  factory CheckpointData.fromJson(String source) {
    if (source.isEmpty) return CheckpointData.empty();
    return CheckpointData.fromMap(json.decode(source));
  }

  /// Retorna um mapa apenas com os campos alterados de cada seção.
  /// Utiliza o método toDirtyMap das instâncias de BaseCheckpointValues.
  Map<String, dynamic> toDirtyMap() {
    final dirtySections = <String, Map<String, dynamic>>{};

    for (final entry in _sections.entries) {
      final section = entry.value;
      // Só processa se for CheckpointSection e os valores forem
      // BaseCheckpointValues
      if (section is CheckpointSection) {
        final values = section.values;
        if (values.isDirty) {
          dirtySections[entry.key.stageName] = {
            'data': values.toDirtyMap(),
          };
        }
      }
    }

    return {
      'current_stage': _currentStage.stageName,
      'is_completed': _isCompleted,
      'sections': dirtySections,
    };
  }

  void markAllClean() {
    for (final section in _sections.values) {
      if (section is CheckpointSection) {
        final values = section.values;
        values.markClean();
      }
    }
  }

  bool get hasAnyDirtyFields {
    for (final section in _sections.values) {
      if (section is CheckpointSection) {
        if (section.values.isDirty) return true;
      }
    }
    return false;
  }

  /// Verifica se existe dados para um estágio específico.
  ///
  /// [stage] - O estágio a ser verificado
  ///
  /// Retorna true se a seção existe e contém dados (não é uma EmptySection).
  bool hasSectionData(CheckpointStage stage) =>
      _sections.containsKey(stage) && _sections[stage] is! EmptySection;

  /// Marca o checkpoint como completado.
  void markAsCompleted() => _isCompleted = true;

  /// Move o checkpoint para um estágio específico.
  ///
  /// [stage] - O estágio de destino
  void moveToStage(CheckpointStage stage) => _currentStage = stage;
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
      switch (_sections[CheckpointStage.createPersonalAccount]) {
        CheckpointSection<PersonalAccountValues> section => section.values,
        _ => null,
      };

  /// Obtém os dados da conta empresarial se disponíveis.
  ///
  /// Retorna null se os dados empresariais ainda não foram preenchidos.
  BusinessAccountValues? get businessAccountValues =>
      switch (_sections[CheckpointStage.createBusinessAccount]) {
        CheckpointSection<BusinessAccountValues> section => section.values,
        _ => null,
      };

  /// Obtém todos os sócios empresariais cadastrados.
  ///
  /// Retorna uma lista com todos os sócios cadastrados no processo.
  /// Se nenhum sócio foi cadastrado, retorna uma lista vazia.
  List<BusinessPartnerData> get businessPartnersValues =>
      switch (_sections[CheckpointStage.registerBusinessPartners]) {
        CheckpointSection<BusinessPartnersValues> section =>
          section.values.partners,
        _ => <BusinessPartnerData>[],
      };

  /// Obtém a coleção completa de sócios empresariais.
  ///
  /// Retorna null se a seção de sócios ainda não foi inicializada.
  BusinessPartnersValues? get businessPartnersCollection =>
      switch (_sections[CheckpointStage.registerBusinessPartners]) {
        CheckpointSection<BusinessPartnersValues> section => section.values,
        _ => null,
      };
}

/// Extension que adiciona métodos para atualizar campos específicos das seções
/// aproveitando os métodos copyWith das classes de valores.
///
/// Permite atualizações granulares sem precisar recriar objetos inteiros
/// e facilitando o uso.
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
    final values = personalAccountValues ?? PersonalAccountValues();
    _sections[CheckpointStage.createPersonalAccount] = CheckpointSection(
      values: values,
    );

    if (name != null) values.name = name;
    if (cpf != null) values.cpf = cpf;
    if (email != null) values.email = email;
    if (phone != null) values.phone = phone;
    if (password != null) values.password = password;
    if (passwordConfirmation != null) {
      values.passwordConfirmation = passwordConfirmation;
    }
    if (rgNumber != null) values.rgNumber = rgNumber;
    if (rgIssuer != null) values.rgIssuer = rgIssuer;
    if (rgIssuerStateId != null) values.rgIssuerStateId = rgIssuerStateId;
    if (rgIssuerStateAbbreviation != null) {
      values.rgIssuerStateAbbreviation = rgIssuerStateAbbreviation;
    }
    if (rgIssueDate != null) values.rgIssueDate = rgIssueDate;

    return this;
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
    DateTime? openingDate,
    String? phone,
    String? email,
    String? averageMonthlyRevenue,
    String? revenueOptionId,
    String? zipCode,
    String? state,
    String? city,
    String? neighborhood,
    String? streetAddress,
    String? number,
    String? complement,
    DateTime? addressStartDate,
  }) {
    final values = businessAccountValues ?? BusinessAccountValues();
    _sections[CheckpointStage.createBusinessAccount] = CheckpointSection(
      values: values,
    );

    if (cnpj != null) values.cnpj = cnpj;
    if (municipalRegistration != null) {
      values.municipalRegistration = municipalRegistration;
    }
    if (legalName != null) values.legalName = legalName;
    if (tradeName != null) values.tradeName = tradeName;
    if (openingDate != null) values.openingDate = openingDate;
    if (phone != null) values.phone = phone;
    if (email != null) values.email = email;
    if (averageMonthlyRevenue != null) {
      values.averageMonthlyRevenue = averageMonthlyRevenue;
    }
    if (revenueOptionId != null) values.revenueOptionId = revenueOptionId;
    if (zipCode != null) values.zipCode = zipCode;
    if (state != null) values.state = state;
    if (city != null) values.city = city;
    if (neighborhood != null) values.neighborhood = neighborhood;
    if (streetAddress != null) values.streetAddress = streetAddress;
    if (number != null) values.number = number;
    if (complement != null) values.complement = complement;
    if (addressStartDate != null) values.addressStartDate = addressStartDate;

    return this;
  }

  /// Adiciona um novo sócio empresarial.
  ///
  /// [partner] - Dados do novo sócio a ser adicionado
  void addBusinessPartner(BusinessPartnerData partner) {
    final currentCollection =
        businessPartnersCollection ?? BusinessPartnersValues();
    currentCollection.addPartner(partner);
  }

  /// Remove um sócio empresarial pelo índice.
  ///
  /// [index] - Índice do sócio a ser removido
  void removeBusinessPartner(int index) {
    final currentCollection = businessPartnersCollection;
    if (currentCollection == null) return;
    currentCollection.removePartner(index);
  }

  /// Atualiza um sócio específico.
  ///
  /// [index] - Índice do sócio a ser atualizado
  /// [partner] - Novos dados do sócio
  void updateBusinessPartner(int index, BusinessPartnerData partner) {
    final currentCollection = businessPartnersCollection;
    if (currentCollection == null) return;
    currentCollection.updatePartner(index, partner);
  }

  /// Atualiza campos específicos de um sócio empresarial.
  ///
  /// [index] - Índice do sócio a ser atualizado
  /// Apenas os campos fornecidos serão atualizados, os demais permanecerão
  /// inalterados.
  /// Se não existir coleção ou o índice for inválido, retorna a instância
  /// atual.
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

    final values = partners[index];
    if (companyId != null) values.companyId = companyId;
    if (fullName != null) values.fullName = fullName;
    if (email != null) values.email = email;
    if (isPoliticallyExposed != null) {
      values.isPoliticallyExposed = isPoliticallyExposed;
    }
    if (zipCode != null) values.zipCode = zipCode;
    if (state != null) values.state = state;
    if (city != null) values.city = city;
    if (district != null) values.district = district;
    if (street != null) values.street = street;
    if (number != null) values.number = number;
    if (complement != null) values.complement = complement;

    return this;
  }
}
