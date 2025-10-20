import 'package:equatable/equatable.dart';

abstract class BaseCheckpointValues extends Equatable {
  const BaseCheckpointValues();

  Map<String, dynamic> toMap();
}
