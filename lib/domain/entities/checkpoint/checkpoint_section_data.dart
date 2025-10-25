import 'dart:convert';

import 'checkpoint_values/base_checkpoint_values.dart';

abstract class CheckpointSectionData {
  const CheckpointSectionData();

  factory CheckpointSectionData.fromMap({
    required CheckpointStage stage,
    required Map<String, dynamic> data,
  }) {
    switch (stage) {
      case CheckpointStage.createPersonalAccount:
        return CheckpointSection(
          values: PersonalAccountValues.fromMap(data),
        );

      case CheckpointStage.createBusinessAccount:
        return CheckpointSection(
          values: BusinessAccountValues.fromMap(data),
        );

      case CheckpointStage.registerBusinessPartners:
        return CheckpointSection(
          values: BusinessPartnersValues.fromMap(data),
        );

      case CheckpointStage.noExistAccount:
      case CheckpointStage.unknown:
        return const EmptySection();
    }
  }

  factory CheckpointSectionData.fromJson({
    required CheckpointStage stage,
    required String json,
  }) {
    switch (stage) {
      case CheckpointStage.createPersonalAccount:
        return CheckpointSection(
          values: PersonalAccountValues.fromJson(json),
        );
      case CheckpointStage.createBusinessAccount:
        return CheckpointSection(
          values: BusinessAccountValues.fromJson(json),
        );
      case CheckpointStage.registerBusinessPartners:
        return CheckpointSection(
          values: BusinessPartnersValues.fromJson(json),
        );
      case CheckpointStage.noExistAccount:
      case CheckpointStage.unknown:
        return const EmptySection();
    }
  }

  Map<String, dynamic> toMap();

  String toJson();
}

class EmptySection extends CheckpointSectionData {
  const EmptySection();

  @override
  Map<String, dynamic> toMap() => {};

  @override
  String toJson() => '{}';
}

class CheckpointSection<T extends BaseCheckpointValues>
    extends CheckpointSectionData {
  final T values;

  const CheckpointSection({required this.values});

  @override
  Map<String, dynamic> toMap() => values.toMap();

  @override
  String toJson() => jsonEncode(toMap());
}
