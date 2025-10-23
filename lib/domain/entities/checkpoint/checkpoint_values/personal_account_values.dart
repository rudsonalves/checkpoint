import 'base_checkpoint_values.dart';

class PersonalAccountValues extends BaseCheckpointValues {
  final String name;
  final String cpf;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final String rgNumber;
  final String rgIssuer;
  final String rgIssuerStateId;
  final String rgIssuerStateAbbreviation;
  final DateTime rgIssueDate;

  const PersonalAccountValues({
    required this.name,
    required this.cpf,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    required this.rgNumber,
    required this.rgIssuer,
    required this.rgIssuerStateId,
    required this.rgIssueDate,
    required this.rgIssuerStateAbbreviation,
  });

  @override
  CheckpointStage get stage => CheckpointStage.createPersonalAccount;

  factory PersonalAccountValues.empty() {
    return PersonalAccountValues(
      name: '',
      cpf: '',
      email: '',
      phone: '',
      password: '',
      passwordConfirmation: '',
      rgNumber: '',
      rgIssuer: '',
      rgIssuerStateId: '',
      rgIssuerStateAbbreviation: '',
      rgIssueDate: DateTime.now(),
    );
  }

  PersonalAccountValues copyWith({
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
    return PersonalAccountValues(
      name: name ?? this.name,
      cpf: cpf ?? this.cpf,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      rgNumber: rgNumber ?? this.rgNumber,
      rgIssuer: rgIssuer ?? this.rgIssuer,
      rgIssuerStateId: rgIssuerStateId ?? this.rgIssuerStateId,
      rgIssuerStateAbbreviation:
          rgIssuerStateAbbreviation ?? this.rgIssuerStateAbbreviation,
      rgIssueDate: rgIssueDate ?? this.rgIssueDate,
    );
  }

  factory PersonalAccountValues.fromMap(Map<String, dynamic> map) {
    return PersonalAccountValues(
      name: map['name'] ?? '',
      cpf: map['federal_document'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      password: map['password'] ?? '',
      passwordConfirmation: map['password_confirmation'] ?? '',
      rgNumber: map['rg_number'] ?? '',
      rgIssuer: map['rg_issuer'] ?? '',
      rgIssuerStateId: map['rg_issuer_state_id'] ?? '',
      rgIssueDate: DateTime.parse(map['rg_issue_date'] ?? ''),
      rgIssuerStateAbbreviation: map['rg_issuer_state_abbreviation'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'federal_document': cpf,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'rg_number': rgNumber,
      'rg_issuer': rgIssuer,
      'rg_issuer_state_id': rgIssuerStateId,
      'rg_issue_date': rgIssueDate.toIso8601String(),
      'rg_issuer_state_abbreviation': rgIssuerStateAbbreviation,
    };
  }

  @override
  List<Object?> get props => [
    name,
    cpf,
    email,
    phone,
    password,
    passwordConfirmation,
    rgNumber,
    rgIssuer,
    rgIssuerStateId,
    rgIssueDate,
    rgIssuerStateAbbreviation,
  ];
}
