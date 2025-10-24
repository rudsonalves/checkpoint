import 'base_checkpoint_values.dart';

class PersonalAccountValues extends BaseCheckpointValues {
  String _name = '';
  String _cpf = '';
  String _email = '';
  String _phone = '';
  String _password = '';
  String _passwordConfirmation = '';
  String _rgNumber = '';
  String _rgIssuer = '';
  String _rgIssuerStateId = '';
  String _rgIssuerStateAbbreviation = '';
  DateTime _rgIssueDate = DateTime.now();

  String get name => _name;
  String get cpf => _cpf;
  String get email => _email;
  String get phone => _phone;
  String get password => _password;
  String get passwordConfirmation => _passwordConfirmation;
  String get rgNumber => _rgNumber;
  String get rgIssuer => _rgIssuer;
  String get rgIssuerStateId => _rgIssuerStateId;
  String get rgIssuerStateAbbreviation => _rgIssuerStateAbbreviation;
  DateTime get rgIssueDate => _rgIssueDate;

  @override
  CheckpointStage get stage => CheckpointStage.createPersonalAccount;

  set name(String value) {
    if (_name != value) {
      _name = value;
      markDirty('name');
    }
  }

  set cpf(String value) {
    if (_cpf != value) {
      _cpf = value;
      markDirty('federal_document');
    }
  }

  set email(String value) {
    if (_email != value) {
      _email = value;
      markDirty('email');
    }
  }

  set phone(String value) {
    if (_phone != value) {
      _phone = value;
      markDirty('phone');
    }
  }

  set password(String value) {
    if (_password != value) {
      _password = value;
      markDirty('password');
    }
  }

  set passwordConfirmation(String value) {
    if (_passwordConfirmation != value) {
      _passwordConfirmation = value;
      markDirty('password_confirmation');
    }
  }

  set rgNumber(String value) {
    if (_rgNumber != value) {
      _rgNumber = value;
      markDirty('rg_number');
    }
  }

  set rgIssuer(String value) {
    if (_rgIssuer != value) {
      _rgIssuer = value;
      markDirty('rg_issuer');
    }
  }

  set rgIssuerStateId(String value) {
    if (_rgIssuerStateId != value) {
      _rgIssuerStateId = value;
      markDirty('rg_issuer_state_id');
    }
  }

  set rgIssuerStateAbbreviation(String value) {
    if (_rgIssuerStateAbbreviation != value) {
      _rgIssuerStateAbbreviation = value;
      markDirty('rg_issuer_state_abbreviation');
    }
  }

  set rgIssueDate(DateTime value) {
    if (_rgIssueDate != value) {
      _rgIssueDate = value;
      markDirty('rg_issue_date');
    }
  }

  PersonalAccountValues({
    String name = '',
    String cpf = '',
    String email = '',
    String phone = '',
    String password = '',
    String passwordConfirmation = '',
    String rgNumber = '',
    String rgIssuer = '',
    String rgIssuerStateId = '',
    DateTime? rgIssueDate,
    String rgIssuerStateAbbreviation = '',
  }) : _name = name,
       _cpf = cpf,
       _email = email,
       _phone = phone,
       _password = password,
       _passwordConfirmation = passwordConfirmation,
       _rgNumber = rgNumber,
       _rgIssuer = rgIssuer,
       _rgIssuerStateId = rgIssuerStateId,
       _rgIssueDate = rgIssueDate ?? DateTime.now(),
       _rgIssuerStateAbbreviation = rgIssuerStateAbbreviation;

  factory PersonalAccountValues.empty() => PersonalAccountValues();

  factory PersonalAccountValues.fromMap(Map<String, dynamic> map) {
    final instance = PersonalAccountValues(
      name: map['name'] ?? '',
      cpf: map['federal_document'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      password: map['password'] ?? '',
      passwordConfirmation: map['password_confirmation'] ?? '',
      rgNumber: map['rg_number'] ?? '',
      rgIssuer: map['rg_issuer'] ?? '',
      rgIssuerStateId: map['rg_issuer_state_id'] ?? '',
      rgIssueDate:
          DateTime.tryParse(map['rg_issue_date'] ?? '') ?? DateTime.now(),
      rgIssuerStateAbbreviation: map['rg_issuer_state_abbreviation'] ?? '',
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
      'name': _name,
      'federal_document': _cpf,
      'email': _email,
      'phone': _phone,
      'password': _password,
      'password_confirmation': _passwordConfirmation,
      'rg_number': _rgNumber,
      'rg_issuer': _rgIssuer,
      'rg_issuer_state_id': _rgIssuerStateId,
      'rg_issue_date': _rgIssueDate.toIso8601String(),
      'rg_issuer_state_abbreviation': _rgIssuerStateAbbreviation,
      'dirty_fields': dirtyFields.toList(),
    };
  }
}
