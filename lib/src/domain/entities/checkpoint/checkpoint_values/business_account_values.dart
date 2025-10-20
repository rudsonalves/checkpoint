import 'base_checkpoint_values.dart';

class BusinessAccountValues extends BaseCheckpointValues {
  final String cnpj;
  final String municipalRegistration;
  final String legalName;
  final String tradeName;
  final String phone;
  final String revenueOptionId;
  final String zipCode;
  final String state;
  final String city;
  final String neighborhood;
  final String streetAddress;
  final String number;
  final String complement;
  final DateTime addressStartDate;
  final String email;
  final String openingDate;

  const BusinessAccountValues({
    required this.cnpj,
    required this.municipalRegistration,
    required this.legalName,
    required this.tradeName,
    required this.phone,
    required this.revenueOptionId,
    required this.zipCode,
    required this.state,
    required this.city,
    required this.neighborhood,
    required this.streetAddress,
    required this.number,
    required this.complement,
    required this.addressStartDate,
    required this.email,
    required this.openingDate,
  });

  BusinessAccountValues copyWith({
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
    return BusinessAccountValues(
      cnpj: cnpj ?? this.cnpj,
      municipalRegistration:
          municipalRegistration ?? this.municipalRegistration,
      legalName: legalName ?? this.legalName,
      tradeName: tradeName ?? this.tradeName,
      phone: phone ?? this.phone,
      revenueOptionId: revenueOptionId ?? this.revenueOptionId,
      zipCode: zipCode ?? this.zipCode,
      state: state ?? this.state,
      city: city ?? this.city,
      neighborhood: neighborhood ?? this.neighborhood,
      streetAddress: streetAddress ?? this.streetAddress,
      number: number ?? this.number,
      complement: complement ?? this.complement,
      addressStartDate: addressStartDate ?? this.addressStartDate,
      email: email ?? this.email,
      openingDate: openingDate ?? this.openingDate,
    );
  }

  factory BusinessAccountValues.fromMap(Map<String, dynamic> map) {
    return BusinessAccountValues(
      cnpj: map['cnpj'] ?? '',
      municipalRegistration: map['municipal_registration'] ?? '',
      legalName: map['legal_name'] ?? '',
      tradeName: map['trade_name'] ?? '',
      phone: map['phone'] ?? '',
      revenueOptionId: map['revenue_option_id'] ?? '',
      zipCode: map['zip_code'] ?? '',
      state: map['state'] ?? '',
      city: map['city'] ?? '',
      neighborhood: map['neighborhood'] ?? '',
      streetAddress: map['street_address'] ?? '',
      number: map['number'] ?? '',
      complement: map['complement'] ?? '',
      addressStartDate: DateTime.parse(map['address_start_date'] ?? ''),
      email: map['email'] ?? '',
      openingDate: map['opening_date'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'cnpj': cnpj,
      'municipal_registration': municipalRegistration,
      'legal_name': legalName,
      'trade_name': tradeName,
      'phone': phone,
      'revenue_option_id': revenueOptionId,
      'zip_code': zipCode,
      'state': state,
      'city': city,
      'neighborhood': neighborhood,
      'street_address': streetAddress,
      'number': number,
      'complement': complement,
      'address_start_date': addressStartDate.toIso8601String(),
      'email': email,
      'opening_date': openingDate,
    };
  }

  @override
  List<Object?> get props => [
    cnpj,
    municipalRegistration,
    legalName,
    tradeName,
    phone,
    revenueOptionId,
    zipCode,
    state,
    city,
    neighborhood,
    streetAddress,
    number,
    complement,
    addressStartDate,
    email,
    openingDate,
  ];
}
