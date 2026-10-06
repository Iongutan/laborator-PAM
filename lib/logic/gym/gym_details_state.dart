import 'package:equatable/equatable.dart';

import '../../data/models/gym_models.dart';
import '../load_status.dart';

class GymDetailsState extends Equatable {
  const GymDetailsState({
    this.status = LoadStatus.initial,
    this.details,
    this.descriptionExpanded = false,
    this.reserved = false,
    this.errorMessage,
  });

  final LoadStatus status;
  final GymDetails? details;
  final bool descriptionExpanded;
  final bool reserved;
  final String? errorMessage;

  GymDetailsState copyWith({
    LoadStatus? status,
    GymDetails? details,
    bool? descriptionExpanded,
    bool? reserved,
    String? errorMessage,
  }) =>
      GymDetailsState(
        status: status ?? this.status,
        details: details ?? this.details,
        descriptionExpanded: descriptionExpanded ?? this.descriptionExpanded,
        reserved: reserved ?? this.reserved,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props =>
      [status, details, descriptionExpanded, reserved, errorMessage];
}
