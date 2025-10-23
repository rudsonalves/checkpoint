import 'package:equatable/equatable.dart';

import '/domain/enums/checkpoint_enum.dart';
import 'business_account_values.dart';
import 'business_partners_values.dart';
import 'personal_account_values.dart';

export '/domain/enums/checkpoint_enum.dart';
export 'business_account_values.dart';
export 'business_partners_values.dart';
export 'personal_account_values.dart';

abstract class BaseCheckpointValues extends Equatable {
  const BaseCheckpointValues();

  CheckpointStage get stage;

  Map<String, dynamic> toMap();
}

extension BaseCheckpointValuesStage on BaseCheckpointValues {
  CheckpointStage get stage {
    return switch (this) {
      PersonalAccountValues _ => CheckpointStage.createPersonalAccount,
      BusinessAccountValues _ => CheckpointStage.createBusinessAccount,
      BusinessPartnersValues _ => CheckpointStage.registerBusinessPartners,
      _ => CheckpointStage.unknown,
    };
  }
}
