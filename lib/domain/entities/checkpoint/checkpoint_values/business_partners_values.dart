import 'dart:convert';

import 'base_checkpoint_values.dart';

/// Dados de um sócio empresarial individual.
class BusinessPartnerData extends BaseCheckpointValues {
  String _companyId;
  String _fullName;
  String _email;
  bool _isPoliticallyExposed;
  String _zipCode;
  String _state;
  String _city;
  String _district;
  String _street;
  String _number;
  String? _complement;

  String get companyId => _companyId;
  String get fullName => _fullName;
  String get email => _email;
  bool get isPoliticallyExposed => _isPoliticallyExposed;
  String get zipCode => _zipCode;
  String get state => _state;
  String get city => _city;
  String get district => _district;
  String get street => _street;
  String get number => _number;
  String? get complement => _complement;

  @override
  CheckpointStage get stage => CheckpointStage.registerBusinessPartners;

  set companyId(String value) {
    if (_companyId != value) {
      _companyId = value;
      markDirty('company_id');
    }
  }

  set fullName(String value) {
    if (_fullName != value) {
      _fullName = value;
      markDirty('full_name');
    }
  }

  set email(String value) {
    if (_email != value) {
      _email = value;
      markDirty('email');
    }
  }

  set isPoliticallyExposed(bool value) {
    if (_isPoliticallyExposed != value) {
      _isPoliticallyExposed = value;
      markDirty('is_politically_exposed');
    }
  }

  set zipCode(String value) {
    if (_zipCode != value) {
      _zipCode = value;
      markDirty('zip_code');
    }
  }

  set state(String value) {
    if (_state != value) {
      _state = value;
      markDirty('state');
    }
  }

  set city(String value) {
    if (_city != value) {
      _city = value;
      markDirty('city');
    }
  }

  set district(String value) {
    if (_district != value) {
      _district = value;
      markDirty('district');
    }
  }

  set street(String value) {
    if (_street != value) {
      _street = value;
      markDirty('street');
    }
  }

  set number(String value) {
    if (_number != value) {
      _number = value;
      markDirty('number');
    }
  }

  set complement(String? value) {
    if (_complement != value) {
      _complement = value;
      markDirty('complement');
    }
  }

  BusinessPartnerData({
    String companyId = '',
    String fullName = '',
    String email = '',
    bool isPoliticallyExposed = false,
    String zipCode = '',
    String state = '',
    String city = '',
    String district = '',
    String street = '',
    String number = '',
    String? complement,
  }) : _companyId = companyId,
       _fullName = fullName,
       _email = email,
       _isPoliticallyExposed = isPoliticallyExposed,
       _zipCode = zipCode,
       _state = state,
       _city = city,
       _district = district,
       _street = street,
       _number = number,
       _complement = complement;

  factory BusinessPartnerData.empty() => BusinessPartnerData();

  /// Reconstrói a lista de sócios e restaura os campos marcados como sujos.
  factory BusinessPartnerData.fromMap(Map<String, dynamic> map) {
    final instance = BusinessPartnerData(
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
      complement: map['complement'] ?? '',
    );

    final dirty = map['dirty_fields'];
    if (dirty is List) {
      instance.dirtyFields.addAll(dirty.map((e) => e.toString()));
    }

    return instance;
  }

  @override
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
      'dirty_fields': dirtyFields.toList(),
    };
  }

  @override
  String toJson() => jsonEncode(toMap());

  factory BusinessPartnerData.fromJson(String source) =>
      BusinessPartnerData.fromMap(jsonDecode(source));
}

/// Coleção que gerencia múltiplos sócios empresariais.
///
/// Esta classe representa todos os sócios empresariais cadastrados no processo
/// de abertura de conta, permitindo operações como adicionar, remover e
/// atualizar sócios individuais.
class BusinessPartnersValues extends BaseCheckpointValues {
  /// Lista de todos os sócios empresariais cadastrados.
  final List<BusinessPartnerData> partners;

  BusinessPartnersValues({this.partners = const []});

  @override
  CheckpointStage get stage => CheckpointStage.registerBusinessPartners;

  /// Adiciona um novo sócio à coleção.
  ///
  /// Retorna uma nova instância com o sócio adicionado e marca a lista como alterada.
  BusinessPartnersValues addPartner(BusinessPartnerData partner) {
    final updated = [...partners, partner];
    final next = copyWith(partners: updated);
    next.markDirty('partners');
    return next;
  }

  /// Remove um sócio da coleção pelo índice.
  ///
  /// Retorna uma nova instância sem o sócio removido e marca como alterada.
  BusinessPartnersValues removePartner(int index) {
    if (index < 0 || index >= partners.length) return this;
    final updated = List<BusinessPartnerData>.from(partners)..removeAt(index);
    final next = copyWith(partners: updated);
    next.markDirty('partners');
    return next;
  }

  /// Atualiza um sócio específico na coleção.
  ///
  /// Retorna uma nova instância com o sócio atualizado e marca a lista como alterada.
  BusinessPartnersValues updatePartner(int index, BusinessPartnerData partner) {
    if (index < 0 || index >= partners.length) return this;
    final updated = List<BusinessPartnerData>.from(partners);
    updated[index] = partner;
    final next = copyWith(partners: updated);
    next.markDirty('partners');
    return next;
  }

  /// Cria uma cópia da instância com os valores especificados alterados.
  ///
  /// Mantém o rastreamento de campos alterados.
  BusinessPartnersValues copyWith({
    List<BusinessPartnerData>? partners,
    Set<String>? dirtyFields,
  }) {
    final copy = BusinessPartnersValues(
      partners: partners ?? this.partners,
    );
    if (dirtyFields != null) copy.dirtyFields.addAll(dirtyFields);
    return copy;
  }

  factory BusinessPartnersValues.empty() =>
      BusinessPartnersValues(partners: [BusinessPartnerData.empty()]);

  factory BusinessPartnersValues.fromMap(Map<String, dynamic> map) {
    final partnersData = map['partners'] as List<dynamic>? ?? [];
    final partners = partnersData
        .map(
          (data) => BusinessPartnerData.fromMap(data as Map<String, dynamic>),
        )
        .toList();

    final instance = BusinessPartnersValues(partners: partners);
    if (map['dirty_fields'] != null) {
      instance.dirtyFields.addAll(List<String>.from(map['dirty_fields']));
    }
    return instance;
  }

  @override
  Map<String, dynamic> toMap() => {
    'partners': partners.map((p) => p.toMap()).toList(),
    'dirty_fields': dirtyFields.toList(),
  };

  /// Retorna apenas as alterações relevantes para sincronização incremental
  /// com a API.
  @override
  Map<String, dynamic> toDirtyMap() {
    final changedPartners = partners
        .where((p) => p.isDirty)
        .map((p) => p.toDirtyMap())
        .toList();

    final result = <String, dynamic>{};

    if (dirtyFields.contains('partners')) {
      result['partners'] = partners.map((p) => p.toMap()).toList();
    } else if (changedPartners.isNotEmpty) {
      result['partners'] = changedPartners;
    }

    if (dirtyFields.isNotEmpty) {
      result['dirty_fields'] = dirtyFields.toList();
    }

    return result;
  }

  @override
  String toJson() => jsonEncode(toMap());

  factory BusinessPartnersValues.fromJson(String source) =>
      BusinessPartnersValues.fromMap(jsonDecode(source));
}
