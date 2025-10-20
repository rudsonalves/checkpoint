import 'base_checkpoint_values.dart';

class BusinessPartnersValues extends BaseCheckpointValues {
  final String companyId;
  final String fullName;
  final String email;
  final bool isPoliticallyExposed;
  final String zipCode;
  final String state;
  final String city;
  final String district;
  final String street;
  final String number;
  final String? complement;

  const BusinessPartnersValues({
    required this.companyId,
    required this.fullName,
    required this.email,
    required this.isPoliticallyExposed,
    required this.zipCode,
    required this.state,
    required this.city,
    required this.district,
    required this.street,
    required this.number,
    this.complement,
  });

  BusinessPartnersValues copyWith({
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
    return BusinessPartnersValues(
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

  factory BusinessPartnersValues.fromMap(Map<String, dynamic> map) {
    return BusinessPartnersValues(
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
