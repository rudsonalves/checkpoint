enum CheckpointStage {
  noExistAccount('no_exist_account'),
  createPersonalAccount('create_personal_account'),
  createBusinessAccount('create_business_account'),
  registerBusinessPartners('register_business_partners'),
  unknown('unknown');

  final String stageName;
  const CheckpointStage(this.stageName);

  static CheckpointStage fromString(String value) => values.firstWhere(
    (cp) => cp.stageName == value,
    orElse: () => CheckpointStage.unknown,
  );
}
