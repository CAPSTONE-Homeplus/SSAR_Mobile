class TimeSlot {
  String? id;
  String? startTime;
  String? endTime;
  String? description;
  String? status;
  String? code;

  TimeSlot({
    this.id,
    this.startTime,
    this.endTime,
    this.description,
    this.status,
    this.code,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TimeSlot &&
        other.id == id &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.description == description &&
        other.status == status &&
        other.code == code;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        description.hashCode ^
        status.hashCode ^
        code.hashCode;
  }
}
