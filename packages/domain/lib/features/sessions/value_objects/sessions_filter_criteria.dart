import 'package:domain/features/shared/value_objects/filter_criteria.dart';

class SessionsFilterCriteria extends FilterCriteria {
  final String? title;
  final String? groupId;
  final List<String>? sports;
  final DateTime? startTimeFrom;
  final DateTime? startTimeTo;
  final Duration? minDuration;
  final Duration? maxDuration;
  final List<String> assignedGroups;
  final List<String> selectedAthletes;

  SessionsFilterCriteria({
    this.title,
    this.groupId,
    this.sports = const [],
    this.startTimeFrom,
    this.startTimeTo,
    this.minDuration,
    this.maxDuration,
    this.assignedGroups = const [],
    this.selectedAthletes = const [],
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'groupId': groupId,
      'sports': sports,
      'startTimeFrom': startTimeFrom?.toIso8601String(),
      'startTimeTo': startTimeTo?.toIso8601String(),
      'minDuration': minDuration?.inSeconds,
      'maxDuration': maxDuration?.inSeconds,
      'assignedGroups': assignedGroups,
      'selectedAthletes': selectedAthletes,
    };
  }

  SessionsFilterCriteria copyWith({
    String? title,
    String? groupId,
    DateTime? startTimeFrom,
    DateTime? startTimeTo,
    Duration? minDuration,
    Duration? maxDuration,
    bool clearDates = false,
    List<String>? sports,
    List<String>? assignedGroups,
    List<String>? selectedAthletes,
  }) {
    return SessionsFilterCriteria(
      title: title ?? this.title,
      groupId: groupId ?? this.groupId,
      sports: sports ?? this.sports,
      startTimeFrom: clearDates ? null : startTimeFrom ?? this.startTimeFrom,
      startTimeTo: clearDates ? null : startTimeTo ?? this.startTimeTo,
      minDuration: minDuration ?? this.minDuration,
      maxDuration: maxDuration ?? this.maxDuration,
      assignedGroups: assignedGroups ?? this.assignedGroups,
      selectedAthletes: selectedAthletes ?? this.selectedAthletes,
    );
  }

  @override
  List<Object?> get props => [
        title,
        groupId,
        sports,
        startTimeFrom,
        startTimeTo,
        minDuration,
        maxDuration,
        assignedGroups,
        selectedAthletes,
      ];
}
