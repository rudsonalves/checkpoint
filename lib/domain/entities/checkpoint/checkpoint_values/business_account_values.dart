import 'dart:convert';

import 'base_checkpoint_values.dart';

class BusinessAccountValues extends BaseCheckpointValues {
  String _cnpj;
  String _municipalRegistration;
  String _legalName;
  String _tradeName;
  DateTime _openingDate;
  String _phone;
  String _email;
  String _averageMonthlyRevenue;
  String _revenueOptionId;
  String _zipCode;
  String _state;
  String _city;
  String _neighborhood;
  String _streetAddress;
  String _number;
  String _complement;
  DateTime _addressStartDate;

  String get cnpj => _cnpj;
  String get municipalRegistration => _municipalRegistration;
  String get legalName => _legalName;
  String get tradeName => _tradeName;
  DateTime get openingDate => _openingDate;
  String get phone => _phone;
  String get email => _email;
  String get averageMonthlyRevenue => _averageMonthlyRevenue;
  String get revenueOptionId => _revenueOptionId;
  String get zipCode => _zipCode;
  String get state => _state;
  String get city => _city;
  String get neighborhood => _neighborhood;
  String get streetAddress => _streetAddress;
  String get number => _number;
  String get complement => _complement;
  DateTime get addressStartDate => _addressStartDate;

  @override
  CheckpointStage get stage => CheckpointStage.createBusinessAccount;

  set cnpj(String value) {
    if (_cnpj != value) {
      _cnpj = value;
      markDirty('cnpj');
    }
  }

  set municipalRegistration(String value) {
    if (_municipalRegistration != value) {
      _municipalRegistration = value;
      markDirty('municipal_registration');
    }
  }

  set legalName(String value) {
    if (_legalName != value) {
      _legalName = value;
      markDirty('legal_name');
    }
  }

  set tradeName(String value) {
    if (_tradeName != value) {
      _tradeName = value;
      markDirty('trade_name');
    }
  }

  set openingDate(DateTime value) {
    if (_openingDate != value) {
      _openingDate = value;
      markDirty('opening_date');
    }
  }

  set phone(String value) {
    if (_phone != value) {
      _phone = value;
      markDirty('phone');
    }
  }

  set email(String value) {
    if (_email != value) {
      _email = value;
      markDirty('email');
    }
  }

  set averageMonthlyRevenue(String value) {
    if (_averageMonthlyRevenue != value) {
      _averageMonthlyRevenue = value;
      markDirty('average_monthly_revenue');
    }
  }

  set revenueOptionId(String value) {
    if (_revenueOptionId != value) {
      _revenueOptionId = value;
      markDirty('revenue_option_id');
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

  set neighborhood(String value) {
    if (_neighborhood != value) {
      _neighborhood = value;
      markDirty('neighborhood');
    }
  }

  set streetAddress(String value) {
    if (_streetAddress != value) {
      _streetAddress = value;
      markDirty('street_address');
    }
  }

  set number(String value) {
    if (_number != value) {
      _number = value;
      markDirty('number');
    }
  }

  set complement(String value) {
    if (_complement != value) {
      _complement = value;
      markDirty('complement');
    }
  }

  set addressStartDate(DateTime value) {
    if (_addressStartDate != value) {
      _addressStartDate = value;
      markDirty('address_start_date');
    }
  }

  BusinessAccountValues({
    String cnpj = '',
    String municipalRegistration = '',
    String legalName = '',
    String tradeName = '',
    DateTime? openingDate,
    String phone = '',
    String email = '',
    String averageMonthlyRevenue = '',
    String revenueOptionId = '',
    String zipCode = '',
    String state = '',
    String city = '',
    String neighborhood = '',
    String streetAddress = '',
    String number = '',
    String complement = '',
    DateTime? addressStartDate,
  }) : _cnpj = cnpj,
       _municipalRegistration = municipalRegistration,
       _legalName = legalName,
       _tradeName = tradeName,
       _openingDate = openingDate ?? DateTime.now(),
       _phone = phone,
       _email = email,
       _averageMonthlyRevenue = averageMonthlyRevenue,
       _revenueOptionId = revenueOptionId,
       _zipCode = zipCode,
       _state = state,
       _city = city,
       _neighborhood = neighborhood,
       _streetAddress = streetAddress,
       _number = number,
       _complement = complement,
       _addressStartDate = addressStartDate ?? DateTime.now();

  factory BusinessAccountValues.empty() => BusinessAccountValues();

  factory BusinessAccountValues.fromMap(Map<String, dynamic> map) {
    final instance = BusinessAccountValues(
      cnpj: map['cnpj'] ?? '',
      municipalRegistration: map['municipal_registration'] ?? '',
      legalName: map['legal_name'] ?? '',
      tradeName: map['trade_name'] ?? '',
      openingDate: DateTime.tryParse(map['opening_date']) ?? DateTime.now(),
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      averageMonthlyRevenue: map['average_monthly_revenue'] ?? '',
      revenueOptionId: map['revenue_option_id'] ?? '',
      zipCode: map['zip_code'] ?? '',
      state: map['state'] ?? '',
      city: map['city'] ?? '',
      neighborhood: map['neighborhood'] ?? '',
      streetAddress: map['street_address'] ?? '',
      number: map['number'] ?? '',
      complement: map['complement'] ?? '',
      addressStartDate:
          DateTime.tryParse(map['address_start_date']) ?? DateTime.now(),
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
      'cnpj': cnpj,
      'municipal_registration': municipalRegistration,
      'legal_name': legalName,
      'trade_name': tradeName,
      'opening_date': openingDate.toIso8601String(),
      'phone': phone,
      'email': email,
      'average_monthly_revenue': averageMonthlyRevenue,
      'revenue_option_id': revenueOptionId,
      'zip_code': zipCode,
      'state': state,
      'city': city,
      'neighborhood': neighborhood,
      'street_address': streetAddress,
      'number': number,
      'complement': complement,
      'address_start_date': addressStartDate.toIso8601String(),
      'dirty_fields': dirtyFields.toList(),
    };
  }

  @override
  String toJson() => jsonEncode(toMap());

  factory BusinessAccountValues.fromJson(String source) =>
      BusinessAccountValues.fromMap(jsonDecode(source));
}
