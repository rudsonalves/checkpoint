import 'package:equatable/equatable.dart';

import 'base_checkpoint_values.dart';

/// Dados de um sócio empresarial individual.
class BusinessPartnerData extends Equatable {
  final String? companyId;
  final String? fullName;
  final String? email;
  final bool? isPoliticallyExposed;
  final String? zipCode;
  final String? state;
  final String? city;
  final String? district;
  final String? street;
  final String? number;
  final String? complement;

  const BusinessPartnerData({
    this.companyId,
    this.fullName,
    this.email,
    this.isPoliticallyExposed,
    this.zipCode,
    this.state,
    this.city,
    this.district,
    this.street,
    this.number,
    this.complement,
  });

  factory BusinessPartnerData.empty() {
    return const BusinessPartnerData(
      companyId: '',
      fullName: '',
      email: '',
      isPoliticallyExposed: false,
      zipCode: '',
      state: '',
      city: '',
      district: '',
      street: '',
      number: '',
      complement: null,
    );
  }

  BusinessPartnerData copyWith({
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
    return BusinessPartnerData(
      companyId: companyId ?? this.companyId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      isPoliticallyExposed: isPoliticallyExposed ?? this.isPoliticallyExposed,
      zipCode: zipCode ?? this.zipCode,
      state: state ?? this.state,
      city: city ?? this.city,
      district: district ?? this.district,
      street: street ?? this.street,
      number: number ?? this.number,
      complement: complement ?? this.complement,
    );
  }

  factory BusinessPartnerData.fromMap(Map<String, dynamic> map) {
    return BusinessPartnerData(
      companyId: map['company_id'] ?? '',
      fullName: map['full_name'] ?? '',
      email: map['email'] ?? '',
      isPoliticallyExposed: map['is_politically_exposed'] ?? false,
      zipCode: map['zip_code'] ?? '',
      state: map['state'] ?? '',
      city: map['city'] ?? '',
      district: map['district'] ?? '',
      street: map['street'] ?? '',
      number: map['number'] ?? '',
      complement: map['complement'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'company_id': companyId,
      'full_name': fullName,
      'email': email,
      'is_politically_exposed': isPoliticallyExposed,
      'zip_code': zipCode,
      'state': state,
      'city': city,
      'district': district,
      'street': street,
      'number': number,
      'complement': complement,
    };
  }

  @override
  List<Object?> get props => [
    companyId,
    fullName,
    email,
    isPoliticallyExposed,
    zipCode,
    state,
    city,
    district,
    street,
    number,
    complement,
  ];
}

/// Coleção que gerencia múltiplos sócios empresariais.
///
/// Esta classe representa todos os sócios empresariais cadastrados no processo
/// de abertura de conta, permitindo operações como adicionar, remover e
/// atualizar sócios individuais.
class BusinessPartnersValues extends BaseCheckpointValues {
  /// Lista de todos os sócios empresariais cadastrados.
  final List<BusinessPartnerData> partners;

  const BusinessPartnersValues({
    this.partners = const [],
  });

  @override
  CheckpointStage get stage => CheckpointStage.registerBusinessPartners;

  /// Adiciona um novo sócio à coleção.
  ///
  /// [partner] - Dados do novo sócio a ser adicionado
  ///
  /// Retorna uma nova instância com o sócio adicionado.
  BusinessPartnersValues addPartner(BusinessPartnerData partner) {
    return copyWith(partners: [...partners, partner]);
  }

  /// Remove um sócio da coleção pelo índice.
  ///
  /// [index] - Índice do sócio a ser removido
  ///
  /// Retorna uma nova instância sem o sócio removido.
  /// Se o índice for inválido, retorna a instância atual inalterada.
  BusinessPartnersValues removePartner(int index) {
    if (index < 0 || index >= partners.length) return this;
    final updatedPartners = List<BusinessPartnerData>.from(partners);
    updatedPartners.removeAt(index);
    return copyWith(partners: updatedPartners);
  }

  /// Atualiza um sócio específico na coleção.
  ///
  /// [index] - Índice do sócio a ser atualizado
  /// [partner] - Novos dados do sócio
  ///
  /// Retorna uma nova instância com o sócio atualizado.
  /// Se o índice for inválido, retorna a instância atual inalterada.
  BusinessPartnersValues updatePartner(int index, BusinessPartnerData partner) {
    if (index < 0 || index >= partners.length) return this;
    final updatedPartners = List<BusinessPartnerData>.from(partners);
    updatedPartners[index] = partner;
    return copyWith(partners: updatedPartners);
  }

  /// Cria uma cópia da instância com os valores especificados alterados.
  ///
  /// Implementa o padrão copy-with para imutabilidade.
  BusinessPartnersValues copyWith({
    List<BusinessPartnerData>? partners,
  }) {
    return BusinessPartnersValues(
      partners: partners ?? this.partners,
    );
  }

  factory BusinessPartnersValues.empty() {
    return BusinessPartnersValues(partners: [BusinessPartnerData.empty()]);
  }

  /// Factory constructor que cria uma instância a partir de um mapa.
  ///
  /// [map] - Mapa contendo os dados serializados da coleção de sócios
  factory BusinessPartnersValues.fromMap(Map<String, dynamic> map) {
    final partnersData = map['partners'] as List<dynamic>? ?? [];
    final partners = partnersData
        .map(
          (data) => BusinessPartnerData.fromMap(data as Map<String, dynamic>),
        )
        .toList();

    return BusinessPartnersValues(partners: partners);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'partners': partners.map((partner) => partner.toMap()).toList(),
    };
  }

  @override
  List<Object?> get props => [partners];
}
